import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'client_header.dart';
import 'client_status.dart';
import 'start_sharing_button.dart';

class ClientInfoCard extends StatelessWidget {
  final String name;
  final String serviceType;
  final String status;
  final String statusSubtitle;
  final bool isSharing;
  final VoidCallback onShareToggle;

  const ClientInfoCard({
    super.key,
    required this.name,
    required this.serviceType,
    required this.status,
    required this.statusSubtitle,
    required this.isSharing,
    required this.onShareToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(55, 0, 0, 0), blurRadius: 6.r, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientHeader(name: name, serviceType: serviceType),
          SizedBox(height: 12.h),
          Divider(),
          SizedBox(height: 8.h),
          Container(
            margin: EdgeInsets.only(left: 8.w, right: 8.w),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(12.r),
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Distance', style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: Colors.grey)),
                    Text('2.3 km', style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.black)),
                  ],
                ),
                Column(
                  children: [
                    Text('Est. Time', style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: Colors.grey)),
                    Text('15 min', style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          StartSharingButton(isSharing: isSharing, onTap: onShareToggle),
        ],
      ),
    );
  }
}