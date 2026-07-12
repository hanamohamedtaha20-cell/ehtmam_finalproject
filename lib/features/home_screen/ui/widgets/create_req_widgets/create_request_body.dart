import 'package:ehtemam_final_project/features/home_screen/ui/widgets/create_req_widgets/submit_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:easy_localization/easy_localization.dart';

class CreateRequestBody extends StatelessWidget {
  final String serviceId;
  final String serviceName;
  final String serviceType;

  const CreateRequestBody({
    super.key,
    required this.serviceId,
    required this.serviceName,
    this.serviceType = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Create Request "),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),

        child: Form(
          key: context
              .read<CreateRequestCubit>()
              .formKey,

          child: Column(
            children: [
              // RequestDescriptionField(
              //   controller: context.read<CreateRequestCubit>().descriptionController,
              // ),

              // SizedBox(height: 16.h),

              DateTimeSection(),

              SizedBox(height: 16.h),

              AppInputField(
                title: "Duration",
                hint: "Enter duration",
                controller: context.read<CreateRequestCubit>().durationController,
              ),

              SizedBox(height: 16.h),

              const GovernorateField(),

              SizedBox(height: 16.h),

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
                        Padding(
                          padding: EdgeInsets.only(top: 6.h, left: 4.w),
                          child: Text('budget_required'.tr(),
                            style: TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: 16.h),

              AppTextAreaField(
                title: "Description",
                hint: "Any special requirements or notes...",
                isRequired: false,
                controller: context.read<CreateRequestCubit>().notesController,
              ),

              SizedBox(height: 16.h),

              BlocBuilder<CreateRequestCubit, CreateRequestState>(
                builder: (context, state) {
                  final cubit = context.read<CreateRequestCubit>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TasksSection(),
                      if (cubit.isTasksEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h, left: 4.w),
                          child: Text('add_at_least_one_task'.tr(),
                            style: TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: 24.h),

              BlocConsumer<CreateRequestCubit,
                  CreateRequestState>(
                listener: (context, state) {

                  if (state is CreateRequestSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('request_created'.tr()),
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
                  final cubit = context.read<CreateRequestCubit>();

                  if (state is CreateRequestLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      if (cubit.isServiceTypeEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text('service_type_required'.tr(),
                            style: TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                        ),
                      SubmitRequest(
                        onSubmit: () {
                          cubit.submitRequest(
                            serviceId: serviceId,
                            serviceType: serviceType,
                          );
                        },
                      ),
                    ],
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