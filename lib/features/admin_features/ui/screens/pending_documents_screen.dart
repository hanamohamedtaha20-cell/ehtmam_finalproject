import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../manager/pending_approvals/pending_approvals_cubit.dart';

class PendingDocumentsScreen extends StatefulWidget {
  final Map<String, dynamic> provider;
  final PendingApprovalsCubit cubit;

  const PendingDocumentsScreen({
    super.key,
    required this.provider,
    required this.cubit,
  });

  @override
  State<PendingDocumentsScreen> createState() => _PendingDocumentsScreenState();
}

class _PendingDocumentsScreenState extends State<PendingDocumentsScreen> {
  bool _isApproving = false;
  bool _isRejecting = false;

  bool get _isLoading => _isApproving || _isRejecting;

  @override
  void initState() {
    super.initState();
    debugPrint('[DocScreen] provider keys: ${widget.provider.keys.toList()}');
    debugPrint('[DocScreen] national_id value: ${widget.provider['national_id']}');
    debugPrint('[DocScreen] mental_health_document value: ${widget.provider['mental_health_document']}');
  }

  String get _caregiverId => widget.provider['id'] ?? '';
  String get _caregiverName => widget.provider['name'] ?? 'Provider';
  String? get _profilePicture => widget.provider['profile_picture']?.toString();

  // national_id â€” String URL (single document)
  String? get _nationalId => widget.provider['national_id']?.toString();

  // certifications â€” List<String>
  List<String> get _certifications {
    final raw = widget.provider['certifications'];
    if (raw is List) return List<String>.from(raw.map((e) => e.toString()));
    return [];
  }

  // mental_health_document â€” List<String> (may have multiple files)
  List<String> get _mentalHealthDocuments {
    final raw = widget.provider['mental_health_document'];
    if (raw is List) return List<String>.from(raw.map((e) => e.toString()));
    if (raw is String && raw.isNotEmpty) return [raw];
    return [];
  }

  Future<void> _handleApprove() async {
    setState(() => _isApproving = true);
    final success = await widget.cubit.approveProvider(_caregiverId);
    if (!mounted) return;
    setState(() => _isApproving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Caregiver approved successfully'),
          backgroundColor: const Color(0xff22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to approve. Please try again.'),
          backgroundColor: const Color(0xffEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
    }
  }

  Future<void> _handleReject() async {
    setState(() => _isRejecting = true);
    final success = await widget.cubit.rejectProvider(_caregiverId);
    if (!mounted) return;
    setState(() => _isRejecting = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Caregiver application rejected successfully.'),
          backgroundColor: const Color(0xffF59E0B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to reject. Please try again.'),
          backgroundColor: const Color(0xffEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          color: const Color(0xff64748B),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: const Color(0xff64748B),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
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
                          color: const Color(0xff64748B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xff64748B),
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
                padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
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
                              'View Documents -\n$_caregiverName',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      Text(
                        'Profile Picture',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      if (_profilePicture != null &&
                          _profilePicture!.isNotEmpty)
                        _imageCard(
                          url: _profilePicture!,
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
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      if (_nationalId != null && _nationalId!.isNotEmpty)
                        _documentItem(
                          url: _nationalId!,
                          fallbackIcon: Icons.badge_outlined,
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.badge_outlined,
                          text: 'No national ID uploaded',
                        ),

                      SizedBox(height: 24.h),

                      Text(
                        'Certificates',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      if (_certifications.isNotEmpty)
                        ..._certifications.map(
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

                      SizedBox(height: 24.h),

                      Text(
                        'Mental Health Document',
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
                      label: Text(
                        'Approve',
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
                    label: Text(
                      'Reject',
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
                const SnackBar(content: Text('PDF link copied to clipboard')),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff3B82F6),
              side: const BorderSide(color: Color(0xff3B82F6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Open', style: TextStyle(fontSize: 12.sp)),
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
        errorBuilder: (context, error, stackTrace) {
          return _emptyDocumentCard(
            icon: fallbackIcon,
            text: 'Cannot load document',
          );
        },
      ),
    );
  }

  Widget _emptyDocumentCard({required IconData icon, required String text}) {
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
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xff64748B),
            ),
          ),
        ],
      ),
    );
  }
}
