import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/task_progress_user/data/repo/task_progress_repo.dart';
import 'package:ehtemam_final_project/features/task_progress_user/manager/task_progress_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PayResultType { success, insufficientFunds, error }

class ExtraTaskPayResult {
  final PayResultType type;
  final String? errorMessage;
  final double? walletBalance;
  final double? requiredAmount;

  const ExtraTaskPayResult._(this.type, {this.errorMessage, this.walletBalance, this.requiredAmount});

  static final ExtraTaskPayResult success = ExtraTaskPayResult._(PayResultType.success);

  factory ExtraTaskPayResult.insufficientFunds({required double balance, required double required}) =>
      ExtraTaskPayResult._(PayResultType.insufficientFunds, walletBalance: balance, requiredAmount: required);

  factory ExtraTaskPayResult.error(String message) =>
      ExtraTaskPayResult._(PayResultType.error, errorMessage: message);

  bool get isSuccess         => type == PayResultType.success;
  bool get isInsufficientFunds => type == PayResultType.insufficientFunds;
  bool get isError           => type == PayResultType.error;
}

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
      final taskData = response['data'];
      if (taskData is Map) {
        debugPrint('TASK_ID: ${taskData['_id'] ?? taskData['taskId']}');
        debugPrint('TASK_STATE: ${taskData['taskState']}');
      }
      return null;
    } catch (e) {
      debugPrint('[ExtraTask] approveExtraTask failed: $e');
      return _friendlyError(e);
    }
  }

  /// Approves an extra task then immediately deducts from wallet.
  /// Returns an [ExtraTaskPayResult] — check [ExtraTaskPayResult.type] to
  /// distinguish success, insufficient funds, or generic error.
  Future<ExtraTaskPayResult> approveAndPayExtraTask(
    String taskId, {
    required String bookingId,
    required double price,
  }) async {
    // 1. Check wallet balance.
    double balance = 0.0;
    try {
      final walletRes = await _api.getMyWallet();
      final raw = walletRes['data'];
      final walletData = (raw is Map && raw['wallet'] is Map)
          ? raw['wallet'] as Map
          : raw is Map
              ? raw
              : null;
      for (final key in ['balance', 'currentBalance', 'current_balance', 'amount']) {
        final val = walletData?[key];
        if (val is num) {
          balance = val.toDouble();
          break;
        }
      }
    } catch (e) {
      debugPrint('[ExtraTask] getMyWallet failed: $e');
      return ExtraTaskPayResult.error(_friendlyError(e));
    }

    debugPrint('[ExtraTask] wallet balance=$balance  price=$price');

    if (price > 0 && balance < price) {
      return ExtraTaskPayResult.insufficientFunds(
        balance: balance,
        required: price,
      );
    }

    // 2. Approve the task.
    final approveError = await approveExtraTask(taskId);
    if (approveError != null) return ExtraTaskPayResult.error(approveError);

    // 3. Charge wallet via /payment/pay-booking-wallet.
    try {
      final payRes = await _api.payExtraTask(taskId, bookingId: bookingId, amount: price);
      debugPrint('[ExtraTask] payExtraTask response: $payRes');
      return ExtraTaskPayResult.success;
    } catch (e) {
      debugPrint('[ExtraTask] payExtraTask failed: $e');
      return ExtraTaskPayResult.error(_friendlyError(e));
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
