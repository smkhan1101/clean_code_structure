import 'exercise.dart';

class DayProtocol {
  final String id;
  final int durationDays;
  final String? baselineVideoId;
  final List<Exercise> exercises;

  DayProtocol({
    required this.id,
    required this.exercises,
    this.durationDays = 0,
    this.baselineVideoId,
  });

  factory DayProtocol.fromJson(Map<String, dynamic> json) {
    final exercisesList = json['exercises'] as List<dynamic>? ?? [];
    return DayProtocol(
      id: json['id'] ?? '',
      durationDays: json['durationDays'] ?? 0,
      baselineVideoId: json['baselineVideoId'],
      exercises: exercisesList
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'durationDays': durationDays,
      'baselineVideoId': baselineVideoId,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

