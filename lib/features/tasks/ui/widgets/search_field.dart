import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class TaskSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const TaskSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: "Enter task description...",
                    hintStyle: const TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13,
                        color: AppColors.textLight),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(14)),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFF97CCFD), // 👈 light blue
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                   child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      const Text("Add \n Task",
                          style: TextStyle(
                              fontFamily: "Arimo",
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Text(
              "Please select a request to add tasks",
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11,
                  color: AppColors.textLight),
            ),
          ),
        ],
      ),
    );
  }
}