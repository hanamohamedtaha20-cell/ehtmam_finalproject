import 'package:flutter/material.dart';

class ServiceCardWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const ServiceCardWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        /// 🔥 Gradient زي الصورة (أغمق شوية)
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE0E3EB),
            Color(0xFFD6DAE5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(20),

        /// 🔥 Shadow ناعم
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],

        /// 💡 لمعة خفيفة زي UI الحقيقي
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
        ),
      ),

      child: Row(
        children: [
          /// 🔹 أيقونة بنفس ستايل الصورة
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),

          const SizedBox(width: 16),

          /// 🔹 النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}