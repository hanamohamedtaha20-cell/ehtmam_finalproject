import 'package:ehtemam_final_project/features/admin_features/data/bundle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/bundles/bundles_cubit.dart';
import '../../manager/bundles/bundles_state.dart';
import '../widgets/bundle_card.dart';
import '../widgets/bundle_dialog.dart';

class BundlesScreen extends StatelessWidget {
  const BundlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BundlesCubit()..getBundles(),
      child: const BundlesView(),
    );
  }
}

class BundlesView extends StatelessWidget {
  const BundlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 72.h),
        child: FloatingActionButton(
          backgroundColor: const Color(0xff2F93E6),
          elevation: 6,
          onPressed: () {

            _showCreateBundleDialog(context);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30.r,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 86.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18.r,
                      color: Color(0xff334155),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage\nBundles',
                          style: TextStyle(
                            color: Color(0xff1E293B),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.05.h,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Create and manage\nservice packages',
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 11.sp,
                            height: 1.2.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xff334155)),
                      tooltip: 'Refresh',
                      onPressed: () => ctx.read<BundlesCubit>().getBundles(),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<BundlesCubit, BundlesState>(
                builder: (context, state) {
                  if (state.status == BundlesStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.bundles.isEmpty) {
                    return Center(
                      child: Text(
                        'No bundles found',
                        style: TextStyle(
                          color: Color(0xff64748B),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(18, 18, 18, 130),
                    itemCount: state.bundles.length,
                    itemBuilder: (context, index) {
                      final bundle = state.bundles[index];

                      return BundleCard(
                        bundle: bundle,
                        onEdit: () {
                          _showEditBundleDialog(context, bundle);
                        },
                        onDelete: () {
                          context
                              .read<BundlesCubit>()
                              .deleteBundle(bundle.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showCreateBundleDialog(BuildContext context) {
    final nameController = TextEditingController();
    final sessionsController = TextEditingController();
    final validityController = TextEditingController();
    final priceController = TextEditingController();
    final discountController = TextEditingController();

    List<String> features = [];

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) {
        return BundleDialog(
          title: 'Create New Bundle',
          actionText: 'Create',
          bundleNameController: nameController,
          sessionsController: sessionsController,
          validityController: validityController,
          priceController: priceController,
          discountController: discountController,
          features: features,
          onFeaturesChanged: (newFeatures) {
            features = newFeatures;
          },
          onSubmit: () {
            context.read<BundlesCubit>().createBundle(
              name: nameController.text,
              sessions: sessionsController.text,
              days: validityController.text,
              price: priceController.text,
              discount: discountController.text,
              features: features,
            );

            Navigator.pop(context);
          },
        );
      },
    );
  }
  void _showEditBundleDialog(
      BuildContext context,
      BundleModel bundle,
      ) {
    final nameController = TextEditingController(
      text: bundle.name,
    );

    final sessionsController = TextEditingController(
      text: bundle.sessions.toString(),
    );

    final validityController = TextEditingController(
      text: bundle.validity,
    );

    final priceController = TextEditingController(
      text: bundle.price.toString(),
    );

    final discountController = TextEditingController(
      text: bundle.discount.toString(),
    );

    List<String> features = List<String>.from(
      bundle.features,
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) {
        return BundleDialog(
          title: 'Edit Bundle',
          actionText: 'Update',
          bundleNameController: nameController,
          sessionsController: sessionsController,
          validityController: validityController,
          priceController: priceController,
          discountController: discountController,
          features: features,
          onFeaturesChanged: (newFeatures) {
            features = newFeatures;
          },
          onSubmit: () {
            context.read<BundlesCubit>().updateBundle(
              id: bundle.id,
              name: nameController.text,
              sessions: sessionsController.text,
              days: validityController.text,
              price: priceController.text,
              discount: discountController.text,
              features: features,
            );

            Navigator.pop(context);
          },
        );
      },
    );
  }
}
