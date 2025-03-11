class CarbonInput {
  final String category;
  final DateTime date;
  final Map<String, dynamic> data;

  CarbonInput({
    required this.category,
    required this.date,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'date': date.toIso8601String(),
      'data': data,
    };
  }

  factory CarbonInput.fromJson(Map<String, dynamic> json) {
    return CarbonInput(
      category: json['category'],
      date: DateTime.parse(json['date']),
      data: json['data'],
    );
  }
} 