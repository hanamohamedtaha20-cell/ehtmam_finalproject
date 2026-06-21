import 'package:ehtemam_final_project/core/widgets/full_screen_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _CaregiverAvatar extends StatelessWidget {
  final String pictureUrl;
  final double radius;

  const _CaregiverAvatar({required this.pictureUrl, required this.radius});

  bool get _hasUrl =>
      pictureUrl.isNotEmpty &&
      pictureUrl != 'null' &&
      (pictureUrl.startsWith('http://') || pictureUrl.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    if (!_hasUrl) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFE3F2FD),
        child: Icon(Icons.person, color: const Color(0xFF3A8BD7), size: radius),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE3F2FD),
      child: ClipOval(
        child: Image.network(
          pictureUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, e) => Icon(
            Icons.person,
            color: const Color(0xFF3A8BD7),
            size: radius,
          ),
        ),
      ),
    );
  }
}

class CaregiverHeader extends StatelessWidget {
  final String name;
  final String speciality;
  final String rating;
  final String reviewCount;
  final String caregiverPicture;

  const CaregiverHeader({
    super.key,
    required this.name,
    required this.speciality,
    required this.rating,
    required this.reviewCount,
    this.caregiverPicture = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: caregiverPicture.isNotEmpty &&
                  caregiverPicture != 'null' &&
                  (caregiverPicture.startsWith('http://') ||
                      caregiverPicture.startsWith('https://'))
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImagePage(imageUrl: caregiverPicture),
                    ),
                  )
              : null,
          child: _CaregiverAvatar(pictureUrl: caregiverPicture, radius: 28),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.black)),
              Text(speciality,
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12.sp,
                      color: Colors.black45)),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14.r),
                  SizedBox(width: 4.w),
                  Text(
                    reviewCount == '0'
                        ? 'No ratings yet (0 reviews)'
                        : '$rating ($reviewCount reviews)',
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 12.sp,
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}