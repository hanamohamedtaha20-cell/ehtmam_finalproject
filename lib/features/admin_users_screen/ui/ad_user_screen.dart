import 'package:ehtemam_final_project/features/admin_users_screen/manager/state/ad_user_state.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/model/repo/ad_user_repo.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/widgets/ad_user_card.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/widgets/ad_user_header.dart';
import 'package:ehtemam_final_project/features/admin_users_screen/ui/widgets/ad_user_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/ad_user_cubit.dart';

class AdUserScreen extends StatelessWidget {
  const AdUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdUserCubit(
        AdUserRepositoryImpl(),
      )..getUsers(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F6FA),
        body: SafeArea(
          child: Column(
            children: [
              AdUserHeader(
                onSearch: (value) {
                  context.read<AdUserCubit>().searchUsers(value);
                },
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<AdUserCubit, AdUserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is UserLoaded) {
                        return ListView.builder(
                          itemCount: state.users.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: AdUserStatsCard(),
                              );
                            }

                            return AdUserCard(
                              user: state.users[index - 1],
                            );
                          },
                        );
                      }

                      if (state is UsersError) {
                        return Center(
                          child: Text(
                            state.message,
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}