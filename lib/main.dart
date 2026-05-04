import 'package:ehtemam_final_project/features/bookings/ui/screens/booking_screen.dart';
import 'package:ehtemam_final_project/features/offers_screen/ui/screens/offers_screen.dart';
import 'package:ehtemam_final_project/features/payment/ui/screens/payment_screen.dart';
import 'package:ehtemam_final_project/features/profile2/ui/screens/profile_screen.dart';
import 'package:ehtemam_final_project/features/rating/ui/screens/rating_screen.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/screens/recharge_screen.dart';
import 'package:ehtemam_final_project/features/tasks/ui/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:device_preview/device_preview.dart';
import 'features/home_screen/ui/home_screen.dart';

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
          child:DevicePreview(builder: (context)=> MyApp()))
  );
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
      home: BookingScreen(),
    );
  }
}



