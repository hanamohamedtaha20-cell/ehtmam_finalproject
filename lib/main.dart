import 'package:app_links/app_links.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/account_settings/data/repo/account_settings_repo.dart';
import 'package:ehtemam_final_project/features/auth/data/repo/auth_repo.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/widget/admin_bottom.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/data/repo/mytask_cg_repo.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/manager/mytask_cg_cubit.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/repo/recharge_repo.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_cubit.dart';
import 'package:ehtemam_final_project/features/splash/manager/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/account_settings/manager/account_settings_cubit.dart';
import 'features/admin_provider_screen/manager/ad_provider_cubit.dart';
import 'features/admin_provider_screen/model/repo/ad_provider_repository.dart';
import 'features/admin_users_screen/manager/ad_user_cubit.dart';
import 'features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'features/rating/data/repo/rating_repo.dart';
import 'features/rating/manager/rating_cubit.dart';


Widget _resolveHomeScreen(SharedPreferences prefs) {
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final role = prefs.getString('user_role') ?? '';

  if (!isLoggedIn) return const LoginScreen();

  switch (role.toLowerCase()) {
    case 'admin':
      return const AdminButtomNavBar();
    case 'giver':
    case 'caregiver':
      return const CareGiverBottomNavScreen();
    default:
      return const HomeScreen();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(home: _resolveHomeScreen(prefs)),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.home});

  final Widget home;

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
        BlocProvider.value(value: _paymentCubit),
        BlocProvider(
          create: (_) => RechargeCubit(RechargeRepo()),
        ),
        BlocProvider(
          create: (_) => AuthCubit(AuthRepo(ApiService())),
        ),
        BlocProvider(
          create: (_) => SplashCubit(),
        ),
        BlocProvider(
          create: (_) => MytaskCgCubit(MytaskCgRepo()),
        ),
        BlocProvider(
          create: (_) => AccountSettingsCubit(AccountSettingsRepo(ApiService())),
        ),
        BlocProvider(
          create: (_) => RatingCubit(RatingRepo()),
        ),
        BlocProvider(
          create: (_) => BottomNavCubit(),
        ),
        BlocProvider(
          create: (_) => AdProviderCubit(
            AdProviderRepositoryImpl(ApiService()),
          )..getProviders(),
        ),
        BlocProvider(
          create: (_) => AdUserCubit()..getUsers(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: widget.home,
      ),
    );
  }
}