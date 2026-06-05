import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/earnings_screen/ui/screens/earnings_screen.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/chatbot_screen.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/ui/screens/care_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'features/home_screen/ui/screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(
      EasyLocalization(
      supportedLocales:  [
        Locale('en'),
        Locale('ar'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(



      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home:BookingCgScreenScreen(),

    );
  }
}



