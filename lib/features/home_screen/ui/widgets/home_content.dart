import 'package:easy_localization/easy_localization.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/crearte_request.dart';
import 'package:flutter/material.dart';
import '../../../requests_screen_user/ui/screens/requests_screen.dart';
import '../../data/model/user_model.dart';
import 'bundles_card.dart';
import 'request_card.dart';
import 'header.dart';
import 'service_card.dart';
import 'whyChoose_card.dart';

class HomeContent extends StatelessWidget {
   HomeContent({super.key});
  final user = UserModel(
    name: "ahmed",

  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          /// 🔹 HEADER
           HeaderWidget(user: user,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 1,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          /// 🔹 SERVICES TITLE
          Text(
            "Select a Service".tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          SizedBox(height: 10),

          /// 🔹 SERVICES
          ServiceCardWidget(
            icon: Text('🐾', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.blue.shade100, Colors.blue.shade300],
            title: 'Pet Care'.tr(),
            subtitle: "Professional care for your pets while you're away".tr(),
            gradientBGColors: [Color(0xFFF5F3FF), Color(0xFFFAF5FF)],
            page:CreateRequestScreen() ,

          ),
          ServiceCardWidget(
            icon: Text('👵', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.blue.shade300, Colors.blue.shade600],
            title: 'Elderly Care'.tr(),
            subtitle: 'Compassionate care for your elderly loved ones'.tr(),
            gradientBGColors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)],
            page: CreateRequestScreen(),
          ),
          ServiceCardWidget(
            icon: Text('👶', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.purple, Colors.pink],
            title: 'Child Care'.tr(),
            subtitle: 'Safe and reliable childcare services at home'.tr(),
            gradientBGColors: [Color(0xFFFAF5FF), Color(0xFFFDF2F8)],
            page: CreateRequestScreen(),
          ),
          ServiceCardWidget(
            icon: Text('🌿', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.green.shade400, Colors.green.shade700],
            title: 'Plant Care'.tr(),
            subtitle: 'Expert plant care and maintenance for your home garden'
                .tr(),
            gradientBGColors: [Color(0xFFF1F2FF), Color(0xFFF1F2FF)],
            page: CreateRequestScreen(),
          ),

          SizedBox(height: 20),

          BundlesCard(
            onTap: () {},
          ),

          SizedBox(height: 20),
          /// 🔹 ACTIVE REQUESTS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Active Requests".tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestsScreen(),
                    ),
                  );
                },

                child: Text(
                  "View All".tr(),
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          RequestCardWidget(
            title: "Pet Care".tr(),
            date: "March 15, 2026".tr(),
            status: "Pending".tr(),
            statusColor: Colors.orange,
            description: "Dog • 5 days".tr(),
            provider: "".tr(),
          ),

          RequestCardWidget(
            title: "Elderly Care".tr(),
            date: "March 20, 2026".tr(),
            status: "Accepted".tr(),
            statusColor: Colors.green,
            description: "3 days".tr(),
            provider: "Provider: Fatma Medical Care".tr(),
          ),

          const SizedBox(height: 20),

          /// 🔹 WHY CHOOSE
          Text(
            "Why Choose Ehtemam".tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.9,
            // <--- Adjust this value to set the height
            children: [
              WhyChooseCardWidget(
                icon: 'assets/images/Container.png',
                title: "verified\nProviders".tr(),
              ),
              WhyChooseCardWidget(
                icon: 'assets/images/Container2.png',
                title: "Trusted Care".tr(),
              ),
              WhyChooseCardWidget(
                icon: 'assets/images/Container 3.png',
                title: "24/7 Support".tr(),
              ),
              WhyChooseCardWidget(
                icon: 'assets/images/Container 4.png',
                title: "Experienced\nStaff".tr(),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
