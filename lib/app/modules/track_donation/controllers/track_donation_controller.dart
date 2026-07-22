import 'package:get/get.dart';

import '../../../data/models/disbursement_step.dart';
import '../../../data/models/donation_receipt.dart';
import '../../../data/models/milestone_item.dart';
import '../../../data/repositories/campaign_repository.dart';
import '../../../routes/app_pages.dart';

class TrackDonationController extends GetxController {
  late final DonationReceipt receipt;

  final RxString disbursedPercentLabel = '0%'.obs;
  final RxDouble disbursedProgress = 0.0.obs;
  final RxList<DisbursementStep> steps = <DisbursementStep>[].obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    receipt = arg is DonationReceipt ? arg : _fallbackReceipt();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final detail = await CampaignRepository.instance.fetchDetailById(receipt.campaignId);
      
      final mappedSteps = <DisbursementStep>[];
      int totalMilestones = detail.milestones.length;
      int completedMilestones = 0;

      for (var ms in detail.milestones) {
        DisbursementStatus status;
        if (ms.status == MilestoneStatus.done) {
          status = DisbursementStatus.disbursed;
          completedMilestones++;
        } else if (ms.status == MilestoneStatus.inProgress) {
          status = DisbursementStatus.reviewing;
        } else {
          status = DisbursementStatus.waiting;
        }

        mappedSteps.add(DisbursementStep(
          title: ms.title,
          amount: ms.subtitle,
          status: status,
          detail: ms.statusLabel ?? 'Menunggu proses selanjutnya',
          hasProof: ms.status == MilestoneStatus.done,
        ));
      }

      steps.value = mappedSteps;
      
      if (totalMilestones > 0) {
        final progress = completedMilestones / totalMilestones;
        disbursedProgress.value = progress;
        disbursedPercentLabel.value = '${(progress * 100).toInt()}%';
      }
    } catch (e) {
      print('Error fetching campaign detail: $e');
    }
  }

  void viewProof(int index) {
    // Slice-only: proof deep-link is out of scope for this pass.
  }

  void backToHome() => Get.offAllNamed(Routes.BOTNAVBAR);

  DonationReceipt _fallbackReceipt() => const DonationReceipt(
        campaignId: 'cmrkpwxez0001fci7ni7koeie',
        campaignTitle: 'Bantu Renovasi Sekolah Dasar di Pelosok NTT',
        organizer: 'Yayasan Senyum Anak',
        imageUrl:
            'https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80',
        verified: true,
        amount: 50000,
        formattedAmount: 'Rp50.000',
        paymentLabel: 'BCA Virtual Account',
        vaNumber: '8808 0812 3456 7890',
        dateLabel: '02 Jun 2026, 14:32',
        transactionHash: '0x7a3f...9b21',
      );
}
