import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletHeader extends StatelessWidget {
  final double balance; 

  const WalletHeader({super.key, required this.balance}); // 👈 عدلي ده

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 👈 مهم
      children: [
        /// 🔹 ICON BOX
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 25.r,
            ),
          ),
        ),

        SizedBox(width: 10.w),

       
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Balance",
              style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 14.sp,
                color: Colors.white70,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              balance.toStringAsFixed(2),
              style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 34.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}