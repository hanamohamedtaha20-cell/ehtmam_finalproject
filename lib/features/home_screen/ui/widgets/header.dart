import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/model/user_model.dart';
import '../screens/chatbot_screen.dart';



class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(8),
      decoration:  BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("welcome back".tr()),
                  Text(
                    "user_name".tr(args: [user.name]),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3A8BD7), Color(0xFFD8E3E9)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF432DD7).withOpacity(0.3),
                    offset: const Offset(0, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatbotScreen(),
                      ),
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Text(
                        "Ask AI Assistant".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}