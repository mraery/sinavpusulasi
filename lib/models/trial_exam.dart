import 'dart:convert';

class TrialSection {
  final String name;
  final int totalQuestions;
  final int correct;
  final int wrong;
  final double penaltyRate; // 0.25 for 4 wrong = 1 net loss, 0.333 for 3 wrong = 1 net loss

  TrialSection({
    required this.name,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    this.penaltyRate = 0.25,
  });

  int get blank {
    final b = totalQuestions - (correct + wrong);
    return b < 0 ? 0 : b;
  }

  double get net {
    final rawNet = correct - (wrong * penaltyRate);
    return rawNet < 0 ? 0.0 : double.parse(rawNet.toStringAsFixed(2));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalQuestions': totalQuestions,
      'correct': correct,
      'wrong': wrong,
      'penaltyRate': penaltyRate,
    };
  }

  factory TrialSection.fromMap(Map<String, dynamic> map) {
    return TrialSection(
      name: map['name'] as String,
      totalQuestions: map['totalQuestions'] as int? ?? 0,
      correct: map['correct'] as int? ?? 0,
      wrong: map['wrong'] as int? ?? 0,
      penaltyRate: (map['penaltyRate'] as num?)?.toDouble() ?? 0.25,
    );
  }
}

class TrialExam {
  final String id;
  final String title;
  final String examType; // TYT, AYT_SAY, AYT_EA, LGS, KPSS, GENEL
  final DateTime date;
  final String publisher;
  final List<TrialSection> sections;
  final String note;

  TrialExam({
    required this.id,
    required this.title,
    required this.examType,
    required this.date,
    required this.publisher,
    required this.sections,
    this.note = '',
  });

  int get totalQuestions => sections.fold(0, (sum, s) => sum + s.totalQuestions);
  int get totalCorrect => sections.fold(0, (sum, s) => sum + s.correct);
  int get totalWrong => sections.fold(0, (sum, s) => sum + s.wrong);
  int get totalBlank => sections.fold(0, (sum, s) => sum + s.blank);
  double get totalNet {
    final n = sections.fold(0.0, (sum, s) => sum + s.net);
    return double.parse(n.toStringAsFixed(2));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'examType': examType,
      'date': date.toIso8601String(),
      'publisher': publisher,
      'sections': sections.map((s) => s.toMap()).toList(),
      'note': note,
    };
  }

  factory TrialExam.fromMap(Map<String, dynamic> map) {
    return TrialExam(
      id: map['id'] as String,
      title: map['title'] as String,
      examType: map['examType'] as String? ?? 'TYT',
      date: DateTime.parse(map['date'] as String),
      publisher: map['publisher'] as String? ?? '',
      sections: (map['sections'] as List<dynamic>?)
              ?.map((e) => TrialSection.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      note: map['note'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory TrialExam.fromJson(String source) =>
      TrialExam.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<TrialSection> createDefaultSections(String examType) {
    switch (examType) {
      case 'TYT':
        return [
          TrialSection(name: 'Türkçe', totalQuestions: 40, correct: 0, wrong: 0),
          TrialSection(name: 'Sosyal Bilimler', totalQuestions: 20, correct: 0, wrong: 0),
          TrialSection(name: 'Temel Matematik', totalQuestions: 40, correct: 0, wrong: 0),
          TrialSection(name: 'Fen Bilimleri', totalQuestions: 20, correct: 0, wrong: 0),
        ];
      case 'AYT_SAY':
        return [
          TrialSection(name: 'Matematik', totalQuestions: 40, correct: 0, wrong: 0),
          TrialSection(name: 'Fizik', totalQuestions: 14, correct: 0, wrong: 0),
          TrialSection(name: 'Kimya', totalQuestions: 13, correct: 0, wrong: 0),
          TrialSection(name: 'Biyoloji', totalQuestions: 13, correct: 0, wrong: 0),
        ];
      case 'AYT_EA':
        return [
          TrialSection(name: 'Matematik', totalQuestions: 40, correct: 0, wrong: 0),
          TrialSection(name: 'Türk Dili ve Edebiyatı', totalQuestions: 24, correct: 0, wrong: 0),
          TrialSection(name: 'Tarih-1', totalQuestions: 10, correct: 0, wrong: 0),
          TrialSection(name: 'Coğrafya-1', totalQuestions: 6, correct: 0, wrong: 0),
        ];
      case 'LGS':
        return [
          TrialSection(name: 'Türkçe', totalQuestions: 20, correct: 0, wrong: 0, penaltyRate: 0.333),
          TrialSection(name: 'Matematik', totalQuestions: 20, correct: 0, wrong: 0, penaltyRate: 0.333),
          TrialSection(name: 'Fen Bilimleri', totalQuestions: 20, correct: 0, wrong: 0, penaltyRate: 0.333),
          TrialSection(name: 'T.C. İnkılap', totalQuestions: 10, correct: 0, wrong: 0, penaltyRate: 0.333),
          TrialSection(name: 'Din Kültürü', totalQuestions: 10, correct: 0, wrong: 0, penaltyRate: 0.333),
          TrialSection(name: 'İngilizce', totalQuestions: 10, correct: 0, wrong: 0, penaltyRate: 0.333),
        ];
      case 'KPSS':
        return [
          TrialSection(name: 'Genel Yetenek (Türkçe-Mat)', totalQuestions: 60, correct: 0, wrong: 0),
          TrialSection(name: 'Genel Kültür (Tarih-Coğ-Vat)', totalQuestions: 60, correct: 0, wrong: 0),
        ];
      default:
        return [
          TrialSection(name: 'Bölüm 1', totalQuestions: 50, correct: 0, wrong: 0),
          TrialSection(name: 'Bölüm 2', totalQuestions: 50, correct: 0, wrong: 0),
        ];
    }
  }
}
