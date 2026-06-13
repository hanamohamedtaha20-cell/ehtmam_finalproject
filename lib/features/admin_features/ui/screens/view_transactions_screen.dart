import 'package:flutter/material.dart';

class ViewTransactionsScreen extends StatelessWidget {
  const ViewTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        'id': 'TRX001234',
        'status': 'completed',
        'service': 'Pet Care Service - 5 days',
        'date': '2026-03-12 14:30',
        'amount': '250.00',
        'color': Color(0xff00A86B),
        'user': 'ahmed ashraf',
        'provider': 'fatma adel',
      },
      {
        'id': 'TRX001235',
        'status': 'completed',
        'service': 'Premium Bundle - 10 sessions',
        'date': '2026-03-12 13:15',
        'amount': '249.00',
        'color': Color(0xff2F80ED),
        'user': 'omar essam',
        'provider': null,
      },
      {
        'id': 'TRX001236',
        'status': 'completed',
        'service': 'Elderly Care - Post-surgery care',
        'date': '2026-03-11 18:45',
        'amount': '450.00',
        'color': Color(0xff00A86B),
        'user': 'ahmed muhamed',
        'provider': 'muhamed khaled',
      },
      {
        'id': 'TRX001237',
        'status': 'refunded',
        'service': 'Refund - Service cancelled',
        'date': '2026-03-11 12:0',
        'amount': '-200.00',
        'color': Color(0xffFF0000),
        'user': 'Zeyas esmail',
        'provider': 'farah muhamed',
      },
      {
        'id': 'TRX001238',
        'status': 'pending',
        'service': 'Plant Care - 3 days',
        'date': '2026-03-10 09:00 - Fawry',
        'amount': '180.00',
        'color': Color(0xff00A86B),
        'user': 'mira ashraf',
        'provider': 'mazen muhamed',
      },
      {
        'id': 'TRX001239',
        'status': 'completed',
        'service': 'Child Care - Weekend care',
        'date': '2026-03-10 15:30',
        'amount': '320.00',
        'color': Color(0xff00A86B),
        'user': 'ahmed adel',
        'provider': 'khalil kamr',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'View Transactions',
                          style: TextStyle(
                            color: Color(0xff111827),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Monitor all platform\ntransactions',
                          style: TextStyle(
                            color: Color(0xff6B7280),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 26,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F7FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.language,
                            size: 14, color: Color(0xff64748B)),
                        SizedBox(width: 4),
                        Text(
                          'ع',
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return _TransactionCard(data: transactions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _TransactionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final String status = data['status'];
    final Color amountColor = data['color'];

    Color statusBg;
    Color statusText;

    if (status == 'completed') {
      statusBg = const Color(0xffD1FAE5);
      statusText = const Color(0xff059669);
    } else if (status == 'refunded') {
      statusBg = const Color(0xffDBEAFE);
      statusText = const Color(0xff2563EB);
    } else {
      statusBg = const Color(0xffFEF3C7);
      statusText = const Color(0xffD97706);
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
              Text(
                data['id'],
                style: const TextStyle(
                  color: Color(0xff111827),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusText,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                data['amount'],
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
              data['service'],
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
              Text(
                data['date'],
                style: const TextStyle(
                  color: Color(0xff64748B),
                  fontSize: 10,
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
                  label: 'User:',
                  name: data['user'],
                  iconColor: const Color(0xff2F80ED),
                ),
              ),
              if (data['provider'] != null)
                Expanded(
                  child: _NameInfo(
                    icon: Icons.person_outline,
                    label: 'Provider:',
                    name: data['provider'],
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
        Icon(icon, size: 13, color: iconColor),
        const SizedBox(width: 4),
        Flexible(
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