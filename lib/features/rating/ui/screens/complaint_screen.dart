import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _caregiverNameController = TextEditingController();
  final _yourNameController      = TextEditingController();
  final _subjectController       = TextEditingController();
  final _descriptionController   = TextEditingController();

  String? _selectedCategory;
  bool _isSubmitting = false;

  static const List<String> _categories = [
    'Unprofessional Behavior',
    'Late Arrival',
    'Poor Service Quality',
    'Billing Issue',
    'Safety Concern',
    'Other',
  ];

  @override
  void dispose() {
    _caregiverNameController.dispose();
    _yourNameController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Arimo',
          fontSize: 13.sp,
          color: const Color(0xFFADB5BD),
        ),
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
              fontFamily: 'Arimo',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D2939),
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Complaint submitted successfully',
          style: TextStyle(fontFamily: 'Arimo', fontSize: 13.sp),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF1D2939), size: 22.r),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Submit Complaint',
          style: TextStyle(
            fontFamily: 'Arimo',
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
                          "We're here to help",
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D4ED8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Please provide as much detail as possible.\nWe'll review your complaint within 24-48 hours.",
                          style: TextStyle(
                            fontFamily: 'Arimo',
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

            // Caregiver Name
            _label('Caregiver Name'),
            TextFormField(
              controller: _caregiverNameController,
              decoration: _fieldDecoration("Enter caregiver's full name"),
              style: TextStyle(fontFamily: 'Arimo', fontSize: 13.sp),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            SizedBox(height: 16.h),

            // Your Name
            _label('Your Name'),
            TextFormField(
              controller: _yourNameController,
              decoration: _fieldDecoration("Enter your full name"),
              style: TextStyle(fontFamily: 'Arimo', fontSize: 13.sp),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            SizedBox(height: 16.h),

            // Complaint Category
            _label('Complaint Category'),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: _fieldDecoration('').copyWith(hintText: null),
              hint: Text(
                'Select a category',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 13.sp,
                  color: const Color(0xFFADB5BD),
                ),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c,
                          style: TextStyle(
                              fontFamily: 'Arimo', fontSize: 13.sp),
                        ),
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
              decoration:
                  _fieldDecoration("Brief summary of your complaint"),
              style: TextStyle(fontFamily: 'Arimo', fontSize: 13.sp),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            SizedBox(height: 16.h),

            // Description
            _label('Description'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: _fieldDecoration(
                'Please describe your complaint in detail. Include dates, names, and any relevant information.',
              ),
              style: TextStyle(fontFamily: 'Arimo', fontSize: 13.sp),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.trim().length < 20) {
                  return 'Minimum 20 characters';
                }
                return null;
              },
            ),

            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 2.w),
              child: Text(
                'Minimum 20 characters',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 11.sp,
                  color: const Color(0xFF98A2B3),
                ),
              ),
            ),

            SizedBox(height: 28.h),

            // Submit button
            SizedBox(
              height: 50.h,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A8BD7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: _isSubmitting
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
                  'Submit Complaint',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            Center(
              child: Text(
                'By submitting, you agree that the information provided is accurate.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 11.sp,
                  color: const Color(0xFF98A2B3),
                ),
              ),
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
