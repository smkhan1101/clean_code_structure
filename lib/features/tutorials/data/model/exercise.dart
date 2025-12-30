class Exercise {
  final String id;
  final String title;
  final String videoId;

  Exercise({
    required this.id,
    required this.title,
    required this.videoId,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
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


