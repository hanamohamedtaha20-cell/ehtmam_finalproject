import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/ad_provider_model.dart';
import 'block_provider_dialog.dart';

class AdProviderCard extends StatelessWidget {
  final AdProviderModel provider;
  final VoidCallback onBlockConfirmed;

  const AdProviderCard({
    super.key,
    required this.provider,
    required this.onBlockConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final initials = provider.name.trim().isNotEmpty
        ? provider.name.trim().substring(0, 1).toUpperCase()
        : 'P';

    final bool isApproved =
        provider.status.toLowerCase() == 'approved';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xff2F93E6),
                backgroundImage:
                provider.profilePicture.isNotEmpty
                    ? NetworkImage(
                  provider.profilePicture,
                )
                    : null,
                child: provider.profilePicture.isEmpty
                    ? Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )
                    : null,
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: TextStyle(
                        color: Color(0xff111827),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      provider.email,
                      style: TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 11.sp,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      provider.service,
                      style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xffF59E0B),
                          size: 14.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${provider.rating.toStringAsFixed(1)} (${provider.reviews} reviews)',
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    Container(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: isApproved
                            ? const Color(
                          0xffDCFCE7,
                        )
                            : const Color(
                          0xffFEF3C7,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        provider.status,
                        style: TextStyle(
                          color: isApproved
                              ? const Color(
                            0xff16A34A,
                          )
                              : const Color(
                            0xffD97706,
                          ),
                          fontSize: 10.sp,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.more_vert,
                color: Color(0xff94A3B8),
                size: 18.r,
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Divider(
            color: Color(0xffE5E7EB),
            height: 1.h,
          ),

          SizedBox(height: 10.h),

          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                barrierColor:
                Colors.black.withOpacity(
                  0.35,
                ),
                builder: (_) =>
                    BlockProviderDialog(
                      provider: provider,
                      onBlock: onBlockConfirmed,
                    ),
              );
            },
            icon: Icon(
              Icons.block,
              color: Colors.red,
              size: 16.r,
            ),
            label: Text(
              'Block Provider',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}