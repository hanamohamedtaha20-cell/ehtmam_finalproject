import 'package:ehtemam_final_project/features/admin_users_screen/manager/ad_user_state.dart';
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
                              (user) => _UserCard(user: user),
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

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final isActive = user['status'] == 'Active';
    final isPremium = user['premium'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xff2F93E6),
            child: Text(
              user['initials'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user['email'],
                  style: const TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      user['bookings'],
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      user['joined'],
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  children: [
                    _Tag(
                      text: user['status'],
                      color: isActive
                          ? const Color(0xff16A34A)
                          : const Color(0xff64748B),
                      bg: isActive
                          ? const Color(0xffDCFCE7)
                          : const Color(0xffE5E7EB),
                    ),
                    if (isPremium)
                      const _Tag(
                        text: 'Premium User',
                        color: Color(0xff7C3AED),
                        bg: Color(0xffEDE9FE),
                      )
                    else
                      const _Tag(
                        text: 'User',
                        color: Color(0xff64748B),
                        bg: Color(0xffF1F5F9),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => BlockUserDialog(
                          name: user['name'],
                          email: user['email'],
                          onBlock: () {
                            context
                                .read<AdUserCubit>()
                                .blockUser(user['email']);
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.block,
                      color: Colors.red,
                      size: 14,
                    ),
                    label: const Text(
                      'Block User',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.more_vert,
            size: 18,
            color: Color(0xff94A3B8),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final Color bg;

  const _Tag({
    required this.text,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}