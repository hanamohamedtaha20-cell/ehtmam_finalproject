import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/ad_provider_model.dart';

class BlockProviderDialog extends StatelessWidget {
  final AdProviderModel provider;
  final bool isBlocking;

  const BlockProviderDialog({
    super.key,
    required this.provider,
    this.isBlocking = true,
  });

  @override
  Widget build(BuildContext context) {
    final color  = isBlocking ? Colors.red : Colors.orange;
    final icon   = isBlocking ? Icons.block : Icons.lock_open_rounded;
    final title  = isBlocking ? 'Block Provider' : 'Unblock Provider';
    final action = isBlocking ? 'Block' : 'Unblock';

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
                Icon(icon, color: color),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Text(
              'Provider:',
              style: TextStyle(color: const Color(0xff64748B), fontSize: 12.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              provider.name,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff111827),
              ),
            ),
            Text(
              provider.service,
              style: TextStyle(color: const Color(0xff64748B), fontSize: 12.sp),
            ),

            SizedBox(height: 20.h),

            if (isBlocking) ...[
              Text(
                'Reason for Blocking *',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff111827),
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Explain why you are blocking this provider...',
                  hintStyle: TextStyle(
                    color: const Color(0xff94A3B8),
                    fontSize: 13.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xffF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'This reason will be stored for record keeping and may be shared with the provider.',
                style: TextStyle(fontSize: 11.sp, color: const Color(0xff64748B)),
              ),
              SizedBox(height: 20.h),
            ] else ...[
              Text(
                'This provider will be able to access the app again.',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xff64748B)),
              ),
              SizedBox(height: 20.h),
            ],

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF1F5F9),
                        foregroundColor: const Color(0xff334155),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                      ),
                      child: Text(action),
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
