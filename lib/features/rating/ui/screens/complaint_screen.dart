import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../manager/complaint_cubit.dart';
import '../../manager/complaint_state.dart';

class ComplaintScreen extends StatelessWidget {
  final String bookingId;

  const ComplaintScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComplaintCubit(),
      child: _ComplaintView(bookingId: bookingId),
    );
  }
}

class _ComplaintView extends StatefulWidget {
  final String bookingId;
  const _ComplaintView({required this.bookingId});

  @override
  State<_ComplaintView> createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<_ComplaintView> {
  final _formKey             = GlobalKey<FormState>();
  final _subjectController   = TextEditingController();
  final _messageController   = TextEditingController();

  String? _selectedCategory;

  static const List<String> _categories = [
    'Poor service quality',
    'Late arrival',
    'Unprofessional behavior',
    'Ignored instructions',
    'Requested extra payment',
    'Safety concern',
    'Billing issue',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFADB5BD)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF3A8BD7), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      );

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Text.rich(
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D2939),
            ),
            children: const [
              TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ComplaintCubit>().submitComplaint(
          bookingId:         widget.bookingId,
          subject:           _subjectController.text.trim(),
          message:           _messageController.text.trim(),
          complaintCategory: _selectedCategory!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComplaintCubit, ComplaintState>(
      listener: (context, state) {
        if (state is ComplaintSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'complaint_submitted'.tr(),
                style: TextStyle(fontSize: 13.sp),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state is ComplaintError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyle(fontSize: 13.sp)),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: const Color(0xFF1D2939), size: 22.r),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'submit_complaint'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D2939),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              // Info banner
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: const Color(0xFF3A8BD7), size: 20.r),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'were_here_to_help'.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1D4ED8),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Please provide as much detail as possible.\nWe'll review your complaint within 24–48 hours.",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              color: const Color(0xFF3B82F6),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Complaint Category
              _label('Complaint Category'),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _fieldDecoration('').copyWith(hintText: null),
                hint: Text(
                  'select_category'.tr(),
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFFADB5BD)),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c, style: TextStyle(fontSize: 13.sp)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? 'Required' : null,
              ),

              SizedBox(height: 16.h),

              // Subject
              _label('Subject'),
              TextFormField(
                controller: _subjectController,
                decoration: _fieldDecoration('Brief summary of your complaint'),
                style: TextStyle(fontSize: 13.sp),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),

              SizedBox(height: 16.h),

              // Message
              _label('Message'),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: _fieldDecoration(
                  'Describe your complaint in detail. Include dates, names, and any relevant information.',
                ),
                style: TextStyle(fontSize: 13.sp),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.trim().length < 20) return 'Minimum 20 characters';
                  return null;
                },
              ),

              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 2.w),
                child: Text(
                  'min_20_chars'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF98A2B3)),
                ),
              ),

              SizedBox(height: 28.h),

              // Submit button
              BlocBuilder<ComplaintCubit, ComplaintState>(
                builder: (context, state) {
                  final isLoading = state is ComplaintSubmitting;
                  return SizedBox(
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A8BD7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      icon: isLoading
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.send_rounded, size: 18.r),
                      label: Text(
                        'submit_complaint'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 12.h),

              Center(
                child: Text(
                  'submit_accuracy_agree'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF98A2B3)),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
