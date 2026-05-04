import 'package:flutter/material.dart';

import 'features/home_screen/ui/widgets/language_switcher.dart';



class AppLayout extends StatelessWidget {
  final Widget body;
  final Widget? header;

  const AppLayout({super.key, required this.body, this.header});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [

                if (header != null) header!,


                Expanded(child: body),
              ],
            ),
          ),

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
