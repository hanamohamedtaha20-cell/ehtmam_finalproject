import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/mytask_cg_task_model.dart';
import 'package:image_picker/image_picker.dart';

class MytaskCgAddTaskSheet extends StatefulWidget {
  final String bookingId;
  final Function(MytaskCgTaskModel) onAdd;

  const MytaskCgAddTaskSheet({
    super.key,
    required this.bookingId,
    required this.onAdd,
  });

  @override
  State<MytaskCgAddTaskSheet> createState() => _MytaskCgAddTaskSheetState();
}

class _MytaskCgAddTaskSheetState extends State<MytaskCgAddTaskSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  List<String> _mediaPaths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  Future<void> _pickMedia() async {
    final List<XFile> files = await _picker.pickMultipleMedia();
    if (files.isEmpty) return;
    setState(() {
      _mediaPaths = [..._mediaPaths, ...files.map((f) => f.path)];
    });
  }
  void _submit() {
  if (_nameController.text.isEmpty) return;
  final task = MytaskCgTaskModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: _nameController.text,
    assignedTo: 'Me',
    category: 'General',
    date: DateTime.now().toString().substring(0, 10),
    isAddedByCaregiver: true,
    mediaProof: _mediaPaths, 
  );
  widget.onAdd(task);
  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w, right: 20.w, top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add New Task', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          SizedBox(height: 16.h),
          Text('Task Name', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 16.h),
          Text('Photo of Receipt/Result', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          OutlinedButton.icon(
            onPressed: _pickMedia,
            icon: Icon(Icons.add_photo_alternate_outlined),
            label: Text(
              _mediaPaths.isEmpty
                  ? 'Add Photo/Video Proof'
                  : '${_mediaPaths.length} file(s) added ✓',
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: BorderSide(
                color: _mediaPaths.isEmpty ? Colors.grey.shade300 : const Color(0xFF1976D2),
              ),
              foregroundColor: _mediaPaths.isEmpty ? Colors.grey.shade700 : const Color(0xFF1976D2),
            ),
          ),
          SizedBox(height: 16.h),
          Text('Price', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter price',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text('Add Task', style: TextStyle(fontSize: 16.sp)),
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}