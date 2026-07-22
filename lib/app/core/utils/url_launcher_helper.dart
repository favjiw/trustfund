import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the device's external browser (used for blockchain explorer
/// links). Shows a snackbar when the URL is empty or cannot be opened.
Future<void> openExternalUrl(String? url) async {
  if (url == null || url.isEmpty) {
    Get.snackbar(
      'Tautan tidak tersedia',
      'Bukti on-chain belum tersedia untuk transaksi ini.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    Get.snackbar(
      'Tautan tidak valid',
      'Tidak dapat membuka tautan bukti.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok) {
    Get.snackbar(
      'Gagal membuka tautan',
      'Tidak ada aplikasi untuk membuka tautan ini.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
