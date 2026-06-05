import 'package:flutter/material.dart';

class TaskItemCard extends StatelessWidget {

  final String title;

  final bool isDone;

  final VoidCallback onTap;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),

          borderRadius:
          BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 6),
              blurRadius: 10,
            ),
          ],
        ),

        child: Row(
          children: [

            /// CHECKBOX
            GestureDetector(
              onTap: onTap,

              child: Container(
                height: 22,
                width: 22,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: const Color(0xffD3D7DF),
                    width: 1.5,
                  ),

                  color: isDone
                      ? const Color(0xff2DBE1E)
                      : Colors.white,
                ),

                child: isDone
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                )
                    : null,
              ),
            ),

            const SizedBox(width: 12),

            /// TITLE
            Expanded(
              child: Text(
                title,

                style: TextStyle(
                  color: const Color(0xff1F2C44),

                  fontSize: 14,

                  fontWeight: FontWeight.w500,

                  decoration: isDone
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}