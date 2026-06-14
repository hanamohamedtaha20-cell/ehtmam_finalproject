import 'package:flutter/material.dart';

class BundleDialog extends StatefulWidget {
  final String title;
  final String actionText;

  final TextEditingController bundleNameController;
  final TextEditingController sessionsController;
  final TextEditingController validityController;
  final TextEditingController priceController;
  final TextEditingController discountController;

  final List<String> features;
  final Function(List<String>) onFeaturesChanged;

  final VoidCallback onSubmit;

  const BundleDialog({
    super.key,
    required this.title,
    required this.actionText,
    required this.bundleNameController,
    required this.sessionsController,
    required this.validityController,
    required this.priceController,
    required this.discountController,
    required this.features,
    required this.onFeaturesChanged,
    required this.onSubmit,
  });

  @override
  State<BundleDialog> createState() => _BundleDialogState();
}

class _BundleDialogState extends State<BundleDialog> {
  final TextEditingController featureController = TextEditingController();
  late List<String> features;

  @override
  void initState() {
    super.initState();
    features = List<String>.from(widget.features);
  }

  @override
  void dispose() {
    featureController.dispose();
    super.dispose();
  }

  void addFeature() {
    final text = featureController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      features.add(text);
      featureController.clear();
    });

    widget.onFeaturesChanged(features);
  }

  void removeFeature(int index) {
    setState(() {
      features.removeAt(index);
    });

    widget.onFeaturesChanged(features);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 34),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xff2F93E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                children: [
                  _field(
                    controller: widget.bundleNameController,
                    label: 'Bundle Name *',
                    hint: 'e.g., Premium Bundle',
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          controller: widget.sessionsController,
                          label: 'Sessions *',
                          hint: '10',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _field(
                          controller: widget.validityController,
                          label: 'Validity (days) *',
                          hint: '60',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          controller: widget.priceController,
                          label: 'Price (\$) *',
                          hint: '249',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _field(
                          controller: widget.discountController,
                          label: 'Discount (%) *',
                          hint: '30',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Bundle Features *',
                          style: const TextStyle(
                            color: Color(0xff334155),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: '(${features.length} added)',
                              style: const TextStyle(
                                color: Color(0xff94A3B8),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: TextField(
                                controller: featureController,
                                style: const TextStyle(fontSize: 11),
                                decoration: InputDecoration(
                                  hintText: 'e.g., Priority support',
                                  hintStyle: const TextStyle(
                                    color: Color(0xff94A3B8),
                                    fontSize: 10,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xffE2E8F0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xff2F93E6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            height: 36,
                            child: ElevatedButton.icon(
                              onPressed: addFeature,
                              icon: const Icon(Icons.add, size: 13),
                              label: const Text(
                                'Add',
                                style: TextStyle(fontSize: 11),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2F93E6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      if (features.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'No features added yet. Type a feature and press Add.',
                            style: TextStyle(
                              color: Color(0xff94A3B8),
                              fontSize: 9,
                            ),
                          ),
                        )
                      else
                        Column(
                          children: List.generate(
                            features.length,
                                (index) => Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              height: 32,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: const Color(0xffE2E8F0),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x07000000),
                                    blurRadius: 7,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_border_rounded,
                                    size: 13,
                                    color: Color(0xff2F93E6),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      features[index],
                                      style: const TextStyle(
                                        color: Color(0xff334155),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => removeFeature(index),
                                    child: const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: Color(0xff94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF1F5F9),
                              foregroundColor: const Color(0xff334155),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: widget.onSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2F93E6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              widget.actionText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff334155),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 36,
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xff94A3B8),
                fontSize: 10,
              ),
              filled: true,
              fillColor: const Color(0xffF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xffE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xff2F93E6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}