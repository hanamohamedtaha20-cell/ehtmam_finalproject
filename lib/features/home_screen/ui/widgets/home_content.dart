import 'package:easy_localization/easy_localization.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/home_screen/data/repo/home_repo.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/home_cubit.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/crearte_request.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/data/repo/requests_repo.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/manager/requests_user_cubit.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/manager/state/requests_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/manager/auth_cubit.dart';
import '../../../requests_screen_user/ui/screens/requests_screen.dart';
import '../../data/model/user_model.dart';
import '../../manager/state/home_state.dart';
import '../screens/bundels_screen.dart';
import 'bundles_card.dart';
import 'request_card.dart';
import 'header.dart';
import 'service_card.dart';
import 'whyChoose_card.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  UserModel _user = UserModel(name: '');

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    // AuthCubit state is the most reliable source during the current session.
    final isGuestByState = context.read<AuthCubit>().state.isGuest;

    // SharedPreferences covers the case where the app was restarted in guest mode.
    final prefs = await SharedPreferences.getInstance();
    final isGuestByPrefs = prefs.getBool('is_guest') ?? false;

    if (isGuestByState || isGuestByPrefs) {
      if (mounted) setState(() => _user = UserModel(name: 'Guest'));
      return;
    }

    final name = prefs.getString('user_name') ?? '';
    if (mounted) setState(() => _user = UserModel(name: name));
  }

  Widget getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();

    if (name.contains('pet')) {
      return Text('🐾', style: TextStyle(fontSize: 24.sp));
    } else if (name.contains('elderly')) {
      return Text('👵', style: TextStyle(fontSize: 24.sp));
    } else if (name.contains('child')) {
      return Text('👶', style: TextStyle(fontSize: 24.sp));
    } else if (name.contains('plant')) {
      return Text('🌿', style: TextStyle(fontSize: 24.sp));
    } else if (name.contains('shopping')) {
      return Text('🛒', style: TextStyle(fontSize: 24.sp));
    } else if (name.contains('nursing') || name.contains('nurse')) {
      return Text('👩‍⚕️', style: TextStyle(fontSize: 24.sp));
    } else {
      return Text('🩺', style: TextStyle(fontSize: 24.sp));
    }
  }

  List<Color> getGradientColors(int index) {
    final colors = [
      [Colors.blue.shade100, Colors.blue.shade300],
      [Colors.blue.shade300, Colors.blue.shade600],
      [Colors.purple, Colors.pink],
      [Colors.green.shade400, Colors.green.shade700],
    ];

    return colors[index % colors.length];
  }

  List<Color> getBGColors(int index) {
    final colors = [
      [const Color(0xFFF5F3FF), const Color(0xFFFAF5FF)],
      [const Color(0xFFEEF2FF), const Color(0xFFF5F3FF)],
      [const Color(0xFFFAF5FF), const Color(0xFFFDF2F8)],
      [const Color(0xFFF1F2FF), const Color(0xFFF1F2FF)],
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = context.read<AuthCubit>().state.isGuest;
    return BlocProvider(
      create: (context) => HomeCubit(
        HomeRepo(ApiService()),)..getServices(),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: ListView(
          children: [
            HeaderWidget(user: _user),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              height: 1.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.r,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              "Select a Service".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),

            SizedBox(height: 10.h),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is HomeError) {
                  return Text(
                    state.message,
                    style: TextStyle(color: Colors.red),
                  );
                }
                if (state is HomeSuccess) {
                  if (state.services.isEmpty) {
                    return Text("No services available");
                  }

                  return Column(
                    children: List.generate(state.services.length, (index) {
                      final service = state.services[index];

                      final name = service.name.toLowerCase();

                      List<Color> gradientColors = [
                        Colors.blue.shade100,
                        Colors.blue.shade300,
                      ];

                      List<Color> bgColors = [
                        Color(0xFFF5F3FF),
                        Color(0xFFFAF5FF),
                      ];

                      Widget icon = Text(
                        '🐾',
                        style: TextStyle(fontSize: 24.sp),
                      );

                      if (name.contains('elderly')) {
                        gradientColors = [
                          Colors.blue.shade300,
                          Colors.blue.shade600,
                        ];

                        bgColors = [
                          Color(0xFFEEF2FF),
                          Color(0xFFF5F3FF),
                        ];

                        icon = Text(
                          '👵',
                          style: TextStyle(fontSize: 24.sp),
                        );
                      }

                      if (name.contains('child')) {
                        gradientColors = [
                          Colors.purple,
                          Colors.pink,
                        ];

                        bgColors = [
                          Color(0xFFFAF5FF),
                          Color(0xFFFDF2F8),
                        ];

                        icon = Text(
                          '👶',
                          style: TextStyle(fontSize: 24.sp),
                        );
                      }

                      if (name.contains('plant')) {
                        gradientColors = [
                          Colors.green.shade400,
                          Colors.green.shade700,
                        ];

                        bgColors = [
                          Color(0xFFF1F2FF),
                          Color(0xFFF1F2FF),
                        ];

                        icon = Text(
                          '🌿',
                          style: TextStyle(fontSize: 24.sp),
                        );
                      }

                      if (name.contains('shopping')) {
                        gradientColors = [
                          Colors.blue.shade100,
                          Colors.blue.shade300,
                        ];

                        bgColors = [
                          Color(0xFFF5F3FF),
                          Color(0xFFFAF5FF),
                        ];

                        icon = Text(
                          '🛒',
                          style: TextStyle(fontSize: 24.sp),
                        );
                      }

                      if (name.contains('nursing') || name.contains('nurse')) {
                        gradientColors = [
                          Colors.purple,
                          Colors.pink,
                        ];

                        bgColors = [
                          Color(0xFFFAF5FF),
                          Color(0xFFFDF2F8),
                        ];

                        icon = Text(
                          '👩‍⚕️',
                          style: TextStyle(fontSize: 24.sp),
                        );
                      }

                      return ServiceCardWidget(
                        icon: icon,
                        gradientColors: gradientColors,
                        title: service.name,
                        subtitle: service.description,
                        gradientBGColors: bgColors,
                        page: CreateRequestScreen(
                          serviceId: service.id,
                          serviceName: service.name,
                        ),
                      );
                    }),
                  );
                }

                return SizedBox();
              },
            ),

            SizedBox(height: 20.h),

            BundlesCard(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceBundlesScreen(),
                ),
              );
            }),

            SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Requests".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "View All".tr(),
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            if (isGuest)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  'No active requests'.tr(),
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                ),
              )
            else
              BlocProvider(
                create: (_) =>
                    RequestsCubit(RequestsRepo(ApiService()))..getRequests(),
                child: BlocBuilder<RequestsCubit, RequestsState>(
                  builder: (context, state) {
                    if (state is RequestsLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is RequestsError) {
                      return Text(state.message,
                          style: TextStyle(color: Colors.red));
                    }
                    if (state is RequestsSuccess) {
                      final active = state.requests
                          .where((r) =>
                              r.status == 'Pending' || r.status == 'Accepted')
                          .take(2)
                          .toList();

                      if (active.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            'No active requests'.tr(),
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13.sp),
                          ),
                        );
                      }

                      return Column(
                        children: active.map((r) {
                          final Color statusColor = r.status == 'Accepted'
                              ? Colors.green
                              : r.status == 'Completed'
                                  ? Colors.blue
                                  : r.status == 'Cancelled'
                                      ? Colors.red
                                      : Colors.orange;

                          return RequestCardWidget(
                            title: r.title,
                            date: r.date,
                            status: r.status,
                            statusColor: statusColor,
                            description: r.subtitle,
                            provider: r.provider ?? '',
                          );
                        }).toList(),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),

            SizedBox(height: 20.h),

            Text(
              "Why Choose Ehtemam".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),

            SizedBox(height: 10.h),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.9,
              children: [
                WhyChooseCardWidget(
                  icon: 'assets/images/Container.png',
                  title: "verified\nProviders".tr(),
                ),
                WhyChooseCardWidget(
                  icon: 'assets/images/Container2.png',
                  title: "Trusted Care".tr(),
                ),
                WhyChooseCardWidget(
                  icon: 'assets/images/Container 3.png',
                  title: "24/7 Support".tr(),
                ),
                WhyChooseCardWidget(
                  icon: 'assets/images/Container 4.png',
                  title: "Experienced\nStaff".tr(),
                ),
              ],
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}