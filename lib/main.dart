import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() {
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
