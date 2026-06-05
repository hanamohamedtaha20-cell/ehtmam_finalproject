import 'package:flutter/material.dart';

class BundlesCard extends StatelessWidget {
  final VoidCallback onTap;

  const BundlesCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3,
      ),

      padding:  EdgeInsets.all(15),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient:  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7DBAF5),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          /// TOP SECTION
          Row(
            children: [
              /// ICON BOX
              Container(
                width: 55,
                height: 55,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),

                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child:  Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              SizedBox(width: 13),

              /// TEXTS
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children:[
                    Text(
                      "Save with Bundles",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Get up to 40% off with service packages",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          /// BUTTON
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,

            child: Container(
              height: 45,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(16),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF00A86B),
                    size: 20,
                  ),

                  SizedBox(width: 9),

                  Text(
                    "View Bundles",

                    style: TextStyle(
                      color: Color(0xFF00A86B),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}