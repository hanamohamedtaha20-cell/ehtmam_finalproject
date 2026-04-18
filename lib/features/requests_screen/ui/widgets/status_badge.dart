import 'package:flutter/material.dart';

import '../../data/request_type.dart';

class StatusBadge extends StatelessWidget {
  final RequestType type;
  final String text;

  const StatusBadge({super.key, required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (type) {
      case RequestType.pending:
        color = Colors.orange;
        break;
      case RequestType.accepted:
        color = Colors.blue;
        break;
      case RequestType.completed:
        color = Colors.green;
        break;
      case RequestType.cancelled:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color)),
    );
  }
}
