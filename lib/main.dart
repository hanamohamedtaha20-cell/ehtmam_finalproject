import 'package:device_preview/device_preview.dart';
import 'package:ehtmam_finalproject/features/account_settings/ui/screens/account_settings_screen_careprovider.dart';
import 'package:ehtmam_finalproject/features/account_settings/ui/screens/account_settings_screen_user.dart';
import 'package:ehtmam_finalproject/features/auth/ui/screens/login_screen.dart';
import 'package:ehtmam_finalproject/features/bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/account_settings/manager/account_settings_cubit.dart';
import 'features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'features/onboarding/ui/screens/ob1.dart';
import 'features/splash/manager/splash_cubit.dart';
import 'features/splash/ui/screens/splash_screen.dart';void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AccountSettingsCubit(),
          ),
          BlocProvider(
            create: (context) => BottomNavCubit(),
          ),
          BlocProvider(
            create: (_) => SplashCubit(),
            child: const SplashScreen(),
          )

        ],
        child: DevicePreview(
          builder: (context) => const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ehtmam',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
      ),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: SplashScreen(),
    );
  }
}



