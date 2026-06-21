import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

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
      insetPadding: EdgeInsets.symmetric(horizontal: 34.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 17.r,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                children: [
                  _field(
                    controller: widget.bundleNameController,
                    label: 'Bundle Name *',
                    hint: 'e.g., Premium Bundle',
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          controller: widget.sessionsController,
                          label: 'Sessions *',
                          hint: '10',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _field(
                          controller: widget.validityController,
                          label: 'Validity (days) *',
                          hint: '60',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          controller: widget.priceController,
                          label: 'Price (\$) *',
                          hint: '249',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _field(
                          controller: widget.discountController,
                          label: 'Discount (%) *',
                          hint: '30',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Bundle Features *',
                          style: TextStyle(
                            color: Color(0xff334155),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: '(${features.length} added)',
                              style: TextStyle(
                                color: Color(0xff94A3B8),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 36.h,
                              child: TextField(
                                controller: featureController,
                                style: TextStyle(fontSize: 11.sp),
                                decoration: InputDecoration(
                                  hintText: 'eg_priority_support'.tr(),
                                  hintStyle: TextStyle(
                                    color: Color(0xff94A3B8),
                                    fontSize: 10.sp,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF8FAFC),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 8.h,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      color: Color(0xffE2E8F0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      color: Color(0xff2F93E6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          SizedBox(
                            height: 36.h,
                            child: ElevatedButton.icon(
                              onPressed: addFeature,
                              icon: Icon(Icons.add, size: 13.r),
                              label: Text('add'.tr(),
                                style: TextStyle(fontSize: 11.sp),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2F93E6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                EdgeInsets.symmetric(horizontal: 10.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      if (features.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 11.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF8FAFC),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text('no_features_added'.tr(),
                            style: TextStyle(
                              color: Color(0xff94A3B8),
                              fontSize: 9.sp,
                            ),
                          ),
                        )
                      else
                        Column(
                          children: List.generate(
                            features.length,
                                (index) => Container(
                              margin: EdgeInsets.only(bottom: 6.h),
                              height: 32.h,
                              padding:
                              EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9.r),
                                border: Border.all(
                                  color: const Color(0xffE2E8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x07000000),
                                    blurRadius: 7.r,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_border_rounded,
                                    size: 13.r,
                                    color: Color(0xff2F93E6),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      features[index],
                                      style: TextStyle(
                                        color: Color(0xff334155),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => removeFeature(index),
                                    child: Icon(
                                      Icons.close,
                                      size: 12.r,
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

                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF1F5F9),
                              foregroundColor: const Color(0xff334155),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text('cancel'.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: ElevatedButton(
                            onPressed: widget.onSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2F93E6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              widget.actionText,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
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
          style: TextStyle(
            color: Color(0xff334155),
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          height: 36.h,
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: 11.sp),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Color(0xff94A3B8),
                fontSize: 10.sp,
              ),
              filled: true,
              fillColor: const Color(0xffF8FAFC),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: Color(0xffE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
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