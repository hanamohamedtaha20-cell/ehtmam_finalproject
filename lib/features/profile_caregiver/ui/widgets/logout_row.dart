import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutRow extends StatelessWidget {
  const LogoutRow({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _logout(context),
      child: Container(
        margin: const EdgeInsets.all(12),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color.fromARGB(109, 244, 67, 54)),
          boxShadow: const [
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 18),
            SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthCubit>().logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }
}
