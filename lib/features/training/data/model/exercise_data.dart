class ExerciseData {
  final String exerciseName;
  final String heading;
  final String videoId;
  final String dominantStr;
  final String weightStr;
  final bool dominant;
  final bool isStart;
  final int weight;
  final int time;
  final bool isBaseline;
  final bool allowDriver;
  final bool requiresInput;

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
    this.isBaseline = false,
    this.allowDriver = false,
    this.requiresInput = false,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      exerciseName: json['exerciseName'] ?? '',
      heading: json['heading'] ?? '',
      videoId: json['videoId'] ?? '',
      dominantStr: json['dominantStr'] ?? '',
      weightStr: json['weightStr'] ?? '',
      dominant: json['dominant'] ?? false,
      isStart: json['isStart'] ?? false,
      weight: json['weight'] ?? 0,
      time: json['time'] ?? 0,
      isBaseline: json['isBaseline'] ?? false,
      allowDriver: json['allowDriver'] ?? false,
      requiresInput: json['requiresInput'] ?? false,
    );
  }

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
      'isBaseline': isBaseline,
      'allowDriver': allowDriver,
      'requiresInput': requiresInput,
    };
  }
}

