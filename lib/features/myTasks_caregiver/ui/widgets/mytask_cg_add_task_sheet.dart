import 'package:flutter/material.dart';
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
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add New Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Task Name', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Photo of Receipt/Result', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickMedia,
            icon: const Icon(Icons.add_photo_alternate_outlined),
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
          const SizedBox(height: 16),
          const Text('Price', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter price',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add Task', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}