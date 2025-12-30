class SwingFix {
  final String id;
  final String title;
  final String videoId;

  SwingFix({
    required this.id,
    required this.title,
    required this.videoId,
  });

  factory SwingFix.fromJson(Map<String, dynamic> json) {
    return SwingFix(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      videoId: json['videoId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'videoId': videoId,
    };
  }
}


