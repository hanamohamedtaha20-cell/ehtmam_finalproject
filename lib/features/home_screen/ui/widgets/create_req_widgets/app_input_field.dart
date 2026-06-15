import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_card.dart';

class AppInputField extends StatelessWidget {
  final String title;
  final String hint;
  final IconData? icon;
  final bool isRequired;
  final TextEditingController? controller;

  const AppInputField({
    super.key,
    required this.title,
    required this.hint,
    this.icon,
    this.isRequired = true, this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 12.h),

          TextFormField(
            controller: controller,
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return "This field is required";
              }

              return null;
            },

            decoration: InputDecoration(
              hintText: hint,

              prefixIcon:
              icon != null
                  ? Icon(icon)
                  : null,

              filled: true,
              fillColor:
              const Color(0xFFF5F7FA),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14.r),
                borderSide:
                BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}