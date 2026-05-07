import 'package:flutter/material.dart';

class BookingDetailsAppBar extends StatelessWidget {
  const BookingDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.only(
        top: 55,
        left: 20,
        right: 20,
        bottom: 24,
      ),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff2F80ED),
            Color(0xff5EA3F7),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),

      child: Column(
        children: [

          /// TOP BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              /// BACK BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              /// TITLE
              const Text(
                "Booking Details",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              /// LANGUAGE BUTTON
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Row(
                  children: [

                    Icon(
                      Icons.language,
                      color: Color(0xff44516B),
                      size: 18,
                    ),

                    SizedBox(width: 5),

                    Text(
                      "ع",

                      style: TextStyle(
                        color: Color(0xff44516B),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// BOOKING INFO CARD
          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),

              borderRadius: BorderRadius.circular(18),

              border: Border.all(
                color: Colors.white.withOpacity(.12),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                /// BOOKING ID
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Booking ID",

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "BK12345",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                /// STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xff25B516),

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const Row(
                    children: [

                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 16,
                      ),

                      SizedBox(width: 5),

                      Text(
                        "Confirmed",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}