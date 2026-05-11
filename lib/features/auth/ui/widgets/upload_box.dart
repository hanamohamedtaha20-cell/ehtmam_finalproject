import 'package:flutter/material.dart';
import 'package:ehtmam_finalproject/core/resources/app_text_style.dart';

class UploadBox extends StatelessWidget {
  final String title;
  final bool isRequired;
  final VoidCallback onTap;
  final String? fileName;

  const UploadBox({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.onTap,
    this.fileName,
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
              fontSize: 12,
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
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasFile
                    ? const Color(0xFF7A6AF2)
                    : const Color(0xFFD8DEE8),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EFFF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    hasFile
                        ? Icons.check_circle_outline_rounded
                        : Icons.file_upload_outlined,
                    color: const Color(0xFF7A6AF2),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  hasFile ? fileName! : 'Click to upload',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.medium.copyWith(
                    fontSize: 12,
                    color: hasFile
                        ? const Color(0xFF344054)
                        : const Color(0xFF667085),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasFile ? 'File selected successfully' : 'PNG, JPG, JPEG',
                  style: AppTextStyle.regular.copyWith(
                    fontSize: 10,
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