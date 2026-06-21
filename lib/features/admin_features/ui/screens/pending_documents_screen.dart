import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingDocumentsScreen extends StatefulWidget {
  final Map<String, dynamic> provider;
  final Future<bool> Function()? onApprove;
  final Future<bool> Function()? onReject;

  const PendingDocumentsScreen({
    super.key,
    required this.provider,
    this.onApprove,
    this.onReject,
  });

  @override
  State<PendingDocumentsScreen> createState() => _PendingDocumentsScreenState();
}

class _PendingDocumentsScreenState extends State<PendingDocumentsScreen> {
  bool _loading = false;

  Future<void> _handleApprove() async {
    if (widget.onApprove == null) return;
    setState(() => _loading = true);
    final ok = await widget.onApprove!();
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.provider['name']} has been approved'),
          backgroundColor: const Color(0xff059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);  // true = approved → switch to providers tab
    }
  }

  Future<void> _handleReject() async {
    if (widget.onReject == null) return;
    setState(() => _loading = true);
    final ok = await widget.onReject!();
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.provider['name']} has been rejected'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, false);  // false = rejected → stay on approvals
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name             = widget.provider['name'] ?? 'Provider';
    final String? profilePicture  = widget.provider['profile_picture'];
    final List certifications     = widget.provider['certifications'] ?? [];
    final List mhdList            = widget.provider['mental_health_document'] ?? [];
    final String? nationalId      = widget.provider['national_id'];

    final statusLower = (widget.provider['status'] ?? '').toString().toLowerCase();
    final isPending   = statusLower.contains('pending');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
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
                        Icon(Icons.arrow_back_ios, size: 16.r, color: const Color(0xff64748B)),
                        SizedBox(width: 2.w),
                        Text('Back', style: TextStyle(color: const Color(0xff64748B), fontSize: 12.sp)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: isPending
                          ? const Color(0xffFEF3C7)
                          : const Color(0xffDCFCE7),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      widget.provider['status'] ?? '',
                      style: TextStyle(
                        color: isPending
                            ? const Color(0xffD97706)
                            : const Color(0xff059669),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Documents ─────────────────────────────────────────────────
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
                              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Profile Picture
                      Text('Profile Picture', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 12.h),
                      if (profilePicture != null && profilePicture.isNotEmpty)
                        _imageCard(url: profilePicture, fallbackIcon: Icons.person_outline)
                      else
                        _emptyCard(icon: Icons.person_outline, text: 'No profile picture uploaded'),

                      SizedBox(height: 24.h),

                      // National ID
                      Text('National ID', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 12.h),
                      if (nationalId != null && nationalId.isNotEmpty)
                        _imageCard(url: nationalId, fallbackIcon: Icons.description_outlined)
                      else
                        _emptyCard(icon: Icons.description_outlined, text: 'No national ID uploaded'),

                      SizedBox(height: 24.h),

                      // Certificates
                      Text('Certificates', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 12.h),
                      if (certifications.isNotEmpty)
                        ...certifications.map((doc) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _imageCard(url: doc.toString(), fallbackIcon: Icons.workspace_premium_outlined),
                        ))
                      else
                        _emptyCard(icon: Icons.workspace_premium_outlined, text: 'No certificates uploaded'),

                      if (mhdList.isNotEmpty) ...[
                        SizedBox(height: 24.h),
                        Text('Mental Health Document', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 12.h),
                        ...mhdList.map((doc) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _imageCard(url: doc.toString(), fallbackIcon: Icons.health_and_safety_outlined),
                        )),
                      ],

                      SizedBox(height: 32.h),

                      // ── Approve / Reject ──────────────────────────────────
                      if (isPending) ...[
                        if (_loading)
                          const Center(child: CircularProgressIndicator())
                        else ...[
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton.icon(
                              onPressed: _handleApprove,
                              icon: Icon(Icons.check_circle_outline, size: 20.r),
                              label: Text(
                                'Approve',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff059669),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: OutlinedButton.icon(
                              onPressed: _handleReject,
                              icon: Icon(Icons.cancel_outlined, size: 20.r),
                              label: Text(
                                'Reject',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16.h),
                      ],
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

  Widget _imageCard({required String url, required IconData fallbackIcon}) {
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
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            _emptyCard(icon: fallbackIcon, text: 'Cannot load document'),
      ),
    );
  }

  Widget _emptyCard({required IconData icon, required String text}) {
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
          Icon(icon, size: 56.r, color: const Color(0xff94A3B8)),
          SizedBox(height: 12.h),
          Text(text, style: TextStyle(fontSize: 12.sp, color: const Color(0xff64748B))),
        ],
      ),
    );
  }
}
