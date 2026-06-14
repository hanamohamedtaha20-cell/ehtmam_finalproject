import 'package:ehtemam_final_project/features/admin_users_screen/manager/ad_user_state.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/widgets/ad_user_card.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/widgets/block_user_dialog.dart';
import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Users',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      context.read<AdUserCubit>().searchUsers(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      hintStyle: const TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xff94A3B8),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xffF8FAFC),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
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
                    padding: const EdgeInsets.all(16),
                    children: [
                      StatTotalCard(
                        number: state.allUsers.length.toString(),
                        title: 'Total Users',
                      ),
                      const SizedBox(height: 16),

                      if (state.filteredUsers.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              'No users found',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 14,
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
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Text(
            number,
            style: const TextStyle(
              color: Color(0xff2F93E6),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff6B7280),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
