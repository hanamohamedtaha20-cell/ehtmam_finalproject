import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:ehtemam_final_project/core/utils/api_error_message.dart';
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

  try {
    final bookingId =
        await ProviderRepository().acceptOfferAndCreateBooking(offerId);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bookingId', bookingId);

    if (!context.mounted) return;
    Navigator.pop(context);

    await context.read<PaymentCubit>().loadData(offerPrice: offerPrice);

    if (!context.mounted) return;

    if (popOnSuccess) {
      Navigator.pop(context);
    }

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PaymentCubit>(),
          child: const PaymentScreen(),
        ),
      ),
    );
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
