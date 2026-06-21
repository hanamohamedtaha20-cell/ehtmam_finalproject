import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../admin_features/ui/screens/bundles_screen.dart';
import '../../../admin_features/ui/screens/manage_complaints_screen.dart';
import '../../../admin_features/ui/screens/pending_approvals_screen.dart';
import '../../../admin_features/ui/screens/view_transactions_screen.dart';
import '../../model/quick_action_model.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<QuickActionModel> actions;

  const QuickActionsWidget({super.key, required this.actions});

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
    if (screen == null) { return; }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
  }

  // Per-card icon widget — styled to match the screenshot
  Widget _buildIcon(int index) {
    switch (index) {
      case 0: // Pending Approvals — green rounded-square checkmark (iOS style)
        return Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.35),
                blurRadius: 8.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(Icons.check, color: Colors.white, size: 28.r),
        );
      case 1: // Manage Bundles — amber/brown box (emoji-like)
        return Icon(Icons.inventory_2, size: 46.r, color: const Color(0xFFC8860A));
      case 2: // Manage Complaints — dark warning triangle
        return Icon(Icons.warning_rounded, size: 46.r, color: const Color(0xFF1A2332));
      case 3: // View Transactions — dark credit card
        return Icon(Icons.credit_card, size: 46.r, color: const Color(0xFF1A2332));
      default:
        return Icon(Icons.dashboard, size: 46.r, color: const Color(0xFF1A2332));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF172033),
            ),
          ),
          SizedBox(height: 12.h),
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
                borderRadius: BorderRadius.circular(18.r),
                onTap: () => _navigate(context, action.title),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4FF),
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8.r,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Badge
                      if (action.badgeCount != null && action.badgeCount! > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 22.r,
                            height: 22.r,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                action.badgeCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Icon + label
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIcon(index),
                          const Spacer(),
                          Text(
                            action.title,
                            style: TextStyle(
                              fontSize: 13.sp,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A2332),
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
