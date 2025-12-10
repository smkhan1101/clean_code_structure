class RewardModel {
  final String name;
  final String title;
  final String rule;
  final String image;
  final bool isAvailable;

  RewardModel({
    required this.name,
    required this.title,
    required this.rule,
    required this.image,
    this.isAvailable = false,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      rule: json['rule'] ?? '',
      image: json['image'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'rule': rule,
      'image': image,
      'isAvailable': isAvailable,
    };
  }
}

