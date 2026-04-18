import 'package:flutter/material.dart';

import 'features/home_screen/ui/widgets/language_switcher.dart';



class AppLayout extends StatelessWidget {
  final Widget body;
  final Widget? header; // 👈 optional لكل صفحة

  const AppLayout({super.key, required this.body, this.header});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 محتوى الصفحة
          SafeArea(
            child: Column(
              children: [
                /// 🔹 Header لو موجود
                if (header != null) header!,

                /// 🔹 باقي الصفحة
                Expanded(child: body),
              ],
            ),
          ),

          /// 🔥 زرار اللغة ثابت فوق
          Positioned(
            top: 40,
            right: Directionality.of(context) == TextDirection.ltr ? 16 : null,
            left: Directionality.of(context) == TextDirection.rtl ? 16 : null,
            child: const LanguageSwitcher(),
          ),
        ],
      ),
    );
  }
}
