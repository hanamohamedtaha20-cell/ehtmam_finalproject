// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/resources/app_text_style.dart';

// class LanguageChip extends StatelessWidget {
//   const LanguageChip({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.85),
//         borderRadius: BorderRadius.circular(24.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 8.r,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.language,
//             size: 16.r,
//             color: Color(0xFF5C6B82),
//           ),
//           SizedBox(width: 6.w),
//           Text(
//             'العربية',
//             style: AppTextStyle.medium.copyWith(
//               fontSize: 13.sp,
//               color: const Color(0xFF5C6B82),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }