import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/ad_user_cubit.dart';
import '../../model/AD_user_model.dart';
import 'ad_user_tags_widget.dart';
import 'block_user_dialog.dart';

class AdUserCard extends StatelessWidget {
  final AdUserModel user;

  const AdUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xff2F93E6),
                child: Text(
                  user.name.length >= 2
                      ? user.name.substring(0, 2).toUpperCase()
                      : user.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: Color(0xff111827),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),

              Icon(Icons.more_vert, color: Color(0xff94A3B8)),
            ],
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Text(
                '${user.bookingsCount} bookings',
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              Spacer(),
              Text(
                'Joined ${user.createdAt.split("T").first}',
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          AdUserTagsWidget(
            isActive: !user.isBlocked,
            isPremium: false,
            isBlocked: user.isBlocked,
          ),

          if (!user.isBlocked) ...[
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => BlockUserDialog(
                  name: user.name,
                  email: user.email,
                ),
              );
              if (confirmed != true || !context.mounted) return;

              final error = await context.read<AdUserCubit>().blockUser(user.id);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error == null
                        ? '${user.name} has been blocked'
                        : 'Failed to block user: $error',
                  ),
                  backgroundColor: error == null ? Colors.green : Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Icon(Icons.block, color: Colors.red, size: 18.r),
            label: Text('Block User', style: TextStyle(color: Colors.red)),
          ),
          ],
        ],
      ),
    );
  }
}
