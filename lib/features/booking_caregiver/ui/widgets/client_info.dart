import 'package:flutter/material.dart';

class ClientInfoCard extends StatelessWidget {
  const ClientInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// TITLE
          Row(
            children: const [

              Icon(
                Icons.person_outline,
                color: Color(0xff44516B),
                size: 20,
              ),

              SizedBox(width: 8),

              Text(
                "CLIENT INFORMATION",

                style: TextStyle(
                  color: Color(0xff44516B),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// USER INFO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// AVATAR
              Container(
                height: 60,
                width: 60,

                decoration: BoxDecoration(
                  color: const Color(0xff169CE8),

                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              /// NAME + RATING
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Menaa adel",

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1E2A44),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [

                        const Icon(
                          Icons.star,
                          color: Color(0xff3D87D9),
                          size: 18,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          "5.0 rating",

                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
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

          const SizedBox(height: 20),

          /// PHONE
          Row(
            children: [

              const Icon(
                Icons.call_outlined,
                color: Color(0xff2F80ED),
                size: 22,
              ),

              const SizedBox(width: 10),

              Text(
                "+20100870085",

                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// EMAIL
          Row(
            children: [

              const Icon(
                Icons.mail_outline,
                color: Color(0xff2F80ED),
                size: 22,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  "Menna.adel@email.com",

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
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