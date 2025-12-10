enum StorageItemType {
  video,
  image,
  text,
  unknown,
}

class PostModel {
  final String? id;
  final DateTime? date;
  final bool? isFromCoach;
  final String? text;
  final List<String> storagePaths;
  final String? attachmentPath;
  final StorageItemType type;
  final String? filePath;
  final String? videoUrl;

  PostModel({
    this.id,
    this.date,
    this.isFromCoach,
    this.text,
    this.storagePaths = const [],
    this.attachmentPath,
    this.type = StorageItemType.unknown,
    this.filePath,
    this.videoUrl,
  });

  String get formattedTime {
    if (date == null) return '';
    return '${date!.day}.${date!.month}.${date!.year} ${date!.hour}:${date!.minute}:${date!.second}';
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      isFromCoach: json['isFromCoach'],
      text: json['text'],
      storagePaths: json['storagePaths'] != null ? List<String>.from(json['storagePaths']) : [],
      attachmentPath: json['attachmentPath'],
      type: _getStorageType(json['type']),
      filePath: json['filePath'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'isFromCoach': isFromCoach,
      'text': text,
      'storagePaths': storagePaths,
      'attachmentPath': attachmentPath,
      'type': type.toString(),
      'filePath': filePath,
      'videoUrl': videoUrl,
    };
  }

  static StorageItemType _getStorageType(dynamic type) {
    if (type == null) return StorageItemType.unknown;
    final typeStr = type.toString().toLowerCase();
    if (typeStr.contains('video')) return StorageItemType.video;
    if (typeStr.contains('image')) return StorageItemType.image;
    if (typeStr.contains('text')) return StorageItemType.text;
    return StorageItemType.unknown;
  }
}

