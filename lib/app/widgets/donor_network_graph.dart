import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/url_launcher_helper.dart';
import '../data/models/donor_graph.dart';

/// Hub-and-spoke "Jaringan Donatur" visualization.
///
/// The campaign sits in the middle as a vault-styled hub; donors orbit it,
/// each connected by a link. The signed-in user's own donation is highlighted
/// (teal, ring outline, thicker link) so it stands out in the crowd. Donors
/// beyond the listed ones collapse into a single dashed "+N donatur lain"
/// node.
///
/// The whole point of this widget is to hide explorer complexity from lay
/// donors: raw PolygonScan pages only open when the user deliberately taps a
/// verify action (node sheet or the collapsible tech section below).
class DonorNetworkGraph extends StatefulWidget {
  final DonorGraph graph;

  const DonorNetworkGraph({super.key, required this.graph});

  @override
  State<DonorNetworkGraph> createState() => _DonorNetworkGraphState();
}

class _DonorNetworkGraphState extends State<DonorNetworkGraph>
    with TickerProviderStateMixin {
  /// Highlight palette for the current user's node.
  static const Color _teal = Color(0xFF0D9488);
  static const Color _tealBg = Color(0xFFCCFBF1);

  /// Cap on individual donor nodes; the rest fold into the "+N" node.
  static const int _maxDonorNodes = 8;

  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  late final AnimationController _flow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  bool _showTech = false;

  @override
  void didUpdateWidget(DonorNetworkGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graph.campaignId != widget.graph.campaignId ||
        oldWidget.graph.donations.length != widget.graph.donations.length) {
      _intro.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _flow.dispose();
    super.dispose();
  }

  DonorGraph get graph => widget.graph;

  List<DonorGraphDonation> get _shownDonations =>
      graph.donations.take(_maxDonorNodes).toList();

  /// Donors folded into the "+N donatur lain" node.
  int get _foldedCount =>
      graph.remainingDonorCount +
      (graph.donations.length - _shownDonations.length);

  @override
  Widget build(BuildContext context) {
    if (graph.donations.isEmpty && graph.donorCount == 0) {
      return _buildEmpty();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 330.h, child: LayoutBuilder(builder: _buildGraph)),
        SizedBox(height: AppSpacing.lg.h),
        _buildSummaryChips(),
        SizedBox(height: AppSpacing.lg.h),
        _buildTechSection(),
      ],
    );
  }

  // ── Graph area ──────────────────────────────────────────────────────────

  Widget _buildGraph(BuildContext context, BoxConstraints constraints) {
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final center = Offset(size.width / 2, size.height / 2);

    final hubRadius = 52.w;
    final donorRadius = 33.w;

    final donations = _shownDonations;
    final hasMoreNode = _foldedCount > 0;
    final nodeCount = donations.length + (hasMoreNode ? 1 : 0);

    final orbit = math.min(size.width, size.height) / 2 - donorRadius - 2;

    final nodes = <_NodeLayout>[];
    for (var i = 0; i < nodeCount; i++) {
      final angle = -math.pi / 2 + 2 * math.pi * i / nodeCount;
      nodes.add(
        _NodeLayout(
          position: center +
              Offset(orbit * math.cos(angle), orbit * math.sin(angle)),
          radius: donorRadius,
          donation: i < donations.length ? donations[i] : null,
          appearInterval: _staggerInterval(i, nodeCount),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: Listenable.merge([_intro, _flow]),
            builder: (_, _) => CustomPaint(
              painter: _LinkPainter(
                center: center,
                hubRadius: hubRadius,
                nodes: nodes,
                intro: _intro.value,
                flow: _flow.value,
                teal: _teal,
              ),
            ),
          ),
        ),
        for (final node in nodes) _buildDonorNode(node),
        _buildHub(center, hubRadius),
      ],
    );
  }

  Interval _staggerInterval(int index, int count) {
    const span = 0.55; // each node animates over 55% of the intro timeline
    final start = count <= 1 ? 0.0 : (1 - span) * index / (count - 1);
    return Interval(start, start + span, curve: Curves.easeOutBack);
  }

  Widget _buildHub(Offset center, double radius) {
    return Positioned(
      left: center.dx - radius,
      top: center.dy - radius,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded,
                color: AppColors.white, size: 22.sp),
            SizedBox(height: 2.h),
            Text(
              graph.campaignName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.c2Medium.copyWith(
                color: AppColors.white,
                fontSize: 9.sp,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorNode(_NodeLayout node) {
    final donation = node.donation;
    final isUser = donation?.isCurrentUser ?? false;

    final circle = donation == null
        ? _buildMoreCircle(node.radius)
        : _buildDonorCircle(donation, node.radius, isUser);

    return Positioned(
      left: node.position.dx - node.radius,
      top: node.position.dy - node.radius,
      child: AnimatedBuilder(
        animation: _intro,
        builder: (_, child) {
          final t = node.appearInterval.transform(_intro.value);
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(scale: 0.6 + 0.4 * t, child: child),
          );
        },
        child: GestureDetector(
          onTap: donation == null ? null : () => _showDonationSheet(donation),
          child: circle,
        ),
      ),
    );
  }

  Widget _buildDonorCircle(
      DonorGraphDonation donation, double radius, bool isUser) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: isUser ? _tealBg : AppColors.pillBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: isUser ? _teal : AppColors.border,
          width: isUser ? 2.5 : 1,
        ),
        boxShadow: isUser
            ? [
                BoxShadow(
                  color: _teal.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isUser ? 'Kamu' : donation.donorName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.c2Medium.copyWith(
              fontSize: 8.5.sp,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: isUser ? _teal : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            donation.amountFormatted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.c2Regular.copyWith(
              fontSize: 8.sp,
              height: 1.2,
              color: isUser ? _teal : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreCircle(double radius) {
    return CustomPaint(
      painter: _DashedCirclePainter(color: AppColors.iconMuted),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.pillBg.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: Text(
          '+$_foldedCount donatur lain',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: AppTextStyles.c2Regular.copyWith(
            fontSize: 8.5.sp,
            height: 1.25,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Node detail sheet ───────────────────────────────────────────────────

  /// Friendly per-donation sheet. The raw explorer page only opens from the
  /// verify button here — never automatically.
  void _showDonationSheet(DonorGraphDonation donation) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
            AppSpacing.xl.w, AppSpacing.lg.h, AppSpacing.xl.w, AppSpacing.xl.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    donation.isCurrentUser
                        ? 'Donasimu'
                        : donation.donorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h4Bold
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Tercatat on-chain',
                    style: AppTextStyles.c2Medium
                        .copyWith(color: AppColors.success),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              donation.amountFormatted,
              style: AppTextStyles.h3Bold.copyWith(color: AppColors.primary),
            ),
            if (donation.shortTxHash.isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm.h),
              Text(
                'Hash transaksi: ${donation.shortTxHash}',
                style: AppTextStyles.c1Regular
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
            SizedBox(height: AppSpacing.lg.h),
            _buildVerifyButton(donation.explorerUrl),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ── Summary chips ───────────────────────────────────────────────────────

  Widget _buildSummaryChips() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm.w,
      runSpacing: AppSpacing.sm.h,
      children: [
        _summaryChip(Icons.people_alt_outlined, '${graph.donorCount} Donatur'),
        _summaryChip(Icons.favorite_outline_rounded, graph.totalRaisedFormatted),
        _summaryChip(Icons.lock_outline_rounded, 'On-chain'),
      ],
    );
  }

  Widget _summaryChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w, vertical: AppSpacing.xs.h),
      decoration: BoxDecoration(
        color: AppColors.summaryBoxBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.primary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.c2Medium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Collapsible tech details ────────────────────────────────────────────

  Widget _buildTechSection() {
    var donation = graph.currentUserDonation;
    if (donation == null) {
      for (final d in graph.donations) {
        if (d.explorerUrl.isNotEmpty) {
          donation = d;
          break;
        }
      }
    }
    if (donation == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            onTap: () => setState(() => _showTech = !_showTech),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg.w, vertical: AppSpacing.md.h),
              child: Row(
                children: [
                  Icon(Icons.code_rounded,
                      size: 18.sp, color: AppColors.textSecondary),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Text(
                      'Lihat detail teknis',
                      style: AppTextStyles.c1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _showTech ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 20.sp, color: AppColors.iconMuted),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _showTech
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.lg.w, 0, AppSpacing.lg.w,
                  AppSpacing.lg.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.isCurrentUser
                        ? 'Hash transaksi donasimu'
                        : 'Hash transaksi donasi terbaru',
                    style: AppTextStyles.c2Regular
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    donation.shortTxHash.isEmpty ? '-' : donation.shortTxHash,
                    style: AppTextStyles.c1Medium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  _buildVerifyButton(donation.explorerUrl,
                      label: 'Verifikasi mandiri di explorer'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(String explorerUrl,
      {String label = 'Verifikasi di explorer'}) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: () => openExternalUrl(explorerUrl),
        child: Container(
          width: double.infinity,
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.open_in_new_rounded,
                  size: 16.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                label,
                style: AppTextStyles.c1Medium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl.h),
      child: Column(
        children: [
          Icon(Icons.volunteer_activism_outlined,
              size: 40.sp, color: AppColors.iconMuted),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            'Belum ada donatur.\nJadilah yang pertama membantu!',
            textAlign: TextAlign.center,
            style:
                AppTextStyles.c1Regular.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Resolved position + metadata for one orbiting node.
class _NodeLayout {
  final Offset position;
  final double radius;

  /// Null for the "+N donatur lain" node.
  final DonorGraphDonation? donation;

  final Interval appearInterval;

  const _NodeLayout({
    required this.position,
    required this.radius,
    required this.donation,
    required this.appearInterval,
  });
}

/// Paints the spoke links plus the small "funds flowing in" dots that travel
/// from each donor node toward the hub.
class _LinkPainter extends CustomPainter {
  final Offset center;
  final double hubRadius;
  final List<_NodeLayout> nodes;
  final double intro;
  final double flow;
  final Color teal;

  _LinkPainter({
    required this.center,
    required this.hubRadius,
    required this.nodes,
    required this.intro,
    required this.flow,
    required this.teal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final appear = node.appearInterval.transform(intro).clamp(0.0, 1.0);
      if (appear <= 0) continue;

      final isUser = node.donation?.isCurrentUser ?? false;
      final isMore = node.donation == null;

      final direction = (center - node.position);
      final distance = direction.distance;
      if (distance < 1) continue;
      final unit = direction / distance;

      final start = node.position + unit * node.radius;
      final end = center - unit * hubRadius;

      final linePaint = Paint()
        ..strokeWidth = isUser ? 2.4 : 1.1
        ..strokeCap = StrokeCap.round
        ..color = (isUser ? teal : AppColors.border)
            .withValues(alpha: appear * (isMore ? 0.6 : 1.0));
      canvas.drawLine(start, end, linePaint);

      // Flow dot: a small pulse travelling donor → hub once the node is in.
      if (!isMore && appear >= 1) {
        final t = (flow + i * 0.17) % 1.0;
        final dotPos = Offset.lerp(start, end, Curves.easeIn.transform(t))!;
        // Fade the dot in near the donor and out as it reaches the vault.
        final fade = (t < 0.15
                ? t / 0.15
                : (t > 0.85 ? (1 - t) / 0.15 : 1.0))
            .clamp(0.0, 1.0);
        final dotPaint = Paint()
          ..color = (isUser ? teal : AppColors.primaryLight)
              .withValues(alpha: 0.85 * fade);
        canvas.drawCircle(dotPos, isUser ? 3.2 : 2.4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LinkPainter oldDelegate) =>
      oldDelegate.intro != intro ||
      oldDelegate.flow != flow ||
      oldDelegate.nodes != nodes;
}

/// Dashed ring for the "+N donatur lain" node.
class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = color.withValues(alpha: 0.7);

    const dashCount = 22;
    const gapFraction = 0.45;
    final sweep = 2 * math.pi / dashCount;
    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep,
        sweep * (1 - gapFraction),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
