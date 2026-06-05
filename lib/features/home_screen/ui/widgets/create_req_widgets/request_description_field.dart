import 'package:flutter/material.dart';

import 'app_card.dart';

class RequestDescriptionField
    extends StatelessWidget {

  const RequestDescriptionField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                Icons.description_outlined,
                size: 18,
                color: Colors.blueGrey,
              ),

              const SizedBox(width: 6),

              const Text(
                "Description",

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Text(
                " *",

                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          TextFormField(
            maxLines: 5,

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {

                return
                  "Description is required";
              }

              return null;
            },

            decoration: InputDecoration(
              hintText:
              "Describe what you need...",

              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),

              filled: true,

              fillColor:
              const Color(0xFFF5F7FA),

              contentPadding:
              const EdgeInsets.all(16),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),

                borderSide:
                BorderSide.none,
              ),

              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),

                borderSide:
                BorderSide.none,
              ),

              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),

                borderSide: BorderSide(
                  color: Colors.blue.shade300,
                  width: 1.5,
                ),
              ),

              errorBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),

                borderSide:
                const BorderSide(
                  color: Colors.red,
                ),
              ),

              focusedErrorBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),

                borderSide:
                const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}