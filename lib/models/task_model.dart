/// Task model class that represents a task object in Back4App
class Task {
  String? id;
  String title;
  String description;
  bool isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert Task to JSON for sending to Back4App
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  /// Create Task from JSON (received from Back4App)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['objectId'] ?? json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  @override
  String toString() =>
      'Task(id: $id, title: $title, description: $description)';
}
