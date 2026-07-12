import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class PendingApprovalCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  final VoidCallback onViewDocuments;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const PendingApprovalCard({
    super.key,
    required this.provider,
    required this.onViewDocuments,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final status = (provider['status'] ?? '').toString();
    final statusLower = status.toLowerCase();

    final isPending  = statusLower.contains('pending');
    final isRejected = statusLower == 'rejected';
    final isApproved = statusLower == 'approved';

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 14.r,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58.w,
                height: 58.h,
                decoration: BoxDecoration(
                  color: const Color(0xff97CCFD),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: 32.r,
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider['name'],
                      style: TextStyle(
                        color: Color(0xff111827),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.15.h,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      provider['type'],
                      style: TextStyle(
                        color: Color(0xff2F93E6),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusTag(
                text: status,
                isPending: isPending,
                isRejected: isRejected,
                isApproved: isApproved,
              ),
            ],
          ),

          SizedBox(height: 18.h),

          _InfoText(
            title: 'Email',
            value: provider['email'],
          ),

          SizedBox(height: 12.h),

          _InfoText(
            title: 'Phone Number',
            value: provider['phone'],
          ),

          SizedBox(height: 18.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: const Color(0xffF8FAFC),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('documents_required'.tr(),
                  style: TextStyle(
                    color: Color(0xff111827),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (provider['documents'] as List)
                      .map(
                        (doc) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffEEF6FF),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 13.r,
                            color: Color(0xff2F93E6),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            doc,
                            style: TextStyle(
                              color: Color(0xff2F93E6),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff2F93E6),
                    Color(0xff74BDF8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ElevatedButton.icon(
                onPressed: onViewDocuments,
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  size: 18.r,
                  color: Colors.white,
                ),
                label: Text('view_documents'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),

          if (isPending) ...[
            SizedBox(height: 12.h),

        
          ],
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String text;
  final bool isPending;
  final bool isRejected;
  final bool isApproved;

  const _StatusTag({
    required this.text,
    required this.isPending,
    required this.isRejected,
    required this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color color;

    final lower = text.toLowerCase();
    if (lower.contains('pending')) {
      bg = const Color(0xffFEF3C7);
      color = const Color(0xffD97706);
    } else if (lower == 'rejected') {
      bg = const Color(0xffFEE2E2);
      color = Colors.red;
    } else {
      bg = const Color(0xffDCFCE7);
      color = const Color(0xff059669);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String title;
  final String value;

  const _InfoText({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff64748B),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: Color(0xff111827),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}