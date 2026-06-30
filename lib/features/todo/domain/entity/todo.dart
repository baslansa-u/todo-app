import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        createdAt,
        dueDate,
      ];

  // Used for toggle complete status and editing task
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    Object? dueDate = _sentinel,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate == _sentinel ? this.dueDate : dueDate as DateTime?,
    );
  }

  // ใช้แยกระหว่าง "ส่ง null มาตั้งใจล้างค่า" กับ "ไม่ได้ส่งค่ามาเลย"
  // จำเป็นแค่ตอน copyWith เพราะ Dart แยก 2 กรณีนี้ไม่ได้ด้วย DateTime? ปกติ
  // ตัวอย่าง: todo.copyWith(dueDate: null) = ตั้งใจล้างค่า
  static const _sentinel = Object();
}
