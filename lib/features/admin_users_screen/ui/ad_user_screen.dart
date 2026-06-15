import 'package:ehtemam_final_project/features/admin_users_screen/manager/ad_user_state.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/widgets/ad_user_card.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/widgets/block_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/ad_user_cubit.dart';

class AdUserScreen extends StatelessWidget {
  const AdUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdUserCubit()..getUsers(),
      child: const UsersView(),
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 18, 16, 14),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Users',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff111827),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    onChanged: (value) {
                      context.read<AdUserCubit>().searchUsers(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      hintStyle: TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 13.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xff94A3B8),
                        size: 20.r,
                      ),
                      filled: true,
                      fillColor: const Color(0xffF8FAFC),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<AdUserCubit, AdUsersState>(
                builder: (context, state) {
                  return ListView(
                    padding: EdgeInsets.all(16.r),
                    children: [
                      StatTotalCard(
                        number: state.allUsers.length.toString(),
                        title: 'Total Users',
                      ),
                      SizedBox(height: 16.h),

                      if (state.filteredUsers.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Text(
                              'No users found',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      else
                        ...state.filteredUsers.map(
                              (user) => AdUserCard(
                            user: user,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatTotalCard extends StatelessWidget {
  final String number;
  final String title;

  const StatTotalCard({
    super.key,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
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
          Text(
            number,
            style: TextStyle(
              color: Color(0xff2F93E6),
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              color: Color(0xff6B7280),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
