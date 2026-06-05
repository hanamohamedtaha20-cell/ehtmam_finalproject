import 'package:flutter/material.dart';

class TasksProgressCard extends StatelessWidget {

  final int completedTasks;

  final int totalTasks;

  const TasksProgressCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {

    double progress = completedTasks / totalTasks;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 6),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              const Text(
                "Progress",

                style: TextStyle(
                  color: Color(0xff44516B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                "$completedTasks/$totalTasks completed",

                style: const TextStyle(
                  color: Color(0xff2F80ED),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,

              backgroundColor:
              const Color(0xffE6E6E6),

              valueColor:
              const AlwaysStoppedAnimation(
                Color(0xff2DBE1E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}