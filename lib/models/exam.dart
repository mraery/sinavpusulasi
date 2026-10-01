import 'dart:convert';

class ExamItem {
  final String id;
  final String title;
  final String subtitle;
  final DateTime examDate;
  final String category; // YKS, KPSS, LGS, ALES, DGS, OZEL
  final bool isPreset;

  ExamItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.examDate,
    required this.category,
    this.isPreset = false,
  });

  Duration get remainingDuration {
    final now = DateTime.now();
    if (examDate.isBefore(now)) {
      return Duration.zero;
    }
    return examDate.difference(now);
  }

  bool get isPassed => DateTime.now().isAfter(examDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'examDate': examDate.toIso8601String(),
      'category': category,
      'isPreset': isPreset,
    };
  }

  factory ExamItem.fromMap(Map<String, dynamic> map) {
    return ExamItem(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String? ?? '',
      examDate: DateTime.parse(map['examDate'] as String),
      category: map['category'] as String? ?? 'OZEL',
      isPreset: map['isPreset'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  factory ExamItem.fromJson(String source) =>
      ExamItem.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<ExamItem> get defaultPresetExams {
    // Current base year 2025/2026 dates
    final now = DateTime.now();
    int year = now.year;
    // If mid-year passed, use appropriate exam cycle
    return [
      ExamItem(
        id: 'yks_tyt',
        title: 'YKS - TYT',
        subtitle: 'Temel Yeterlilik Testi (165 dk)',
        examDate: DateTime(year, 6, 21, 10, 15),
        category: 'YKS',
        isPreset: true,
      ),
      ExamItem(
        id: 'yks_ayt',
        title: 'YKS - AYT',
        subtitle: 'Alan Yeterlilik Testleri (180 dk)',
        examDate: DateTime(year, 6, 22, 10, 15),
        category: 'YKS',
        isPreset: true,
      ),
      ExamItem(
        id: 'yks_ydt',
        title: 'YKS - YDT',
        subtitle: 'Yabancı Dil Testi (120 dk)',
        examDate: DateTime(year, 6, 22, 15, 45),
        category: 'YKS',
        isPreset: true,
      ),
      ExamItem(
        id: 'lgs',
        title: 'LGS',
        subtitle: 'Liselere Geçiş Sistemi Sınavı',
        examDate: DateTime(year, 6, 15, 9, 30),
        category: 'LGS',
        isPreset: true,
      ),
      ExamItem(
        id: 'kpss_lisans',
        title: 'KPSS Lisans',
        subtitle: 'Genel Yetenek - Genel Kültür (130 dk)',
        examDate: DateTime(year, 9, 7, 10, 15),
        category: 'KPSS',
        isPreset: true,
      ),
      ExamItem(
        id: 'kpss_oabt',
        title: 'KPSS ÖABT',
        subtitle: 'Öğretmenlik Alan Bilgisi Testi',
        examDate: DateTime(year, 9, 21, 10, 15),
        category: 'KPSS',
        isPreset: true,
      ),
      ExamItem(
        id: 'msu',
        title: 'MSÜ',
        subtitle: 'Milli Savunma Üniversitesi Askeri Öğrenci Sınavı',
        examDate: DateTime(year, 3, 23, 10, 15),
        category: 'MSÜ',
        isPreset: true,
      ),
      ExamItem(
        id: 'ales_1',
        title: 'ALES / 1',
        subtitle: 'Akademik Personel ve Lisansüstü Eğitimi',
        examDate: DateTime(year, 4, 13, 10, 15),
        category: 'ALES',
        isPreset: true,
      ),
      ExamItem(
        id: 'dgs',
        title: 'DGS',
        subtitle: 'Dikey Geçiş Sınavı',
        examDate: DateTime(year, 7, 20, 10, 15),
        category: 'DGS',
        isPreset: true,
      ),
    ];
  }
}
