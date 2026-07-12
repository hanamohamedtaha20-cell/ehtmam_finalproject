import 'package:ehtemam_final_project/core/widgets/full_screen_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/ad_provider_cubit.dart';
import '../../model/ad_provider_model.dart';
import 'block_provider_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class AdProviderCard extends StatelessWidget {
  final AdProviderModel provider;

  const AdProviderCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final displayName = provider.name.trim();
    final initials    = displayName.isNotEmpty
        ? displayName.substring(0, displayName.length.clamp(0, 2)).toUpperCase()
        : 'P';

    final statusLower = provider.status.toLowerCase();
    final isVerified  = statusLower == 'approved' || statusLower == 'verified';
    final isBlocked   = provider.isBlocked;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x12000000),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              GestureDetector(
                onTap: provider.profilePicture.isNotEmpty
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImagePage(imageUrl: provider.profilePicture),
                          ),
                        )
                    : null,
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: const Color(0xff2F93E6),
                  backgroundImage: provider.profilePicture.isNotEmpty
                      ? NetworkImage(provider.profilePicture)
                      : null,
                  child: provider.profilePicture.isEmpty
                      ? Text(
                          initials,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
              ),

              SizedBox(width: 12.w),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: TextStyle(
                        color: const Color(0xff111827),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      provider.email,
                      style: TextStyle(
                        color: const Color(0xff6B7280),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      provider.service,
                      style: TextStyle(
                        color: const Color(0xff6B7280),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Bookings count
                    Row(
                      children: [
                        Icon(Icons.bookmark_outline_rounded, color: const Color(0xff2F93E6), size: 14.r),
                        SizedBox(width: 3.w),
                        Text(
                          '${provider.reviews} bookings',
                          style: TextStyle(
                            color: const Color(0xff64748B),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Verified / status badge
                    Row(
                      children: [
                        Icon(
                          isVerified ? Icons.verified_outlined : Icons.schedule_outlined,
                          size: 13.r,
                          color: isVerified ? const Color(0xff16A34A) : const Color(0xffD97706),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isVerified ? 'Verified' : provider.status,
                          style: TextStyle(
                            color: isVerified ? const Color(0xff16A34A) : const Color(0xffD97706),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(Icons.more_vert, color: const Color(0xff94A3B8), size: 18.r),
            ],
          ),

          SizedBox(height: 12.h),
          Divider(color: const Color(0xffE5E7EB), height: 1.h),
          SizedBox(height: 6.h),

          // Block / Unblock button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () async {
                final isBlocking = !isBlocked;
                final confirmed = await showDialog<bool>(
                  context: context,
                  barrierColor: Colors.black.withValues(alpha: 0.35),
                  builder: (_) => BlockProviderDialog(
                    provider: provider,
                    isBlocking: isBlocking,
                  ),
                );
                if (confirmed != true || !context.mounted) return;

                final error = await context
                    .read<AdProviderCubit>()
                    .toggleBlockProvider(provider);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error == null
                          ? (isBlocking
                              ? 'provider_blocked_success'.tr()
                              : 'provider_unblocked_success'.tr())
                          : 'Failed: $error',
                    ),
                    backgroundColor: error == null ? Colors.green : Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(
                isBlocked ? Icons.lock_open_rounded : Icons.block,
                size: 15.r,
                color: isBlocked ? Colors.orange : Colors.red,
              ),
              label: Text(
                isBlocked ? 'unblock_provider'.tr() : 'block_provider'.tr(),
                style: TextStyle(
                  color: isBlocked ? Colors.orange : Colors.red,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
