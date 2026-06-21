import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/cg_payment_model.dart';
import '../../manager/cg_payment_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class TransactionDetailsSheet extends StatefulWidget {
  final CgTransactionModel transaction;

  const TransactionDetailsSheet({super.key, required this.transaction});

  @override
  State<TransactionDetailsSheet> createState() =>
      _TransactionDetailsSheetState();
}

class _TransactionDetailsSheetState extends State<TransactionDetailsSheet> {
  bool _loading = true;
  Map<String, dynamic>? _details;

  static const _blue = Color(0xFF3A8BD7);
  static const _lightBlue = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final result = await context
        .read<CgPaymentCubit>()
        .fetchTransactionDetails(widget.transaction.id);
    if (mounted) {
      setState(() {
        _details = result;
        _loading = false;
      });
    }
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  String _resolve(String key, String fallback) {
    if (_details == null) return fallback;
    final raw = _details![key]?.toString().trim() ?? '';
    if (raw.isNotEmpty) return raw;

    // check inside nested 'data' object
    final data = _details!['data'];
    if (data is Map) {
      final v = data[key]?.toString().trim() ?? '';
      if (v.isNotEmpty) return v;
    }
    return fallback;
  }

  double _resolveNum(String key, double fallback) {
    if (_details == null) return fallback;
    final v = _details![key];
    if (v != null) return (v as num).toDouble();
    final data = _details!['data'];
    if (data is Map && data[key] != null) return (data[key] as num).toDouble();
    return fallback;
  }

  String get _serviceName =>
      _resolve('serviceName', widget.transaction.serviceType).isNotEmpty
          ? _resolve('serviceName', widget.transaction.serviceType)
          : (widget.transaction.serviceType.isNotEmpty
              ? widget.transaction.serviceType
              : 'N/A');

  String get _clientName =>
      _resolveClientName().isNotEmpty ? _resolveClientName() : 'N/A';

  String _resolveClientName() {
    if (_details != null) {
      final c = _details!['client'];
      if (c is Map) return c['full_name']?.toString() ?? '';
      final data = _details!['data'];
      if (data is Map) {
        final c2 = data['client'];
        if (c2 is Map) return c2['full_name']?.toString() ?? '';
      }
    }
    return widget.transaction.clientName;
  }

  String get _date =>
      _resolve('createdAt', '').isNotEmpty
          ? _formatDate(_resolve('createdAt', ''))
          : widget.transaction.date.isNotEmpty
              ? widget.transaction.date
              : 'N/A';

  double get _gross =>
      _resolveNum('grossAmount',
          widget.transaction.grossAmount > 0
              ? widget.transaction.grossAmount
              : widget.transaction.amount);

  double get _fee => _gross * 0.105;

  double get _net => _gross - _fee;

  String get _txId {
    final v = _resolve('transactionId', _resolve('_id', widget.transaction.id));
    return v.isNotEmpty ? v : widget.transaction.id;
  }

  String get _status {
    final v = _resolve('status', widget.transaction.status);
    return v.isNotEmpty ? v : 'N/A';
  }

  static String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  Color get _statusColor {
    switch (_status.toUpperCase()) {
      case 'COMPLETED':
        return const Color.fromARGB(255, 18, 120, 204);
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // title
          Text('transaction_details'.tr(),
            style: TextStyle(
              fontFamily: 'Arimo',
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          if (_loading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: const CircularProgressIndicator(color: _blue),
            )
          else ...[
            _infoSection(),
            SizedBox(height: 14.h),
            _breakdownSection(),
            SizedBox(height: 14.h),
            _footerRow(),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                ),
                child: Text('close'.tr(),
                  style:
                      TextStyle(fontFamily: 'Arimo', fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoSection() {
    return Container(
      decoration: BoxDecoration(
        color: _lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        children: [
          _infoRow('Service', _serviceName),
          _divider(),
          _infoRow('Client', _clientName),
          _divider(),
          _infoRow('Date', _date),
        ],
      ),
    );
  }

  Widget _breakdownSection() {
    debugPrint('GROSS_AMOUNT: $_gross');
    debugPrint('PLATFORM_FEE: $_fee');
    debugPrint('NET_EARNINGS: $_net');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('payment_breakdown'.tr(),
          style: TextStyle(
            fontFamily: 'Arimo',
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(30, 0, 0, 0),
                blurRadius: 6.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Column(
            children: [
              _amountRow('Gross Amount', _gross, color: Colors.black87),
              _divider(),
              _amountRow('Platform Fee', _fee, color: Colors.red.shade400),
              _divider(),
              _amountRow('Net Earnings', _net, color: _blue, bold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('transaction_id'.tr(),
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _txId.length > 12 ? _txId.substring(0, 12) : _txId,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: _statusColor, size: 13.r),
              SizedBox(width: 4.w),
              Text(
                _status[0].toUpperCase() +
                    _status.substring(1).toLowerCase(),
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 12.sp,
                  color: _statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 12.sp,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, double value,
      {Color color = Colors.black87, bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 13.sp,
              color: Colors.black87,
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} EGP',
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 13.sp,
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade200);
}
