import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/core/network/api_client.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/services/storage_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialise core services before the widget tree is built ──────
  // StorageService must be ready before ApiClient (the token interceptor
  // reads from it). GetX calls onInit() automatically on registration —
  // do NOT call it manually or lifecycle-bound fields get initialised twice.
  await Get.putAsync<StorageService>(() async => StorageService(),
      permanent: true);

  ApiClient.instance.init();

  final authService = Get.put<AuthService>(AuthService(), permanent: true);
  await authService.initAuth();

  runApp(const TrustFundApp());
}

class TrustFundApp extends StatelessWidget {
  const TrustFundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'TrustFund',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
