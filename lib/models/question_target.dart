import 'dart:convert';

class DailyQuestionLog {
  final String id;
  final String dateString; // YYYY-MM-DD
  final String subject; // Türkçe, Matematik, Fizik, Kimya, vb.
  final int count;
  final DateTime timestamp;

  DailyQuestionLog({
    required this.id,
    required this.dateString,
    required this.subject,
    required this.count,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateString': dateString,
      'subject': subject,
      'count': count,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DailyQuestionLog.fromMap(Map<String, dynamic> map) {
    return DailyQuestionLog(
      id: map['id'] as String,
      dateString: map['dateString'] as String,
      subject: map['subject'] as String,
      count: map['count'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJson() => json.encode(toMap());
  factory DailyQuestionLog.fromJson(String source) =>
      DailyQuestionLog.fromMap(json.decode(source) as Map<String, dynamic>);
}
