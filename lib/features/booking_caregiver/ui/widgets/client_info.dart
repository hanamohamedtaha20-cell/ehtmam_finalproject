import 'package:flutter/material.dart';

class ClientInfoCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final double rating;

  const ClientInfoCard({
    super.key,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.rating = 0,
  });

  @override
  Widget build(BuildContext context) {
    final ratingText =
        rating > 0 ? '$rating rating' : 'No rating yet';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 6),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
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
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xff169CE8),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 6),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Client',
                      style: const TextStyle(
                        fontSize: 14,
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
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ratingText,
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
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(
                  Icons.call_outlined,
                  color: Color(0xff2F80ED),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (email.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.mail_outline,
                  color: Color(0xff2F80ED),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    email,
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
        ],
      ),
    );
  }
}
