import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/dashboard_cubit.dart';
import '../../manager/dashboard_state.dart';
import '../../model/repo/dashboard_repo_impel.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_actions_widget.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit( DashboardRepositoryImpl(),)..getDashboardData(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F6FA),
        body: SafeArea(
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state
              is DashboardLoading) {
                return Center(
                  child:
                  CircularProgressIndicator(),
                );
              }

              if (state
              is DashboardLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const DashboardHeader(),

                      SizedBox(
                        height: 20.h,
                      ),

                      QuickActionsWidget(
                        actions:
                        state.quickActions,
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                );
              }

              if (state
              is DashboardError) {
                return Center(
                  child: Text(
                    state.message,
                  ),
                );
              }

              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}