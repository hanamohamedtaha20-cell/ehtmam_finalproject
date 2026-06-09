import 'package:flutter/cupertino.dart';

import 'faq_item.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FAQItem(
          title: "Can I use bundle sessions for different services?",
          answer: "Yes...",
        ),
        FAQItem(
          title: "What happens if I don't use all sessions?",
          answer: "Unused sessions remain valid...",
        ),
      ],
    );
  }
}