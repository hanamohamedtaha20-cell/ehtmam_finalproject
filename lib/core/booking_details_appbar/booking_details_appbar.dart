import 'package:flutter/material.dart';

class BookingDetailsAppBar extends StatelessWidget {
  const BookingDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.only(
        top: 42,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
             Color(0xff3D8EF5),
             Color(0xff4E97F2),
            Colors.white.withOpacity(.5),
          ],

          stops: [
            0.0,
            0.65,
            1.0,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
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

                child:  Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),

              /// TITLE
              const Text(
                "Booking Details",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              /// LANGUAGE BUTTON
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
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
                      size: 16,
                    ),

                    SizedBox(width: 4),

                    Text(
                      "ع",

                      style: TextStyle(
                        color: Color(0xff44516B),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// BOOKING INFO CARD
          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.16),

              borderRadius: BorderRadius.circular(18),

              border: Border.all(
                color: Colors.white.withOpacity(.10),
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
                        fontSize: 10,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      "BK12345",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                /// STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color:  Color(0xFFFEF3C6),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const Row(
                    children: [

                      Text(
                        "Pending",

                        style: TextStyle(
                          color: Color(0xFFBB4D00),
                          fontSize: 11,
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