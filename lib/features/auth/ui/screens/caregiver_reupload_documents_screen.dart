import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_service.dart';
import '../screens/pending_aproval_screen.dart';
import '../widgets/upload_box.dart';
import 'package:easy_localization/easy_localization.dart';

class CaregiverReuploadDocumentsScreen extends StatefulWidget {
  const CaregiverReuploadDocumentsScreen({super.key});

  @override
  State<CaregiverReuploadDocumentsScreen> createState() =>
      _CaregiverReuploadDocumentsScreenState();
}

class _CaregiverReuploadDocumentsScreenState
    extends State<CaregiverReuploadDocumentsScreen> {
  PlatformFile? _profileFile;
  PlatformFile? _nationalIdFile;
  PlatformFile? _certificateFile;

  bool _isLoading = false;

  Future<void> _pickFile(void Function(PlatformFile) onPicked) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      onPicked(result.files.first);
    }
  }

  Future<void> _submit() async {
    if (_profileFile == null &&
        _nationalIdFile == null &&
        _certificateFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('upload_at_least_one_doc'.tr()),
          backgroundColor: const Color(0xFF7EC4F0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';
      final name = prefs.getString('user_name') ?? '';
      final email = prefs.getString('user_email') ?? '';
      final phone = prefs.getString('user_phone') ?? '';

      if (userId.isEmpty) {
        throw Exception('User session expired. Please log in again.');
      }

      await ApiService().updateCaregiverDocuments(
        id: userId,
        profileFile: _profileFile,
        nationalIdFile: _nationalIdFile,
        certificateFile: _certificateFile,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PendingApprovalScreen(
            fullName: name,
            email: email,
            phoneNumber: phone,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed_submit_docs'.tr()),
          backgroundColor: const Color(0xFF7EC4F0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16.r,
                          color: const Color(0xff64748B),
                        ),
                        SizedBox(width: 2.w),
                        Text('back'.tr(),
                          style: TextStyle(
                            color: const Color(0xff64748B),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: const Color(0xffEFF6FF),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: const Color(0xff2F93E6),
                              size: 20.r,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text('upload_clear_docs'.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xff1D4ED8),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      Text('upload_documents'.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff111827),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text('update_docs_resubmit'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xff64748B),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      UploadBox(
                        title: 'Profile Picture',
                        fileName: _profileFile?.name,
                        onTap: () => _pickFile(
                          (f) => setState(() => _profileFile = f),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      UploadBox(
                        title: 'National ID',
                        fileName: _nationalIdFile?.name,
                        onTap: () => _pickFile(
                          (f) => setState(() => _nationalIdFile = f),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      UploadBox(
                        title: 'Certificate',
                        fileName: _certificateFile?.name,
                        onTap: () => _pickFile(
                          (f) => setState(() => _certificateFile = f),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2F93E6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text('submit_documents'.tr(),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
