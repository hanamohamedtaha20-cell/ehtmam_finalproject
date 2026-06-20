import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/task_progress_user/data/repo/task_progress_repo.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskProgressCubit extends Cubit<TaskProgressState> {
  final TaskProgressRepo _repo;
  final ApiService _api = ApiService();

  TaskProgressCubit(this._repo) : super(TaskProgressInitial());

  Future<void> loadTasks(String bookingId) async {
    if (isClosed) return;
    emit(TaskProgressLoading());
    try {
      final data = await _repo.getProgress(bookingId);
      if (!isClosed) emit(TaskProgressLoaded(data));
    } catch (e) {
      if (!isClosed) emit(TaskProgressError(e.toString()));
    }
  }

  /// Calls PATCH /tasks/{taskId}/approve only. Does NOT refresh the task list.
  /// The caller is responsible for calling [loadTasks] after navigation completes.
  /// Returns null on success, error message on failure.
  Future<String?> approveExtraTask(String taskId) async {
    debugPrint('TASK_APPROVED: $taskId');
    try {
      final response = await _api.approveExtraTask(taskId);
      debugPrint('>>> APPROVE CUBIT RESPONSE: $response');
      // Log taskState from approve response if backend returns it
      final taskData = response['data'];
      if (taskData is Map) {
        debugPrint('TASK_ID: ${taskData['_id'] ?? taskData['taskId']}');
        debugPrint('TASK_STATE: ${taskData['taskState']}');
        debugPrint('TASK_STATUS: ${taskData['taskState']}');
      }
      return null;
    } catch (e) {
      debugPrint('[ExtraTask] approveExtraTask failed: $e');
      return _friendlyError(e);
    }
  }

  /// Calls PATCH /tasks/{taskId}/reject only. Does NOT refresh the task list.
  /// The caller is responsible for calling [loadTasks] after the rejection.
  /// Returns null on success, error message on failure.
  Future<String?> rejectExtraTask(String taskId) async {
    debugPrint('TASK_REJECTED: $taskId');
    try {
      await _api.rejectExtraTask(taskId);
      return null;
    } catch (e) {
      debugPrint('[ExtraTask] rejectExtraTask failed: $e');
      return _friendlyError(e);
    }
  }

  String _friendlyError(Object e) {
    try {
      // ignore: avoid_dynamic_calls
      final dynamic dioE = e;
      final resp = dioE.response;
      if (resp != null) {
        final body = resp.data;
        if (body is Map) {
          final msg = body['message'] ?? body['error'] ?? body['msg'];
          if (msg != null) return msg.toString();
        }
        return 'Server error (${resp.statusCode})';
      }
    } catch (_) {}
    return e.toString();
  }
}
