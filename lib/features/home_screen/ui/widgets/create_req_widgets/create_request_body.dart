import 'package:ehtemam_final_project/features/home_screen/ui/widgets/create_req_widgets/submit_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/create_request_cubit.dart';
import '../../../manager/state/create_request_state.dart';
import 'app_input_field.dart';
import 'app_text_area_field.dart';
import 'date_time_section.dart';
import 'request_description_field.dart';
import 'tasks_section.dart';

class CreateRequestBody extends StatelessWidget {
  const CreateRequestBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Create Request"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: context
              .read<CreateRequestCubit>()
              .formKey,

          child: Column(
            children: [
              RequestDescriptionField(),

              const SizedBox(height: 16),

              DateTimeSection(),

              const SizedBox(height: 16),

              AppInputField(
                title: "Duration",
                hint: "Enter duration",
              ),

              const SizedBox(height: 16),

              AppInputField(
                title: "Location",
                hint: "Enter your location",
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 16),

              AppInputField(
                title: "Budget (EGP)",
                hint: "Enter your budget",
                icon: Icons.attach_money,
              ),

              const SizedBox(height: 16),

              AppTextAreaField(
                title: "Special Requirements",
                hint: "Any special requirements or notes...",
                isRequired: false,
              ),

              const SizedBox(height: 16),

              TasksSection(),

              const SizedBox(height: 24),

              BlocConsumer<CreateRequestCubit,
                  CreateRequestState>(
                listener: (context, state) {

                  if (state is CreateRequestSuccess) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Request Created Successfully",
                        ),
                      ),
                    );
                  }

                  if (state is CreateRequestError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },

                builder: (context, state) {

                  if (state
                  is CreateRequestLoading) {
                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  return SubmitRequest(
                    onSubmit: () {
                      context.read<CreateRequestCubit>().submitRequest();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}