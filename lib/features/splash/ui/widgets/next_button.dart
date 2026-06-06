import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool withArrow;
  final double radius;

  const NextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.withArrow = false,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final s = (width / 393).clamp(0.85, 1.15);

    return SizedBox(
      width: double.infinity,
      height: 56 * s,

      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius * s),

          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,

            colors: [
              Color(0xFF2F7FCD),
              Color(0xFF2F7FCD),
              Color(0x99FFFFFF),
            ],

            stops: [
              0.0,
              0.58,
              1.0,
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6 * s,
              offset: Offset(0, 4 * s),
            ),
          ],
        ),

        child: ElevatedButton(
          onPressed: onTap,

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,

            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(radius * s),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                text,

                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16 * s,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

              if (withArrow) ...[
                SizedBox(width: 6 * s),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14 * s,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}