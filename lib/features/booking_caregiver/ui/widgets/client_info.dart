import 'package:flutter/material.dart';

class ClientInfoCard extends StatelessWidget {
  const ClientInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 6),
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// TITLE
          Row(
            children: [

              Icon(
                Icons.person_outline,
                color: Color(0xff44516B),
                size: 18,
              ),

              SizedBox(width: 8),

              Text(
                "CLIENT INFORMATION",

                style: TextStyle(
                  color: Color(0xff44516B),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 15),

          /// USER INFO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// AVATAR
              Container(
                height: 50,
                width: 50,

                decoration: BoxDecoration(
                  color: Color(0xff169CE8),

                  borderRadius: BorderRadius.circular(14),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 6),
                      blurRadius: 8,
                    ),
                  ],
                ),

                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              SizedBox(width: 14),

              /// NAME + RATING
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                     Text(
                      "Menaa adel",

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1E2A44),
                      ),
                    ),

                    SizedBox(height: 6),

                    Row(
                      children: [

                         Icon(
                          Icons.star,
                          color: Color(0xff3D87D9),
                          size: 16,
                        ),

                         SizedBox(width: 4),

                        Text(
                          "5.0 rating",

                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

           SizedBox(height: 15),

          /// PHONE
          Row(
            children: [

               Icon(
                Icons.call_outlined,
                color: Color(0xff2F80ED),
                size: 20,
              ),

               SizedBox(width: 10),

              Text(
                "+20100870085",

                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

           SizedBox(height: 12),

          /// EMAIL
          Row(
            children: [

               Icon(
                Icons.mail_outline,
                color: Color(0xff2F80ED),
                size: 20,
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  "Menna.adel@email.com",

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}