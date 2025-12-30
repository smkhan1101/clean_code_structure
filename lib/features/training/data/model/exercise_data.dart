class ExerciseData {
  String exerciseName;
  final String heading;
  String videoId;
  final String dominantStr;
  final String weightStr;
  bool dominant;
  final bool isStart;
  int weight;
  int time;
  int count;
  int? durationSeconds;
  final bool isBaseline;
  bool allowDriver;
  bool requiresInput;

  ExerciseData({
    this.exerciseName = '',
    this.heading = '',
    this.videoId = '',
    this.dominantStr = '',
    this.weightStr = '',
    this.dominant = false,
    this.isStart = false,
    this.weight = 0,
    this.time = 0,
    this.count = 5,
    this.durationSeconds,
    this.isBaseline = false,
    this.allowDriver = false,
    this.requiresInput = false,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      exerciseName: json['title'] ?? json['exerciseName'] ?? '',
      heading: json['heading'] ?? json['title'] ?? '',
      videoId: json['videoId'] ?? '',
      dominantStr: json['dominantStr'] ?? '',
      weightStr: json['weightStr'] ?? '',
      dominant: json['dominant'] ?? false,
      isStart: json['isStart'] ?? false,
      weight: json['weight'] ?? 0,
      time: json['time'] ?? 0,
      count: json['count'] ?? 5,
      durationSeconds: json['durationSeconds'] as int?,
      isBaseline: json['isBaseline'] ?? false,
      allowDriver: json['allowDriver'] ?? false,
      requiresInput: json['requiresInput'] ?? false,
    );
  }

  String get title => exerciseName.isNotEmpty ? exerciseName : heading;

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'heading': heading,
      'videoId': videoId,
      'dominantStr': dominantStr,
      'weightStr': weightStr,
      'dominant': dominant,
      'isStart': isStart,
      'weight': weight,
      'time': time,
      'count': count,
      'durationSeconds': durationSeconds,
      'isBaseline': isBaseline,
      'allowDriver': allowDriver,
      'requiresInput': requiresInput,
    };
  }
}

