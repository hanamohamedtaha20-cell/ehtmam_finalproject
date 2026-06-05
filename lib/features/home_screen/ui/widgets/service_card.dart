import "package:flutter/material.dart";

class ServiceCardWidget extends StatelessWidget {
  final Widget icon;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final List<Color> gradientBGColors;
  final Widget page;

  const ServiceCardWidget({
    super.key,
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.gradientBGColors,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),

      child: InkWell(
        borderRadius: BorderRadius.circular(24),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },

        child: Container(
          margin:  EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),

          padding: EdgeInsets.all(16),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientBGColors,
            ),

            borderRadius: BorderRadius.circular(24),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset:  Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              // Icon Box
              Container(
                width: 60,
                height: 60,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                ),

                child: Center(child: icon),
              ),

              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C2E),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,

                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}