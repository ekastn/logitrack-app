class DeliveryTask {
  final int id;
  final String title;
  final bool isCompleted;

  const DeliveryTask({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory DeliveryTask.fromJson(Map<String, dynamic> json) {
    return DeliveryTask(
      id: json['id'],
      title: json['title'],
      isCompleted: json['completed'],
    );
  }
}
