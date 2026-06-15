import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import '../../data/model/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel item;

  const NotificationCard({super.key, required this.item});

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'booking':  return Icons.calendar_today_outlined;
      case 'payment':  return Icons.payment_outlined;
      case 'offer':    return Icons.local_offer_outlined;
      case 'task':     return Icons.task_alt_outlined;
      case 'review':   return Icons.star_outline_rounded;
      default:         return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String type) {
    switch (type.toLowerCase()) {
      case 'booking':  return const Color(0xFF3A8BD7);
      case 'payment':  return const Color(0xFF1F9E0E);
      case 'offer':    return const Color(0xFFFF7E22);
      case 'task':     return const Color(0xFF6C63FF);
      case 'review':   return const Color(0xFFF5DD7E);
      default:         return const Color(0xFF3A8BD7);
    }
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24) return '${diff.inHours}h ago';
    if (diff.inDays    == 1) return 'Yesterday';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _colorForType(item.type);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.white : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14.r),
        border: item.isRead
            ? null
            : Border.all(color: const Color(0xFFBFDAFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(_iconForType(item.type), color: iconColor, size: 20.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.message,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 12.sp,
                    color: AppColors.textLight,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  _formatDate(item.createdAt),
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 11.sp,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
