import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/create_request_cubit.dart';
import '../../../manager/state/create_request_state.dart';
import 'app_card.dart';

class GovernorateField extends StatelessWidget {
  static const governorates = ['Giza', 'Cairo'];

  const GovernorateField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRequestCubit, CreateRequestState>(
      builder: (context, state) {
        final cubit = context.read<CreateRequestCubit>();

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Governorate',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: cubit.selectedGovernorate,
                decoration: InputDecoration(
                  hintText: 'Select governorate',
                  prefixIcon: const Icon(Icons.map_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  errorText:
                      cubit.isGovernorateEmpty ? 'This field is required' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: governorates
                    .map(
                      (governorate) => DropdownMenuItem(
                        value: governorate,
                        child: Text(governorate),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    cubit.setGovernorate(value);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
