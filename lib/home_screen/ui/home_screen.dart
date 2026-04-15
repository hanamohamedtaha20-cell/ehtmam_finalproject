import 'package:flutter/material.dart';
import '../widgets/RequestCard.dart';
import '../widgets/header.dart';
import '../widgets/service_card.dart';
import '../widgets/whyChooseCard.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      /// 🔻 Bottom Nav (لو عندك widget ليها استبدليها)
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3A8BD7),
              Color(0xFFD8E3E9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Requests"),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
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

              /// 🔹 SERVICES LIST
              ServiceCardWidget(
                title: "Pet Care",
                subtitle: "Professional care for your pets while you're away",
                icon: Icons.pets,
                color: Color(0xFF4A90E2),
              ),

              ServiceCardWidget(
                title: "Elderly Care",
                subtitle: "Compassionate care for your elderly loved ones",
                icon: Icons.elderly,
                color: Color(0xFF9B59B6),
              ),

              ServiceCardWidget(
                title: "Child Care",
                subtitle: "Safe and reliable childcare services at home",
                icon: Icons.child_care,
                color: Color(0xFFFF6B9D),
              ),

              ServiceCardWidget(
                title: "Plant Care",
                subtitle: "Expert plant care and maintenance for your home garden",
                icon: Icons.local_florist,
                color: Color(0xFF2ECC71),
              ),

              const SizedBox(height: 20),

              /// 🔹 ACTIVE REQUESTS HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Active Requests",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// 🔹 REQUEST CARDS
              RequestCardWidget(
                title: "Pet Care",
                date: "March 15, 2026",
                status: "Pending",
                statusColor: Colors.orange,
              ),

              RequestCardWidget(
                title: "Elderly Care",
                date: "March 20, 2026",
                status: "Accepted",
                statusColor: Colors.green,
              ),

               SizedBox(height: 20),

              /// 🔹 WHY CHOOSE TITLE
               Text(
                "Why Choose CareConnect",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

               SizedBox(height: 10),

              /// 🔹 FEATURES GRID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  WhyChooseCardWidget(
                    icon: Icons.verified,
                    title: "Verified\nProviders",
                  ),
                  WhyChooseCardWidget(
                    icon: Icons.favorite,
                    title: "Trusted Care",
                  ),
                  WhyChooseCardWidget(
                    icon: Icons.support_agent,
                    title: "24/7 Support",
                  ),
                  WhyChooseCardWidget(
                    icon: Icons.star,
                    title: "Experienced\nStaff",
                  ),
                ],
              ),

               SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}