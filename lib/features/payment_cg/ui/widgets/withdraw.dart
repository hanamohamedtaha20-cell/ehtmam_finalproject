import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

const _kRefNumber = 'FWY-258963147';

class Withdraw extends StatelessWidget {
  const Withdraw({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => _WithdrawDialog(scaffoldContext: context),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Text(
              "- Withdraw Funds",
              style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A8BD7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WithdrawDialog extends StatelessWidget {
  final BuildContext scaffoldContext;

  const _WithdrawDialog({required this.scaffoldContext});

  void _copyRef(BuildContext dialogContext) {
    Clipboard.setData(const ClipboardData(text: _kRefNumber));
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 16.r),
            SizedBox(width: 8.w),
            Expanded(
              child: Text('reference_copied'.tr(),
                style: TextStyle(fontFamily: 'Arimo', fontSize: 13.sp),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3A8BD7),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Success icon ─────────────────────────────────────────────
            Container(
              width: 72.r,
              height: 72.r,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: const Color(0xFF3A8BD7),
                size: 44.r,
              ),
            ),
            SizedBox(height: 18.h),

            // ── Title ─────────────────────────────────────────────────────
            Text('withdrawal_created'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),

            // ── Subtitle ──────────────────────────────────────────────────
            Text('withdrawal_success'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                height: 1.45,
              ),
            ),
            SizedBox(height: 20.h),

            // ── Reference number box ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFF3A8BD7).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('reference_number'.tr(),
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          _kRefNumber,
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: const Color(0xFF3A8BD7),
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _copyRef(context),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.all(6.r),
                      child: Icon(
                        Icons.copy_rounded,
                        color: const Color(0xFF3A8BD7),
                        size: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // ── Fawry note ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange.shade700,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Please visit any Fawry outlet and provide this reference number to receive your payment.',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 12.sp,
                        color: Colors.orange.shade800,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // ── Done button ───────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A8BD7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text('done'.tr(),
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),

            // ── Copy reference number text button ─────────────────────────
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _copyRef(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3A8BD7),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text('copy_reference'.tr(),
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
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
