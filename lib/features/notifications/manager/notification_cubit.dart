import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/notification_repo.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _repo;

  NotificationCubit(this._repo) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    if (isClosed) return;
    emit(NotificationLoading());
    try {
      final notifications = await _repo.getNotifications();
      if (!isClosed) emit(NotificationLoaded(notifications));
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }
}
