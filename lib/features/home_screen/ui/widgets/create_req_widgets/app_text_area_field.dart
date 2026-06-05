import 'package:flutter/material.dart';

import 'app_card.dart';

class AppTextAreaField extends StatelessWidget {
  final String title;
  final String hint;
  final bool isRequired;

  const AppTextAreaField({
    super.key,
    required this.title,
    required this.hint,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(title),

          const SizedBox(height: 12),

          TextFormField(
            maxLines: 5,

            validator: (value) {

              if (isRequired&&
                  (value == null || value.isEmpty)){
                return "This field is required";
              }

              return null;
            },

            decoration: InputDecoration(
              hintText: hint,

              filled: true,
              fillColor:
              const Color(0xFFF5F7FA),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),

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