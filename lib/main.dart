import 'package:ehtmam_finalproject/features/account_settings/manager/account_settings_cubit.dart';
import 'package:ehtmam_finalproject/features/auth/ui/screens/login_screen.dart';
import 'package:ehtmam_finalproject/features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'package:ehtmam_finalproject/features/main_layout/ui/screens/main_layout_screen.dart';
import 'package:ehtmam_finalproject/features/splash/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_service.dart';
import 'features/auth/data/repo/auth_repo.dart';
import 'features/auth/manager/auth_cubit.dart';
import 'features/auth/ui/screens/register_screen.dart';
import 'features/bottom_nav_bar/ui/admin_buttom_nav_bar.dart';
import 'features/bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import 'features/home_screen/ui/home_screen.dart';
import 'features/splash/manager/splash_cubit.dart';

void main() async{
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
      child: DevicePreview(
        builder: (context) =>  MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (context) => SplashCubit(),
        ),

        BlocProvider(
          create: (context) => BottomNavCubit(),
        ),

        BlocProvider(
          create: (context) => AccountSettingsCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            AuthRepo(
              ApiService(),
            ),
          ),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        locale: DevicePreview.locale(context) ?? context.locale,
        builder: DevicePreview.appBuilder,

        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,

        home:AdminButtomNavBar()
        //RegisterScreen(role: 'user',),
      ),
    );
  }
}



