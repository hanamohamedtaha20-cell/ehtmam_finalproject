import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/ad_provider_model.dart';

class BlockProviderDialog extends StatelessWidget {
  final AdProviderModel provider;
  final VoidCallback onBlock;

  const BlockProviderDialog({
    super.key,
    required this.provider,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    final reasonController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Block Provider',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Text(
              'Provider:',
              style: TextStyle(
                color: Color(0xff64748B),
                fontSize: 12.sp,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              provider.name,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff111827),
              ),
            ),

            Text(
              provider.service,
              style: TextStyle(
                color: Color(0xff64748B),
                fontSize: 12.sp,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              'Reason for Blocking *',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xff111827),
              ),
            ),

            SizedBox(height: 8.h),

            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Explain why you are blocking this provider...',
                hintStyle: TextStyle(
                  color: Color(0xff94A3B8),
                  fontSize: 13.sp,
                ),
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Color(0xffE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Color(0xffE2E8F0),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              'This reason will be stored for record keeping and may be shared with the provider.',
              style: TextStyle(
                fontSize: 11.sp,
                color: Color(0xff64748B),
              ),
            ),

            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF1F5F9),
                        foregroundColor: const Color(0xff334155),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        onBlock();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                      ),
                      child: Text('Block'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}