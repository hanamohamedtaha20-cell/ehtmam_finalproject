import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:ehtemam_final_project/core/utils/api_error_message.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/ui/screens/payment_screen.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/data/repo/Provider_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> acceptOffer({
  required BuildContext context,
  required String offerId,
  required String requestId,
  double? offerPrice,
  bool popOnSuccess = false,
}) async {
  if (offerId.trim().isEmpty) {
    CustomSnackBar.show(context, message: 'Offer id is missing');
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  final repository = ProviderRepository();

  try {
    await repository.acceptOffer(
      offerId,
      requestId: requestId,
    );

    final bookingId = await repository.findBookingForAcceptedOffer(
      offerId,
      requestId: requestId,
    );

    final prefs = await SharedPreferences.getInstance();
    if (bookingId.isNotEmpty) {
      await prefs.setString('bookingId', bookingId);
    } else {
      await prefs.remove('bookingId');
    }
    await prefs.setString('acceptedOfferId', offerId.trim());

    if (!context.mounted) return;
    Navigator.pop(context);

    if (popOnSuccess && Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    if (!context.mounted) return;

    final paymentDone = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              PaymentCubit(PaymentRepo())..loadData(offerPrice: offerPrice),
          child: const PaymentScreen(),
        ),
      ),
    );

    // Payment succeeded — go to HomeScreen on the Booking tab (index 2)
    if (paymentDone == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(initialIndex: 2),
        ),
        (_) => false,
      );
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
      CustomSnackBar.show(
        context,
        message: apiErrorMessage(e),
      );
    }
  }
}
