import 'package:flutter/material.dart';

class GradientActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  final double height;
  final double? width;
  final double fontSize;
  final List<Color>? colors;

  const GradientActionButton({
    super.key,
    required this.text,
    required this.onTap,

    this.height = 54,
    this.width,
    this.fontSize = 15,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(18),

      onTap: onTap,

      child: Container(
        width: width ,
        height: height,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,

            colors: [
              Color(0xff18A81F),
              Color(0xff95F08B),
            ],
          ),

          borderRadius:
          BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(
                0.2,
              ),

              offset: const Offset(0, 6),
              blurRadius: 6,
            ),
          ],
        ),

        child: Center(
          child: Text(
            text,

            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}