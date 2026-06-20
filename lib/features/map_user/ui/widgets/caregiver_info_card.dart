import 'package:ehtemam_final_project/features/map_user/ui/widgets/caregiver_header.dart';
import 'package:ehtemam_final_project/features/map_user/ui/widgets/caregiver_status.dart';
import 'package:ehtemam_final_project/features/map_user/ui/widgets/contact_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'contact_dialog.dart';

class CaregiverInfoCard extends StatelessWidget {
  final String name;
  final String speciality;
  final String rating;
  final String reviewCount;
  final String status;
  final String statusSubtitle;
  final String phoneNumber;
  final String caregiverPicture;

  const CaregiverInfoCard({
    super.key,
    required this.name,
    required this.speciality,
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.statusSubtitle,
    required this.phoneNumber,
    this.caregiverPicture = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(55, 0, 0, 0),
            blurRadius: 6.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CaregiverHeader(
            name: name,
            speciality: speciality,
            rating: rating,
            reviewCount: reviewCount,
            caregiverPicture: caregiverPicture,
          ),
          SizedBox(height: 12.h),
          Divider(),
          SizedBox(height: 8.h),
          
          ContactButton(
            name: name,
            speciality: speciality,
            phoneNumber: phoneNumber,
          ),
        ],
      ),
    );
  }
}