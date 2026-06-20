import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../../auth/manager/auth_cubit.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/widgets/filter.dart';
import '../../../home_screen/ui/screens/home_screen.dart';
import '../../data/repo/requests_repo.dart';
import '../../manager/requests_user_cubit.dart';
import '../../manager/state/requests_user_state.dart';
import '../widgets/request_card_widget.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthCubit>().state.isGuest) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Text(
                'Please login to view your requests.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => RequestsCubit(RequestsRepo(ApiService()))..getRequests(),
      child: const RequestsView(),
    );
  }
}

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() =>
      _RequestsViewState();
}

class _RequestsViewState
    extends State<RequestsView> {

  String selectedTab = "All";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔹 Header
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "My Requests".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  Spacer(),
                  BlocBuilder<RequestsCubit, RequestsState>(
                    builder: (context, state) {
                      if (state is RequestsLoading) {
                        return SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }

                      return IconButton(
                        onPressed: () =>
                            context.read<RequestsCubit>().getRequests(),
                        icon: Icon(Icons.refresh_rounded),
                        tooltip: 'try_again'.tr(),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// 🔹 Filter Tabs
            Filter(

              selectedTab: selectedTab,

              onTabChanged: (tab) {

                setState(() {

                  selectedTab = tab;
                });
              },
            ),

            SizedBox(height: 10.h),

            /// 🔹 Requests List
            Expanded(
              child: BlocBuilder<
                  RequestsCubit,
                  RequestsState>(

                builder: (
                    context,
                    state,
                    ) {

                  /// LOADING
                  if (state
                  is RequestsLoading) {

                    return Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  /// ERROR
                  if (state is RequestsError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              size: 48.r,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                                height: 1.5.h,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<RequestsCubit>().getRequests(),
                              icon: Icon(Icons.refresh_rounded, size: 18.r),
                              label: Text('try_again'.tr()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  /// SUCCESS
                  if (state
                  is RequestsSuccess) {

                    final filteredRequests =
                    state.requests.where((
                        request,
                        ) {

                      if (selectedTab == "All") {
                        return true;
                      }

                      return request.status.toLowerCase() == selectedTab.toLowerCase();

                    }).toList();

                    if (filteredRequests
                        .isEmpty) {

                      return Center(
                        child: Text(
                          "No Requests Found"
                              .tr(),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<RequestsCubit>().getRequests(),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(16.r),
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          final request = filteredRequests[index];
                          return RequestCardWidget(request: request);
                        },
                      ),
                    );
                  }

                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}