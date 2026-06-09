import 'package:flutter/material.dart';
import '../../data/model/cg_payment_model.dart';

class CgTransactionItem extends StatelessWidget {
  final CgTransactionModel transaction;

  const CgTransactionItem({super.key, required this.transaction});

  Color get _statusColor {
    switch (transaction.status.toUpperCase()) {
      case 'COMPLETED': return const Color.fromARGB(255, 18, 120, 204);
      case 'PENDING':return Colors.orange;
      default: return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (transaction.status.toUpperCase()) {
      case 'COMPLETED': return 'Completed';
      case 'PENDING': return 'Pending';
      default: return transaction.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color.fromARGB(61, 0, 0, 0), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.person, color: Color(0xFF3A8BD7), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.clientName, style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(transaction.serviceType, style: const TextStyle(fontFamily: "Arimo", fontSize: 12, color: Colors.black87)),
                    Text(transaction.date, style: const TextStyle(fontFamily: "Arimo", fontSize: 11, color: Colors.black87)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xff3A8BD7)  ,fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: _statusColor, size: 12),
                        const SizedBox(width: 4),
                        Text(_statusLabel, style: TextStyle(fontFamily: "Arimo", fontSize: 11, color: _statusColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Divider(),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaction ID: ${transaction.id.substring(0, 8)}',
                  style: const TextStyle(fontFamily: "Arimo", fontSize: 11, color: Colors.black87)),
              GestureDetector(
                onTap: () {},
                child: const Text('View Details →',
                    style: TextStyle(fontFamily: "Arimo", fontSize: 11, color: Color(0xFF3A8BD7))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}