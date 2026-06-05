<<<<<<< HEAD
import 'package:flutter/material.dart';

=======
import '/features/booking_caregiver/ui/widgets/reusable_info_card.dart';
import 'package:flutter/material.dart';

import 'info_row.dart';

>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408
class ClientInfoCard extends StatelessWidget {
  const ClientInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    return InfoCard(
      title: 'CLIENT INFORMATION',
      icon: Icons.person_outline,
      children: [
        InfoRow('Name', 'Menaa adel'),
        InfoRow('Phone', '+201001867005'),
        InfoRow('Email', 'Menaa.adel@gmail.com'),
      ],
    );
  }
}

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'SERVICE DETAILS',
      icon: Icons.pets,
      children: [
        InfoRow('Service Type', 'Pet Care'),
        InfoRow('Pet Type', 'Golden Retriever'),
        InfoRow('Duration', '4 hours'),
      ],
    );
  }
}

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'DATE & TIME',
      icon: Icons.calendar_today,
      children:  [
        InfoRow('Date', '2026-04-10'),
        InfoRow('Time', '10:00 AM - 2:00 PM'),
        InfoRow('Location', '123 Salem Sakem, Giza'),
      ],
    );
  }
}

class SpecialInstructionsCard extends StatelessWidget {
  const SpecialInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'SPECIAL INSTRUCTIONS',
      icon: Icons.note_alt_outlined,
      children:  [
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Max tries to play fetch and needs his medication at 12 PM. Please make sure he has fresh water at all times.",
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408
    );
  }
}