class CalendarItem {
  final String text;
  final String value;
  final bool isCompleted;
  final double progress;

  CalendarItem({
    this.text = '',
    this.value = '',
    this.isCompleted = false,
    this.progress = 0.0,
  });

  factory CalendarItem.fromJson(Map<String, dynamic> json) {
    return CalendarItem(
      text: json['text'] ?? '',
      value: json['value'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
      'isCompleted': isCompleted,
      'progress': progress,
    };
  }
}

