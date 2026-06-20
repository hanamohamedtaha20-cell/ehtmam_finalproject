import 'package:flutter/material.dart';



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

        ],
      ),
    );
  }
}
