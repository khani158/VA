import 'dart:convert';

class RecentNumber {
  final String number;
  final DateTime timestamp;

  RecentNumber({
    required this.number,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory RecentNumber.fromMap(Map<String, dynamic> map) {
    return RecentNumber(
      number: map['number'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecentNumber.fromJson(String source) => RecentNumber.fromMap(json.decode(source));
}
