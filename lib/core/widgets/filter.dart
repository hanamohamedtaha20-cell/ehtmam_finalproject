import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  final Function(String selectedTab) onTabChanged;

  const Filter({
    super.key,
    required this.onTabChanged,
    required String selectedTab,
  });

  @override
  State<Filter> createState() => _RequestTabsState();
}

class _RequestTabsState extends State<Filter> {

  String selectedTab = "All";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 14,
        left: 16,
        right: 16,
        bottom: 10,
      ),

      color: Colors.white,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          _tab(title: "All"),

          _tab(title: "Pending"),

          _tab(title: "Accepted"),

          _tab(title: "Completed"),
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
  }) {

    final bool active = selectedTab == title;

    return GestureDetector(
      onTap: () {

        setState(() {
          selectedTab = title;
        });

        widget.onTabChanged(title);
      },

      child: Padding(
        padding: const EdgeInsets.only(
          right: 22,
        ),

        child: Column(
          children: [

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),

              style: TextStyle(
                color: active
                    ? const Color(0xFF4A90E2)
                    : const Color(0xFF667085),

                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),

              child: Text(title),
            ),

            const SizedBox(height: 10),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),

              width: active ? 28 : 0,
              height: 2,

              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}