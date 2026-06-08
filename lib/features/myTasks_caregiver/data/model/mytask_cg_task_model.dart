class MytaskCgTaskModel {
  final String id;
  final String title;
  final String assignedTo;
  final String category;
  final String date;
  final List<String> mediaProof;
  final bool isDone;
  final bool isAddedByCaregiver;


  MytaskCgTaskModel({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.category,
    required this.date,
    this.mediaProof = const [],
    this.isDone = false,
    this.isAddedByCaregiver = false,

  });

  MytaskCgTaskModel copyWith({
    String? id,
    String? title,
    String? assignedTo,
    String? category,
    String? date,
    List<String>? mediaProof,
    bool? isDone,
    bool? isAddedByCaregiver,

  }) {
    return MytaskCgTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      assignedTo: assignedTo ?? this.assignedTo,
      category: category ?? this.category,
      date: date ?? this.date,
      mediaProof: mediaProof ?? this.mediaProof,
      isDone: isDone ?? this.isDone,
      isAddedByCaregiver: isAddedByCaregiver ?? this.isAddedByCaregiver,

    );
  }
}