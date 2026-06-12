import '../AD_user_model.dart';

abstract class AdUserRepository {
  Future<List<AdUserModel>> getUsers();

  Future<void> blockUser(int userId);
}