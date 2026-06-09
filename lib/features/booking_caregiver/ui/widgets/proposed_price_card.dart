import 'package:flutter/material.dart';

class ProposedPriceCard extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController notesController;

  const ProposedPriceCard({
    super.key,
    required this.controller,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 22,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// TITLE
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 18,
                color: Colors.grey.shade700,
              ),

              SizedBox(width: 8),

              Text(
                "YOUR PROPOSED PRICE",

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          /// PRICE FIELD
          Container(
            height: 55,

            decoration: BoxDecoration(
              color: Color(0xFFF7F9FC),

              borderRadius:
              BorderRadius.circular(18),

              border: Border.all(
                color: Color(0xFFDCE3EB),
              ),
            ),

            child: TextField(
              controller: controller,

              keyboardType:
              TextInputType.number,

              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF445164),
              ),

              decoration: InputDecoration(
                border: InputBorder.none,

                contentPadding:
                 EdgeInsets.symmetric(
                  vertical: 20,
                ),

                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: 14,
                    right: 6,
                  ),

                  child: Icon(
                    Icons.attach_money,
                    color: Color(0xFF00A86B),
                    size: 25,
                  ),
                ),

                hintText:
                "Enter your price...",

                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

           SizedBox(height: 12),

          /// DESCRIPTION
          Text(
            "Enter the price you'd charge for this service",

            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),

           SizedBox(height: 14),

          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),

           SizedBox(height: 14),

          /// NOTES TITLE
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 17,
                color: Colors.grey.shade700,
              ),

               SizedBox(width: 6),

              Text(
                "Notes (Optional)",

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

           SizedBox(height: 14),

          /// NOTES FIELD
          Container(
            height: 120,

            decoration: BoxDecoration(
              color:  Color(0xFFF7F9FC),

              borderRadius:
              BorderRadius.circular(18),

              border: Border.all(
                color:  Color(0xFFDCE3EB),
              ),
            ),

            child: TextField(
              controller: notesController,

              maxLines: null,
              expands: true,

              textAlignVertical:
              TextAlignVertical.top,

              decoration: InputDecoration(
                border: InputBorder.none,

                contentPadding:
                 EdgeInsets.all(16),

                hintText:
                "Add any notes about your offer..",

                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}