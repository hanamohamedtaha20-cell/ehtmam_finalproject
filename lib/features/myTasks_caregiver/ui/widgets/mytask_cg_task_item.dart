import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/mytask_cg_task_model.dart';
import '../../manager/mytask_cg_cubit.dart';

class MytaskCgTaskItem extends StatelessWidget {
  final MytaskCgTaskModel task;
  final String bookingId;
  final VoidCallback onAddProof;

  const MytaskCgTaskItem({
    super.key,
    required this.task,
    required this.bookingId,
    required this.onAddProof,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(64, 0, 0, 0),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (task.mediaProof.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add a photo/video proof first'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                context.read<MytaskCgCubit>().toggleTaskDone(bookingId, task.id);
              },
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isDone ? const Color(0xFF1976D2) : Colors.grey,
                    width: 2,
                  ),
                  color: task.isDone ? const Color(0xFF1976D2) : Colors.transparent,
                ),
                child: task.isDone
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  color: task.isDone ? Colors.grey : Colors.black,
                ),
              ),
            ),
           if (task.isAddedByCaregiver)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () => context.read<MytaskCgCubit>().deleteTask(bookingId, task.id),
            )
          else
            const SizedBox(width: 48),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 14, color: Colors.black87),
                  const SizedBox(width: 4),
                  Text(task.assignedTo, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(width: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(task.category, style: TextStyle(fontSize: 11, color: Colors.blue.shade700)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.black87),
                  const SizedBox(width: 4),
                  Text(task.date, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
              if (task.mediaProof.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_file, size: 13, color: Colors.black),
                    Text(
                      ' Attached Media (${task.mediaProof.length})',
                      style: const TextStyle(fontSize: 12, color: Colors.black, ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: task.mediaProof.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final path = task.mediaProof[i];
                      final isVideo = path.endsWith('.mp4') ||
                          path.endsWith('.mov') ||
                          path.endsWith('.avi');
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isVideo
                            ? Container(
                                width: 70,
                                height: 70,
                                color: Colors.black87,
                                child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
                              )
                            : Image.file(
                                File(path),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onAddProof,
                icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.blue,size: 16),
                label: const Text('Add Photo/Video Proof', style: TextStyle(fontSize: 12 , color: Colors.blue),),
                style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: BorderSide(color: Colors.grey),
                foregroundColor: Colors.grey.shade700,
              ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View Booking Details →',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1976D2))),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    ));
  }
}