import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../manager/pending_approvals/pending_approvals_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

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
          content: Text('caregiver_approved'.tr()),
          backgroundColor: const Color(0xff22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed_to_approve'.tr()),
          backgroundColor: const Color(0xffEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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
          content: Text('caregiver_rejected'.tr()),
          backgroundColor: const Color(0xffF59E0B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed_to_reject'.tr()),
          backgroundColor: const Color(0xffEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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
                        Text('back'.tr(),
                          style: TextStyle(
                            color: const Color(0xff64748B),
                            fontSize: 12.sp,
                          ),
                        ),
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

                      Text('profile_picture'.tr(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      if (profilePicture != null && profilePicture.isNotEmpty)
                        _imageCard(url: profilePicture, fallbackIcon: Icons.person_outline)
                      else
                        _emptyCard(icon: Icons.person_outline, text: 'No profile picture uploaded'),

                      SizedBox(height: 24.h),

                      Text('national_id'.tr(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      if (nationalId != null && nationalId.isNotEmpty)
                        _imageCard(url: nationalId, fallbackIcon: Icons.description_outlined)
                      else
                        _emptyCard(icon: Icons.description_outlined, text: 'No national ID uploaded'),

                      SizedBox(height: 24.h),

                      Text('certificates'.tr(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      if (certifications.isNotEmpty)
                        ...certifications.map((doc) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _imageCard(url: doc.toString(), fallbackIcon: Icons.workspace_premium_outlined),
                        ))
                      else
                        _emptyCard(icon: Icons.workspace_premium_outlined, text: 'No certificates uploaded'),

                      SizedBox(height: 24.h),

                      Text('mental_health_doc'.tr(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      if (_mentalHealthDocuments.isNotEmpty)
                        ..._mentalHealthDocuments.map(
                          (doc) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _documentItem(
                              url: doc,
                              fallbackIcon: Icons.psychology_outlined,
                            ),
                          ),
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.psychology_outlined,
                          text: 'No mental health document uploaded',
                        ),

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

            Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xffF1F5F9), width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleApprove,
                      icon: _isApproving
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xff22C55E),
                              ),
                            )
                          : Icon(
                              Icons.check_circle_outline,
                              color: const Color(0xff22C55E),
                              size: 20.r,
                            ),
                      label: Text('approve'.tr(),
                        style: TextStyle(
                          color: const Color(0xff22C55E),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xff22C55E),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        disabledForegroundColor:
                            const Color(0xff22C55E).withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextButton.icon(
                    onPressed: _isLoading ? null : _handleReject,
                    icon: _isRejecting
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xffEF4444),
                            ),
                          )
                        : Icon(
                            Icons.cancel_outlined,
                            color: const Color(0xffEF4444),
                            size: 18.r,
                          ),
                    label: Text('reject'.tr(),
                      style: TextStyle(
                        color: const Color(0xffEF4444),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xffEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Routes to _pdfCard or _imageCard based on the URL extension.
  Widget _documentItem({required String url, required IconData fallbackIcon}) {
    final lower = url.toLowerCase();
    final isPdf = lower.endsWith('.pdf') || lower.contains('.pdf?');
    if (isPdf) return _pdfCard(url: url, fallbackIcon: fallbackIcon);
    return _imageCard(url: url, fallbackIcon: fallbackIcon);
  }

  Widget _pdfCard({required String url, required IconData fallbackIcon}) {
    final filename = Uri.tryParse(url)?.pathSegments.lastOrNull ?? 'document.pdf';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf_outlined, size: 40.r, color: const Color(0xffEF4444)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              filename,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xff475569)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          OutlinedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('pdf_copied'.tr())),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff3B82F6),
              side: const BorderSide(color: Color(0xff3B82F6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('open'.tr(), style: TextStyle(fontSize: 12.sp)),
          ),
        ],
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
