import 'package:flutter/material.dart';

class TaskProgressItem extends StatelessWidget {
  final String title;
  final String time;
  final bool isDone;
  final int mediaCount;
  final List<String> mediaUrls;

  const TaskProgressItem({
    super.key,
    required this.title,
    required this.time,
    required this.isDone,
    required this.mediaCount,
    required this.mediaUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(131, 76, 175, 79), width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone ? const Color(0xff007A55) : Colors.grey,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDone ? Color(0xff007A55) : Colors.black,
                  ),
                ),
              ),
              if (isDone)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED0FAE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "✓ Done",
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12,
                      color: Color(0xff007A55),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          if (isDone) ...[
            Row(
              children: [
                const Icon(Icons.access_time, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (mediaCount > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.image, size: 15, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  "Attached Media ($mediaCount)",
                  style: const TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mediaUrls.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    mediaUrls[i],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          if (!isDone) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFEE685)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Task is pending completion by caregiver",
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontSize: 12,
                    color: Color(0xFF973C00),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}