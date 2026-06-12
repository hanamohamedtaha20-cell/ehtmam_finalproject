import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/account_settings/data/repo/account_settings_repo.dart';
import 'package:ehtemam_final_project/features/admin_home_screen/ui/admin_dashboard._screen.dart';
import 'package:ehtemam_final_project/features/admin_provider_screen/ui/screens/ad_provider_screen.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/ad_user_screen.dart';
import 'package:ehtemam_final_project/features/auth/data/repo/auth_repo.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/data/repo/mytask_cg_repo.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/manager/mytask_cg_cubit.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/ui/screens/payment_screen.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/repo/recharge_repo.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_cubit.dart';
import 'package:ehtemam_final_project/features/splash/manager/splash_cubit.dart';
import 'package:ehtemam_final_project/features/splash/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/account_settings/manager/account_settings_cubit.dart';
import 'features/admin_provider_screen/manager/ad_provider_cubit.dart';
import 'features/admin_provider_screen/model/repo/ad_provider_repository.dart';
import 'features/admin_users_screen/manager/ad_user_cubit.dart';
import 'features/admin_users_screen/model/repo/ad_user_repo.dart';
import 'features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'features/bottom_nav_bar/ui/widget/admin_buttom_nav_bar.dart';
import 'features/rating/data/repo/rating_repo.dart';
import 'features/rating/manager/rating_cubit.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp()
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
          create: (_) => PaymentCubit(PaymentRepo())..loadData(),
        ),
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
          create: (_) => BottomNavCubit(),
        ),

        BlocProvider(
          create: (_) => AdProviderCubit(
            AdProviderRepositoryImpl(),
          )..getProviders(),
        ),

        BlocProvider(
          create: (_) => AdUserCubit(
          )..getUsers(),
        ),
  ],

    
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home:LoginScreen(),
      ),
    );
  }
}