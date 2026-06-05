// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../data/repo/payment_repo.dart';
// import '../data/model/payment_model.dart';
// import 'payment_state.dart';

// class PaymentCubit extends Cubit<PaymentState> {
//   final PaymentRepo repo;

//   PaymentCubit(this.repo) : super(PaymentInitial());

//   Future<void> loadData() async {
//   emit(PaymentLoading());
//   try {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final walletId  = prefs.getString('walletId')  ?? '';
//   //   final bookingId = prefs.getString('bookingId') ?? '';

//   //   final walletResult  = await repo.getPaymentData(walletId);
//   //   final bookingResult = await repo.getBookingData(bookingId);

//   //   if (walletResult['status'] == 'success') {
//   //     final walletData  = walletResult['data'];
//   //     final bookingData = bookingResult['data'];

//   //     // الـ price بييجي من الـ booking
//   //     final double price       = (bookingData?['price'] ?? 0).toDouble();
//   //     final double platformFee = price * 0.05;
//   //     final double taxRate     = price * 0.10;
//   //     final double total       = price + platformFee + taxRate;

//   //     final transactions = (walletData['transactions'] as List? ?? [])
//   //         .map((t) => TransactionModel.fromJson(t))
//   //         .toList();

//   //     emit(PaymentLoaded(
//   //       balance:      (walletData['balance']        ?? 0).toDouble(),
//   //       income:       (walletData['totalDeposited'] ?? 0).toDouble(),
//   //       expense:      (walletData['totalSpent']     ?? 0).toDouble(),
//   //       transactions: transactions,
//   //       serviceCost:  price,
//   //       platformFee:  platformFee,
//   //       taxRate:      taxRate,
//   //       total:        total,
//   //     ));
//   //   } else {
//   //     emit(PaymentError(walletResult['message'] ?? 'error'));
//   //   }
//   // } catch (e) {
//   //   emit(PaymentError('failed to connect with server'));
//   // }
//   // }}
//    const walletId = '6a22bff817a74afd7ca19d3c'; // ← هنا

//     final result = await repo.getPaymentData(walletId);

//     if (result['status'] == 'success') {
//       final data = result['data'];

//       final transactions = (data['transactions'] as List? ?? [])
//           .map((t) => TransactionModel.fromJson(t))
//           .toList();

//       emit(PaymentLoaded(
//         balance:      (data['balance']        ?? 0).toDouble(),
//         income:       (data['totalDeposited'] ?? 0).toDouble(),
//         expense:      (data['totalSpent']     ?? 0).toDouble(),
//         transactions: transactions,
//         serviceCost:  0,
//         platformFee:  0,
//         taxRate:      0,
//         total:        0,
//       ));
//     } else {
//       emit(PaymentError(result['message'] ?? 'حدث خطأ'));
//     }
//   } catch (e) {
//     emit(PaymentError((e.toString())));
//   }
// }}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/payment_repo.dart';
import '../data/model/payment_model.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo repo;

  PaymentCubit(this.repo) : super(PaymentInitial());

  Future<void> loadData() async {
    emit(PaymentLoading());
    try {
      const walletId = '6a22bff817a74afd7ca19d3c';

      final result = await repo.getPaymentData(walletId);

      if (result['status'] == 'success') {
        final data = result['data'];

        final transactions = (data['transactions'] as List? ?? [])
            .map((t) => TransactionModel.fromJson(t))
            .toList();

        emit(PaymentLoaded(
          balance:      (data['balance']        ?? 0).toDouble(),
          income:       (data['totalDeposited'] ?? 0).toDouble(),
          expense:      (data['totalSpent']     ?? 0).toDouble(),
          transactions: transactions,
          serviceCost:  0,
          platformFee:  0,
          taxRate:      0,
          total:        0,
        ));
      } else {
        emit(PaymentError(result['message'] ?? 'حدث خطأ'));
      }
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}