import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/earnings_screen/ui/screens/earnings_screen.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/chatbot_screen.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/ui/screens/care_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'features/home_screen/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_bloc/flutter_bloc.dart';



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
          child:MyApp()));

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

    return MaterialApp(



      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home:BookingCgScreenScreen(),


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

    );
  }
}



