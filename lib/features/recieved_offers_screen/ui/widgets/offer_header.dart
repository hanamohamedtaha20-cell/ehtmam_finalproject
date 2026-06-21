import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class OffersHeader extends StatelessWidget {
  const OffersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(16.r),
      child: Row(
        children:  [
          IconButton(
              onPressed:(){
                Navigator.pop(context);
              },
              icon:Icon(Icons.arrow_back)
          ),
          SizedBox(width: 10.w),
          Text('received_offers'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}