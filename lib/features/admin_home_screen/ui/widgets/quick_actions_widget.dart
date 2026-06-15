import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff172033),
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
                    color: const Color(0xffEAF4FF),
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.12),
                        blurRadius: 7.r,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (action.badgeCount != null && action.badgeCount! > 0)
                        Positioned(
                          top: 0.h,
                          right: 0.w,
                          child: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            action.icon,
                            size: 30.r,
                            color: const Color(0xff111827),
                          ),
                          Spacer(),
                          Text(
                            action.title,
                            style: TextStyle(
                              fontSize: 12.sp,
                              height: 1.3.h,
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