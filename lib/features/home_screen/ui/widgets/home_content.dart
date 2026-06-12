import 'package:easy_localization/easy_localization.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/home_screen/data/repo/home_repo.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/home_cubit.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/crearte_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../requests_screen_user/ui/screens/requests_screen.dart';
import '../../data/model/user_model.dart';
import '../../manager/state/home_state.dart';
import '../screens/bundels_screen.dart';
import 'bundles_card.dart';
import 'request_card.dart';
import 'header.dart';
import 'service_card.dart';
import 'whyChoose_card.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final user = UserModel(name: "ahmed");

  Widget getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();

    if (name.contains('pet')) {
      return const Text('🐾', style: TextStyle(fontSize: 24));
    } else if (name.contains('elderly')) {
      return const Text('👵', style: TextStyle(fontSize: 24));
    } else if (name.contains('child')) {
      return const Text('👶', style: TextStyle(fontSize: 24));
    } else if (name.contains('plant')) {
      return const Text('🌿', style: TextStyle(fontSize: 24));
    } else {
      return const Text('🩺', style: TextStyle(fontSize: 24));
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
    return BlocProvider(
      create: (context) => HomeCubit(
        HomeRepo(ApiService()),)..getServices(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            HeaderWidget(user: user),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 1,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Select a Service".tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HomeError) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                if (state is HomeSuccess) {
                  if (state.services.isEmpty) {
                    return const Text("No services available");
                  }

                  return Column(
                    children: List.generate(state.services.length, (index) {
                      final service = state.services[index];

                      final name = service.name.toLowerCase();

                      List<Color> gradientColors = [
                        Colors.blue.shade100,
                        Colors.blue.shade300,
                      ];

                      List<Color> bgColors = const [
                        Color(0xFFF5F3FF),
                        Color(0xFFFAF5FF),
                      ];

                      Widget icon = const Text(
                        '🐾',
                        style: TextStyle(fontSize: 24),
                      );

                      if (name.contains('elderly')) {
                        gradientColors = [
                          Colors.blue.shade300,
                          Colors.blue.shade600,
                        ];

                        bgColors = const [
                          Color(0xFFEEF2FF),
                          Color(0xFFF5F3FF),
                        ];

                        icon = const Text(
                          '👵',
                          style: TextStyle(fontSize: 24),
                        );
                      }

                      if (name.contains('child')) {
                        gradientColors = [
                          Colors.purple,
                          Colors.pink,
                        ];

                        bgColors = const [
                          Color(0xFFFAF5FF),
                          Color(0xFFFDF2F8),
                        ];

                        icon = const Text(
                          '👶',
                          style: TextStyle(fontSize: 24),
                        );
                      }

                      if (name.contains('plant')) {
                        gradientColors = [
                          Colors.green.shade400,
                          Colors.green.shade700,
                        ];

                        bgColors = const [
                          Color(0xFFF1F2FF),
                          Color(0xFFF1F2FF),
                        ];

                        icon = const Text(
                          '🌿',
                          style: TextStyle(fontSize: 24),
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

                return const SizedBox();
              },
            ),

            const SizedBox(height: 20),

            BundlesCard(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceBundlesScreen(),
                ),
              );
            }),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Requests".tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            RequestCardWidget(
              title: "Pet Care".tr(),
              date: "March 15, 2026".tr(),
              status: "Pending".tr(),
              statusColor: Colors.orange,
              description: "Dog • 5 days".tr(),
              provider: "".tr(),
            ),

            RequestCardWidget(
              title: "Elderly Care".tr(),
              date: "March 20, 2026".tr(),
              status: "Accepted".tr(),
              statusColor: Colors.green,
              description: "3 days".tr(),
              provider: "Provider: Fatma Medical Care".tr(),
            ),

            const SizedBox(height: 20),

            Text(
              "Why Choose Ehtemam".tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}