import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_screen_user.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/bottom_nav_bar.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:ehtemam_final_project/features/login_required_screen/ui/screens/login_requred_screen.dart';
import 'package:ehtemam_final_project/features/profile2/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/home_content.dart';
import '../../../auth/manager/auth_cubit.dart';
import '../../../auth/manager/auth_state.dart';
import '../../../requests_screen_user/ui/screens/requests_screen.dart';


class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomeContent(),
    RequestsScreen(),
    BookingScreenUser(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              IndexedStack(index: _currentIndex, children: _pages),
              if (authState.isGuest)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginRequiredScreen(),
                        ),
                      );
                    },
                  ),
                ),
              Positioned(
                top: 40.h,
                right: Directionality.of(context) == TextDirection.ltr ? 16 : null,
                left: Directionality.of(context) == TextDirection.rtl ? 16 : null,
                child: LanguageSwitcher(),
              ),
            ],
          ),
          bottomNavigationBar: UserBottomNavScreen(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
