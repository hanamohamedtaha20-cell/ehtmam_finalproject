import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/notification_model.dart';
import 'notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;

  const NotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, i) => NotificationCard(item: notifications[i]),
    );
  }
}
