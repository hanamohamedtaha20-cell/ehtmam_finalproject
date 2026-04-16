import 'package:ehtemam_final_project/home_screen/widgets/service_card.dart';
import 'package:ehtemam_final_project/home_screen/widgets/whyChooseCard.dart';
import 'package:flutter/material.dart';
import 'RequestCard.dart';
import 'header.dart';


class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          /// 🔹 HEADER
          const HeaderWidget(),

          const SizedBox(height: 20),

          /// 🔹 SERVICES TITLE
          const Text(
            "ourServices",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          /// 🔹 SERVICES
          ServiceCardWidget(
            icon: const Text('🐾', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.blue.shade100, Colors.blue.shade300],
            title: 'Pet Care',
            subtitle: "Professional care for your pets while you're away",
            gradientBGColors: [ Color(0xFFF5F3FF), Color(0xFFFAF5FF)],
          ),
          ServiceCardWidget(
            icon: const Text('👵', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.blue.shade300, Colors.blue.shade600],
            title: 'Elderly Care',
            subtitle: 'Compassionate care for your elderly loved ones',
            gradientBGColors: [Color(0xFFEEF2FF) , Color(0xFFF5F3FF)],
          ),
          ServiceCardWidget(
            icon: const Text('👶', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.purple, Colors.pink],
            title: 'Child Care',
            subtitle: 'Safe and reliable childcare services at home',
            gradientBGColors: [Color(0xFFFAF5FF) , Color(0xFFFDF2F8)],
          ),
          ServiceCardWidget(
            icon: const Text('🌿', style: TextStyle(fontSize: 24)),
            gradientColors: [Colors.green.shade400, Colors.green.shade700],
            title: 'Plant Care',
            subtitle: 'Expert plant care and maintenance for your home garden',
            gradientBGColors: [Color(0xFFF1F2FF) , Color(0xFFF1F2FF)],
          ),

          const SizedBox(height: 20),

          /// 🔹 ACTIVE REQUESTS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Active Requests",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "View All",
                style: TextStyle(color: Color(0xFF6C63FF)),
              ),
            ],
          ),

          const SizedBox(height: 10),

          RequestCardWidget(
            title: "Pet Care",
            date: "March 15, 2026",
            status: "Pending",
            statusColor: Colors.orange,
            description: "Dog • 5 days",
            provider: "",
          ),

          RequestCardWidget(
            title: "Elderly Care",
            date: "March 20, 2026",
            status: "Accepted",
            statusColor: Colors.green,
            description: "3 days",
            provider: "Provider: Fatma Medical Care",
          ),

          const SizedBox(height: 20),

          /// 🔹 WHY CHOOSE
          const Text(
            "Why Choose CareConnect",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.9, // <--- Adjust this value to set the height
            children: [
              WhyChooseCardWidget(
                icon: 'images/container.png',
                title: "Verified\nProviders",
              ),
              WhyChooseCardWidget(
                icon: 'images/Container2.png',
                title: "Trusted Care",
              ),
              WhyChooseCardWidget(
                icon: 'images/Container3.png',
                title: "24/7 Support",
              ),
              WhyChooseCardWidget(
                icon: 'images/container4.png',
                title: "Experienced\nStaff",
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}