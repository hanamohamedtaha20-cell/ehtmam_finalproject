import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        if (context.locale.languageCode == 'en') {
          context.setLocale(const Locale('ar'));
        } else {
          context.setLocale(const Locale('en'));
        }
      },
      child: Container(
        width: 53,
        height: 31,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: Colors.blue,size: 18,),
            SizedBox(width:6),
            Text(
              context.locale.languageCode.toUpperCase(),
              style: TextStyle(color: Colors.deepPurple,fontSize: 12,fontWeight: FontWeight.w600,),
            ),
          ],
        ),
      ),
    );
  }
}
