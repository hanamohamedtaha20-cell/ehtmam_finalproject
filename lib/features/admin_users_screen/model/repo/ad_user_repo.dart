import '../AD_user_model.dart';
import 'ad_user_repository.dart';

class AdUserRepositoryImpl implements AdUserRepository {
  @override
  Future<List<AdUserModel>> getUsers() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      AdUserModel(
        id: 1,
        name: "Sarah Johnson",
        email: "sarah.j@email.com",
        bookings: 24,
        joinedDate: "Jun 2026",
        isActive: true,
        isPremium: false,
      ),
      AdUserModel(
        id: 2,
        name: "Ahmed Hassan",
        email: "ahmed@email.com",
        bookings: 12,
        joinedDate: "Feb 2026",
        isActive: true,
        isPremium: true,
      ),
    ];
  }

  @override
  Future<void> blockUser(int userId) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}