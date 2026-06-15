import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/bundle_model.dart';

class BundleCard extends StatelessWidget {
  final BundleModel bundle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BundleCard({
    super.key,
    required this.bundle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  bundle.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1E293B),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${bundle.price}',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1E293B),
                    ),
                  ),
                  Text(
                    '0 sold',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xff94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              _Info(
                value: '${bundle.sessions}',
                title: 'sessions',
              ),

              SizedBox(width: 24.w),

              _Info(
                value: bundle.validity,
                title: 'days',
              ),

              SizedBox(width: 24.w),

              _Info(
                value: '${bundle.discount}%',
                title: 'off',
                green: true,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16.r,
                  ),
                  label: Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff2F93E6),
                    side: BorderSide(
                      color: Color(0xffB8D8F7),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 16.r,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String value;
  final String title;
  final bool green;

  const _Info({
    required this.value,
    required this.title,
    this.green = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: green
                ? const Color(0xff16A34A)
                : const Color(0xff334155),
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Color(0xff64748B),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}