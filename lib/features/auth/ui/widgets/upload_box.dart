import 'package:ehtemam_final_project/core/resources/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadBox extends StatelessWidget {
  final String title;
  final bool isRequired;
  final VoidCallback onTap;
  final String? fileName;
  final String acceptedFormats;

  const UploadBox({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.onTap,
    this.fileName,
    this.acceptedFormats = 'PNG, JPG, JPEG',
  });

  @override
  Widget build(BuildContext context) {
    final bool hasFile = fileName != null && fileName!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyle.medium.copyWith(
              fontSize: 12.sp,
              color: const Color(0xFF7D8896),
            ),
            children: [
              TextSpan(text: title),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: hasFile
                    ? const Color(0xFF7A6AF2)
                    : const Color(0xFFD8DEE8),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EFFF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    hasFile
                        ? Icons.check_circle_outline_rounded
                        : Icons.file_upload_outlined,
                    color: const Color(0xFF7A6AF2),
                    size: 24.r,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  hasFile ? fileName! : 'Click to upload',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.medium.copyWith(
                    fontSize: 12.sp,
                    color: hasFile
                        ? const Color(0xFF344054)
                        : const Color(0xFF667085),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  hasFile ? 'File selected successfully' : acceptedFormats,
                  style: AppTextStyle.regular.copyWith(
                    fontSize: 10.sp,
                    color: const Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}