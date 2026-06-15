import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingDocumentsDialog extends StatelessWidget {
  const PendingDocumentsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const PendingDocumentsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.86,
        ),
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'View Documents -\nFatma Hassan',
                      style: TextStyle(
                        color: Color(0xff111827),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 22.r,
                      color: Color(0xff475569),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              const _SectionTitle(title: 'Profile Picture'),
              SizedBox(height: 10.h),
              const _DocumentCard(
                icon: Icons.person_outline_rounded,
                fileName: 'profile-provider-sample.jpg',
                isProfile: true,
              ),

              SizedBox(height: 22.h),

              const _SectionTitle(title: 'National ID'),
              SizedBox(height: 10.h),
              const _DocumentCard(
                icon: Icons.description_outlined,
                fileName: 'national-id-fatma.pdf',
              ),

              SizedBox(height: 22.h),

              const _SectionTitle(title: 'Certificates'),
              SizedBox(height: 10.h),
              const _DocumentCard(
                icon: Icons.description_outlined,
                fileName: 'medical-certificate-fatma.pdf',
              ),

              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check_circle_outline),
                  label: Text('Approve'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff059669),
                    side: BorderSide(color: Color(0xff059669)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.cancel_outlined),
                  label: Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Color(0xff111827),
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final IconData icon;
  final String fileName;
  final bool isProfile;

  const _DocumentCard({
    required this.icon,
    required this.fileName,
    this.isProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 112.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: isProfile
                  ? const Color(0xffB9DBFA)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: isProfile ? 52 : 48,
              color: isProfile
                  ? const Color(0xff2F93E6)
                  : const Color(0xff8CA0BC),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            fileName,
            style: TextStyle(
              color: Color(0xff64748B),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}