import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class MytaskCgAddTaskSheet extends StatefulWidget {
  final String bookingId;
  /// Called with (title, description, price). Returns null on success, error string on failure.
  final Future<String?> Function(String title, String description, double price) onAdd;

  const MytaskCgAddTaskSheet({
    super.key,
    required this.bookingId,
    required this.onAdd,
  });

  @override
  State<MytaskCgAddTaskSheet> createState() => _MytaskCgAddTaskSheetState();
}

class _MytaskCgAddTaskSheetState extends State<MytaskCgAddTaskSheet> {
  final _titleController       = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController       = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final desc  = _descriptionController.text.trim();
    final priceText = _priceController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a task title.');
      return;
    }
    if (priceText.isEmpty) {
      _showError('Please enter a price.');
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null || price < 0) {
      _showError('Please enter a valid price.');
      return;
    }

    setState(() => _isLoading = true);
    final error = await widget.onAdd(title, desc, price);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      _showError(error);
    } else {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF7EC4F0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('add_extra_task'.tr(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _isLoading ? null : () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('task_sent_for_approval'.tr(),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text('title_label'.tr(), style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'eg_task_title'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 14),
          Text('description'.tr(), style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _descriptionController,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'eg_task_desc'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 14),
          Text('price_egp'.tr(), style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'eg_price'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              prefixText: 'EGP  ',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text('send_for_approval'.tr(), style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              child: Text('cancel'.tr(), style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
