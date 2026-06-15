import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientHeader extends StatelessWidget {
  final String name;
  final String serviceType;

  const ClientHeader({
    super.key,
    required this.name,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.person, color: Color(0xFF3A8BD7), size: 30.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black)),
              Text(serviceType, style: TextStyle(fontFamily: "Arimo", fontSize: 14.sp, color: Colors.black87)),
              Text('Waiting for your arrival', style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: Colors.black87)),

            ],
          ),
        ),
      ],
    );
  }
}