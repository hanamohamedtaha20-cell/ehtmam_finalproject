import 'package:flutter/material.dart';
import '../../../admin_features/ui/screens/bundles_screen.dart';
import '../../../admin_features/ui/screens/manage_complaints_screen.dart';
import '../../../admin_features/ui/screens/pending_approvals_screen.dart';
import '../../../admin_features/ui/screens/view_transactions_screen.dart';
import '../../model/quick_action_model.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<QuickActionModel> actions;

  const QuickActionsWidget({
    super.key,
    required this.actions,
  });

  void _navigate(BuildContext context, String title) {
    Widget? screen;

    if (title == 'Pending Approvals') {
      screen = const PendingApprovalsScreen();
    } else if (title == 'Manage Bundles') {
      screen = const BundlesScreen();
    } else if (title == 'Manage Complaints') {
      screen = const ManageComplaintsScreen();
    } else if (title == 'View Transactions') {
      screen = const ViewTransactionsScreen();
    }

    if (screen == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff172033),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final action = actions[index];

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _navigate(context, action.title),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF4FF),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.12),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (action.badgeCount != null && action.badgeCount! > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                action.badgeCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            action.icon,
                            size: 30,
                            color: const Color(0xff111827),
                          ),
                          const Spacer(),
                          Text(
                            action.title,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff24324A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}