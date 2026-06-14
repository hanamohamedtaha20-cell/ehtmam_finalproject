import 'package:flutter/material.dart';

import '../../data/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final String status =
    transaction.status.toLowerCase();

    Color statusBg;
    Color statusText;
    Color amountColor;

    if (status == 'completed') {
      statusBg = const Color(0xffD1FAE5);
      statusText = const Color(0xff059669);
      amountColor = const Color(0xff00A86B);
    } else if (status == 'refunded') {
      statusBg = const Color(0xffDBEAFE);
      statusText = const Color(0xff2563EB);
      amountColor = const Color(0xff2563EB);
    } else {
      statusBg = const Color(0xffFEF3C7);
      statusText = const Color(0xffD97706);
      amountColor = const Color(0xffD97706);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  transaction.clientName,
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  transaction.status,
                  style: TextStyle(
                    color: statusText,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                transaction.amount.toString(),
                style: TextStyle(
                  color: amountColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              transaction.bundleName.isNotEmpty
                  ? transaction.bundleName
                  : transaction.type,
              style: const TextStyle(
                color: Color(0xff334155),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: Color(0xff94A3B8),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  transaction.transactionDate,
                  style: const TextStyle(
                    color: Color(0xff64748B),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 22),

          Row(
            children: [
              Expanded(
                child: _NameInfo(
                  icon: Icons.person_outline,
                  label: 'Client:',
                  name: transaction.clientName,
                  iconColor: const Color(0xff2F80ED),
                ),
              ),
              Expanded(
                child: _NameInfo(
                  icon: Icons.person_outline,
                  label: 'Caregiver:',
                  name: transaction.caregiverName,
                  iconColor: const Color(0xff00A86B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NameInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String name;
  final Color iconColor;

  const _NameInfo({
    required this.icon,
    required this.label,
    required this.name,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: iconColor,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(
                    color: Color(0xff334155),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: name,
                  style: const TextStyle(
                    color: Color(0xff334155),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}