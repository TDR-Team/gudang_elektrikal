import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/modules/notification/notification.dart';
import 'package:gudang_elektrikal/initializer.dart';

import 'app/routes/app_pages.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final stopwatch = Stopwatch()..start();

  await NotificationService.init();
  await Initializer.initFirebase();
  await Initializer.init();
  runApp(const MyApp());

  final elapsed = stopwatch.elapsedMilliseconds;
  if (elapsed < 800) {
    await Future.delayed(Duration(milliseconds: 800 - elapsed));
  }
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: "Gudang Elektrikal",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
        );
      },
    );
  }
}
