import 'package:app_links/app_links.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/account_settings/manager/account_settings_cubit.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/screens/account_settings_screen_user.dart';
import 'package:ehtemam_final_project/features/auth/data/repo/auth_repo.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/screens/home_screen_caregiver.dart';
import 'package:ehtemam_final_project/features/map_user/ui/screens/track_caregiver_screen.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/data/repo/mytask_cg_repo.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/manager/mytask_cg_cubit.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/ui/screens/mytask_cg_screen.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment_cg/ui/screens/cg_payment_screen.dart';
import 'package:ehtemam_final_project/features/rating_overview/ui/screens/provider_reviews_screen.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/repo/recharge_repo.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_cubit.dart';
import 'package:ehtemam_final_project/features/share_location_cg/ui/screens/share_location_cg_screen.dart';
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

<<<<<<< HEAD
class MyApp extends StatelessWidget {
  const MyApp({super.key});
=======
class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.home});

  final Widget home;
>>>>>>> fe17b26ab19497cfc92167f1063a177c689dd865

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final PaymentCubit _paymentCubit;

  @override
  void initState() {
    super.initState();
    _paymentCubit = PaymentCubit(PaymentRepo())..loadData();
    _listenForPaymentRedirect();
  }

  void _listenForPaymentRedirect() {
    AppLinks().uriLinkStream.listen((uri) {
      // Triggered when the payment gateway redirects back to the app.
      // Both /payment/redirect and /payment/callback reload the wallet.
      final path = uri.path.toLowerCase();
      if (path.contains('payment')) {
        _paymentCubit.loadData();
      }
    });
  }

  @override
  void dispose() {
    _paymentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
<<<<<<< HEAD
        BlocProvider(
          create: (_) => PaymentCubit(PaymentRepo()),
        ),
=======
        BlocProvider.value(value: _paymentCubit),
>>>>>>> fe17b26ab19497cfc92167f1063a177c689dd865
        BlocProvider(
          create: (_) => RechargeCubit(RechargeRepo()),
        ),
         BlocProvider(
      create: (_) => AuthCubit(AuthRepo(ApiService()))), 
    BlocProvider(
      create: (_) => SplashCubit(),
    ),
     BlocProvider(
          create: (_) => MytaskCgCubit(MytaskCgRepo()),
        ),
//  BlocProvider(
//       create: (context) => AccountSettingsCubit(),
//     ),
  ],
    
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
<<<<<<< HEAD
        home:CgPaymentScreen(),
=======
        home: widget.home,
>>>>>>> fe17b26ab19497cfc92167f1063a177c689dd865
      ),
    );
  }
}