import '../../model/AD_user_model.dart';

abstract class AdUserState {}

class UserInitial extends AdUserState {}

class UserLoading extends AdUserState {}

class UserLoaded extends AdUserState {
  final List<AdUserModel> users;

  UserLoaded(this.users);
}

class UsersError extends AdUserState {
  final String message;

  UsersError(this.message);
}

class UserBlocking extends AdUserState {}

class UserBlocked extends AdUserState {
  final String message;

  UserBlocked(this.message);
}