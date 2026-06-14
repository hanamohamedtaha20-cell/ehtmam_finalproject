import '../AD_user_model.dart';
import 'ad_user_repository.dart';

class AdUserRepositoryImpl
    implements AdUserRepository {

  @override
  Future<List<AdUserModel>> getUsers() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      AdUserModel(
        id: '1',
        name: 'Sarah Johnson',
        email: 'sarah.j@email.com',
        bookingsCount: 24,
        createdAt: '2026-06-01',
      ),
      AdUserModel(
        id: '2',
        name: 'Ahmed Hassan',
        email: 'ahmed@email.com',
        bookingsCount: 12,
        createdAt: '2026-02-01',
      ),
    ];
  }

  @override
  Future<void> blockUser(
      String userId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}