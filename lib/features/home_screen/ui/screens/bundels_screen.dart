// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../widgets/bundels_widgets/bundels_card.dart';
// import '../widgets/bundels_widgets/bundels_header.dart';
// import '../widgets/bundels_widgets/faq_section.dart';
// import '../widgets/bundels_widgets/why_choose_card.dart';
//
// class ServiceBundlesScreen extends StatelessWidget {
//   const ServiceBundlesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//
//
//               WhyChooseUsCard(),
//               SizedBox(height: 16),
//
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: bundles.length,
//                 itemBuilder: (_, index) =>
//                     BundleCard(bundle: bundles[index]),
//               ),
//
//               SizedBox(height: 16),
//
//               FAQSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }