import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/auth/data/repo/auth_repo.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/repo/recharge_repo.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_cubit.dart';
import 'package:ehtemam_final_project/features/splash/manager/splash_cubit.dart';
import 'package:ehtemam_final_project/features/splash/ui/screens/splash_screen.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/screens/task_progress_screen.dart';
import 'package:ehtemam_final_project/features/tasks/ui/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: DevicePreview(builder: (_) => MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PaymentCubit(PaymentRepo()),
        ),
        BlocProvider(
          create: (_) => RechargeCubit(RechargeRepo()),
        ),
         BlocProvider(
      create: (_) => AuthCubit(AuthRepo(ApiService()))), 
    BlocProvider(
      create: (_) => SplashCubit(),
    ),
  ],
    
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: SplashScreen(),
      ),
    );
  }
}