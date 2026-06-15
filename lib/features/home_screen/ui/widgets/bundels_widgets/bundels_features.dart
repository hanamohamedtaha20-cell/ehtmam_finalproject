import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BundleFeatures extends StatelessWidget {
  final List<String> features;

  const BundleFeatures({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features.map(
            (feature) => Padding(
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(feature),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
}