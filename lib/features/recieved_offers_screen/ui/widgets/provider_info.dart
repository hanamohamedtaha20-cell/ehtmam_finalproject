import 'package:flutter/material.dart';
import '../../data/model/provider_data.dart';

class ProviderInfo extends StatelessWidget {
  const ProviderInfo({super.key,required this.provider});
  final ProviderModel provider;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Avatar
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Color(0xFFEDEBFA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text("👩‍🦱", style: TextStyle(fontSize: 28)),
          ),
        ),

        SizedBox(width: 12),

        /// 🔹 Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Name
            Text(
             provider.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 2),

            if (provider.service.isNotEmpty || provider.location.isNotEmpty)
              Text(
                provider.service.isNotEmpty
                    ? provider.service
                    : provider.location,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

            if (provider.location.isNotEmpty && provider.service.isNotEmpty) ...[
              SizedBox(height: 2),
              Text(
                provider.location,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],

            if (provider.isVerified || provider.isCertified) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  if (provider.isVerified)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6F0FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified_outlined,
                              size: 14, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            "Verified",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (provider.isVerified && provider.isCertified)
                    SizedBox(width: 6),
                  if (provider.isCertified)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6F7ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.workspace_premium_outlined,
                              size: 14, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "Certified",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}