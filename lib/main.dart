<<<<<<< HEAD
import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/earnings_screen/ui/screens/earnings_screen.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/chatbot_screen.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/ui/screens/care_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'features/home_screen/ui/screens/home_screen.dart';
=======
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
import 'features/home_screen/ui/home_screen.dart';
import 'features/splash/manager/splash_cubit.dart';
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
<<<<<<< HEAD
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child:MyApp()));
=======
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: DevicePreview(
        builder: (context) =>  MyApp(),
      ),
    ),
  );
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408
}

class MyApp extends StatelessWidget {
   MyApp({super.key});


  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(



      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home:BookingCgScreenScreen(),

=======
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

        home:LoginScreen()
        //RegisterScreen(role: 'user',),
      ),
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408
    );
  }
}



