import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingDocumentsScreen extends StatelessWidget {
  final Map<String, dynamic> provider;

  const PendingDocumentsScreen({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final String name = provider['name'] ?? 'Provider';

    final String? profilePicture = provider['profile_picture'];

    final List certifications = provider['certifications'] ?? [];

    final List verificationDocuments =
        provider['verifcation_documents'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16.r,
                          color: Color(0xff64748B),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F5F9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 14.r,
                          color: Color(0xff64748B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'العربية',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Color(0xff64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'View Documents -\n$name',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      Text(
                        'Profile Picture',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      if (profilePicture != null &&
                          profilePicture.toString().isNotEmpty)
                        _imageCard(
                          url: profilePicture,
                          fallbackIcon: Icons.person_outline,
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.person_outline,
                          text: 'No profile picture uploaded',
                        ),

                      SizedBox(height: 24.h),

                      Text(
                        'National ID',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      if (verificationDocuments.isNotEmpty)
                        ...verificationDocuments.map(
                              (doc) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _imageCard(
                              url: doc.toString(),
                              fallbackIcon: Icons.description_outlined,
                            ),
                          ),
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.description_outlined,
                          text: 'No national ID uploaded',
                        ),

                      SizedBox(height: 24.h),

                      Text(
                        'Certificates',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      if (certifications.isNotEmpty)
                        ...certifications.map(
                              (doc) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _imageCard(
                              url: doc.toString(),
                              fallbackIcon: Icons.workspace_premium_outlined,
                            ),
                          ),
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.workspace_premium_outlined,
                          text: 'No certificates uploaded',
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageCard({
    required String url,
    required IconData fallbackIcon,
  }) {
    return Container(
      height: 220.h,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _emptyDocumentCard(
            icon: fallbackIcon,
            text: 'Cannot load document',
          );
        },
      ),
    );
  }

  Widget _emptyDocumentCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 56.r,
            color: const Color(0xff94A3B8),
          ),
          SizedBox(height: 12.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(0xff64748B),
            ),
          ),
        ],
      ),
    );
  }
}