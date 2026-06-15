import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HcRequestCard extends StatelessWidget {
  final CareRequestModel request;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const HcRequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onDecline,
  });

  String get _subtitle {
    if (request.duration.isNotEmpty) {
      return request.duration;
    }
    return request.serviceName;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Container(
      margin: EdgeInsets.fromLTRB(16 * s, 0, 16 * s, 14 * s),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.serviceName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0B2B5A),
                  ),
                ),
              ),
              Text(
                request.price,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF3A8BD7),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            _subtitle,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              color: const Color(0xFF667085),
            ),
          ),
          if (request.clientName.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              'Requested by: ${request.clientName}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                color: const Color(0xFF98A2B3),
              ),
            ),
          ],
          SizedBox(height: 12.h),
          if (request.date.isNotEmpty)
            _InfoRow(
              scale: s,
              icon: Icons.calendar_today_outlined,
              text: 'Start: ${request.date}',
            ),
          if (request.location.isNotEmpty)
            _InfoRow(
              scale: s,
              icon: Icons.location_on_outlined,
              text: request.location,
            ),
          if (request.notes.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Special Requirements: ${request.notes}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  color: const Color(0xFF3A8BD7),
                  height: 1.4.h,
                ),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _AcceptButton(
                  scale: s,
                  onTap: onAccept,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _DeclineButton(
                  scale: s,
                  onTap: onDecline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final double scale;
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.scale,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h * scale),
      child: Row(
        children: [
          Icon(icon, size: 16.r * scale, color: const Color(0xFF98A2B3)),
          SizedBox(width: 8.w * scale),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp * scale,
                color: const Color(0xFF667085),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  final double scale;
  final VoidCallback? onTap;

  const _AcceptButton({
    required this.scale,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r * scale),
        child: Ink(
          height: 44.h * scale,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A8BD7), Color(0xFF6CB4F5)],
            ),
            borderRadius: BorderRadius.circular(14.r * scale),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_rounded, color: Colors.white, size: 18.r * scale),
              SizedBox(width: 6.w * scale),
              Text(
                'Accept',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp * scale,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeclineButton extends StatelessWidget {
  final double scale;
  final VoidCallback? onTap;

  const _DeclineButton({
    required this.scale,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r * scale),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r * scale),
        child: Container(
          height: 44.h * scale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r * scale),
            border: Border.all(color: const Color(0xFFD0D5DD)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close_rounded, color: const Color(0xFF667085), size: 18.r * scale),
              SizedBox(width: 6.w * scale),
              Text(
                'Decline',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp * scale,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
