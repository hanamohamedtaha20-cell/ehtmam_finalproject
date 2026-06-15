import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import '../../data/repo/notification_repo.dart';
import '../../manager/notification_cubit.dart';
import '../../manager/notification_state.dart';
import '../widgets/notification_list.dart';
import '../widgets/notification_empty_view.dart';
import '../widgets/notification_error_view.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit(NotificationRepo())..loadNotifications(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark, size: 22.r),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppColors.blue, size: 22.r),
            onPressed: () =>
                context.read<NotificationCubit>().loadNotifications(),
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            );
          }
          if (state is NotificationError) {
            return NotificationErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<NotificationCubit>().loadNotifications(),
            );
          }
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const NotificationEmptyView();
            }
            return NotificationList(notifications: state.notifications);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
