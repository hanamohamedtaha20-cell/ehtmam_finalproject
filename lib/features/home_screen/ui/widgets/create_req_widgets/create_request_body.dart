import 'package:ehtemam_final_project/features/home_screen/ui/widgets/create_req_widgets/submit_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../requests_screen_user/ui/screens/requests_screen.dart';
import '../../../manager/create_request_cubit.dart';
import '../../../manager/state/create_request_state.dart';
import 'app_input_field.dart';
import 'app_text_area_field.dart';
import 'date_time_section.dart';
import 'governorate_field.dart';
import 'request_description_field.dart';
import 'tasks_section.dart';

class CreateRequestBody extends StatelessWidget {
  final String serviceId;
  final String serviceName;

  const CreateRequestBody({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Create Request "),
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
                controller: context.read<CreateRequestCubit>().durationController,
              ),

              const SizedBox(height: 16),

              const GovernorateField(),

              const SizedBox(height: 16),

              BlocBuilder<CreateRequestCubit, CreateRequestState>(
                builder: (context, state) {
                  final cubit = context.read<CreateRequestCubit>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppInputField(
                        title: "Budget (EGP)",
                        hint: "Enter your budget",
                        icon: Icons.attach_money,
                        isRequired: true,
                        controller: cubit.budgetController,
                      ),
                      if (cubit.isBudgetEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            'Budget is required',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              AppTextAreaField(
                title: "Special Requirements",
                hint: "Any special requirements or notes...",
                isRequired: false,
                controller: context.read<CreateRequestCubit>().notesController,
              ),

              const SizedBox(height: 16),

              BlocBuilder<CreateRequestCubit, CreateRequestState>(
                builder: (context, state) {
                  final cubit = context.read<CreateRequestCubit>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TasksSection(),
                      if (cubit.isTasksEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            'Please add at least one task',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              BlocConsumer<CreateRequestCubit,
                  CreateRequestState>(
                listener: (context, state) {

                  if (state is CreateRequestSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Request Created Successfully"),
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestsScreen(),
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
                      context.read<CreateRequestCubit>().submitRequest(
                        serviceId: serviceId,
                      );
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