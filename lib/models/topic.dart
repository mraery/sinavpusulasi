import 'dart:convert';

class TopicItem {
  final String id;
  final String category; // 'TYT Türkçe', 'TYT Matematik', etc.
  final String title;
  final bool isCompleted;
  final int solvedQuestions;

  TopicItem({
    required this.id,
    required this.category,
    required this.title,
    this.isCompleted = false,
    this.solvedQuestions = 0,
  });

  TopicItem copyWith({
    bool? isCompleted,
    int? solvedQuestions,
  }) {
    return TopicItem(
      id: id,
      category: category,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
      solvedQuestions: solvedQuestions ?? this.solvedQuestions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'isCompleted': isCompleted,
      'solvedQuestions': solvedQuestions,
    };
  }

  factory TopicItem.fromMap(Map<String, dynamic> map) {
    return TopicItem(
      id: map['id'] as String,
      category: map['category'] as String,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      solvedQuestions: map['solvedQuestions'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory TopicItem.fromJson(String source) =>
      TopicItem.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<TopicItem> get defaultTopics {
    return [
      // TYT Türkçe
      TopicItem(id: 'tr_1', category: 'TYT Türkçe', title: 'Sözcükte Anlam ve Yorum'),
      TopicItem(id: 'tr_2', category: 'TYT Türkçe', title: 'Cümlede Anlam ve Yorum'),
      TopicItem(id: 'tr_3', category: 'TYT Türkçe', title: 'Paragrafta Anlam ve Ana Düşünce'),
      TopicItem(id: 'tr_4', category: 'TYT Türkçe', title: 'Paragrafta Yapı ve Akış'),
      TopicItem(id: 'tr_5', category: 'TYT Türkçe', title: 'Ses Bilgisi'),
      TopicItem(id: 'tr_6', category: 'TYT Türkçe', title: 'Yazım Kuralları'),
      TopicItem(id: 'tr_7', category: 'TYT Türkçe', title: 'Noktalama İşaretleri'),
      TopicItem(id: 'tr_8', category: 'TYT Türkçe', title: 'Sözcükte Yapı ve Ekler'),
      TopicItem(id: 'tr_9', category: 'TYT Türkçe', title: 'İsim, Sıfat, Zamir, Zarf'),
      TopicItem(id: 'tr_10', category: 'TYT Türkçe', title: 'Edat, Bağlaç, Ünlem'),
      TopicItem(id: 'tr_11', category: 'TYT Türkçe', title: 'Fiiller, Ek Fiil ve Fiilimsi'),
      TopicItem(id: 'tr_12', category: 'TYT Türkçe', title: 'Cümlenin Ögeleri'),
      TopicItem(id: 'tr_13', category: 'TYT Türkçe', title: 'Cümle Türleri ve Anlatım Bozuklukları'),

      // TYT Matematik
      TopicItem(id: 'mat_1', category: 'TYT Matematik', title: 'Temel Kavramlar & Sayı Kümeleri'),
      TopicItem(id: 'mat_2', category: 'TYT Matematik', title: 'Basamak Kavramı ve Çözümleme'),
      TopicItem(id: 'mat_3', category: 'TYT Matematik', title: 'Bölme ve Bölünebilme Kuralları'),
      TopicItem(id: 'mat_4', category: 'TYT Matematik', title: 'Asal Çarpanlar ve EBOB - EKOK'),
      TopicItem(id: 'mat_5', category: 'TYT Matematik', title: 'Rasyonel ve Ondalık Sayılar'),
      TopicItem(id: 'mat_6', category: 'TYT Matematik', title: 'Basit Eşitsizlikler ve Sıralama'),
      TopicItem(id: 'mat_7', category: 'TYT Matematik', title: 'Mutlak Değer'),
      TopicItem(id: 'mat_8', category: 'TYT Matematik', title: 'Üslü İfadeler'),
      TopicItem(id: 'mat_9', category: 'TYT Matematik', title: 'Köklü İfadeler'),
      TopicItem(id: 'mat_10', category: 'TYT Matematik', title: 'Çarpanlara Ayırma'),
      TopicItem(id: 'mat_11', category: 'TYT Matematik', title: 'Oran - Orantı'),
      TopicItem(id: 'mat_12', category: 'TYT Matematik', title: 'Sayı - Kesir Problemleri'),
      TopicItem(id: 'mat_13', category: 'TYT Matematik', title: 'Yaş Problemleri'),
      TopicItem(id: 'mat_14', category: 'TYT Matematik', title: 'İşçi - Havuz Problemleri'),
      TopicItem(id: 'mat_15', category: 'TYT Matematik', title: 'Hız - Hareket Problemleri'),
      TopicItem(id: 'mat_16', category: 'TYT Matematik', title: 'Yüzde, Kar-Zarar ve Karışım'),
      TopicItem(id: 'mat_17', category: 'TYT Matematik', title: 'Kümeler ve Kartezyen Çarpım'),
      TopicItem(id: 'mat_18', category: 'TYT Matematik', title: 'Fonksiyonlar'),
      TopicItem(id: 'mat_19', category: 'TYT Matematik', title: 'Permütasyon & Kombinasyon'),
      TopicItem(id: 'mat_20', category: 'TYT Matematik', title: 'Olasılık ve İstatistik'),

      // TYT Geometri
      TopicItem(id: 'geo_1', category: 'TYT Geometri', title: 'Doğruda ve Üçgende Açılar'),
      TopicItem(id: 'geo_2', category: 'TYT Geometri', title: 'Özel Üçgenler (Dik, İkizkenar, Eşkenar)'),
      TopicItem(id: 'geo_3', category: 'TYT Geometri', title: 'Açıortay ve Kenarortay'),
      TopicItem(id: 'geo_4', category: 'TYT Geometri', title: 'Üçgende Benzerlik ve Alan'),
      TopicItem(id: 'geo_5', category: 'TYT Geometri', title: 'Çokgenler ve Dörtgenler'),
      TopicItem(id: 'geo_6', category: 'TYT Geometri', title: 'Yamuk, Paralelkenar, Eşkenar Dörtgen'),
      TopicItem(id: 'geo_7', category: 'TYT Geometri', title: 'Dikdörtgen ve Kare'),
      TopicItem(id: 'geo_8', category: 'TYT Geometri', title: 'Çember ve Daire (Açı, Uzunluk, Alan)'),
      TopicItem(id: 'geo_9', category: 'TYT Geometri', title: 'Katı Cisimler (Prizma, Piramit, Koni, Küre)'),
      TopicItem(id: 'geo_10', category: 'TYT Geometri', title: 'Noktanın ve Doğrunun Analitiği'),

      // TYT Fizik
      TopicItem(id: 'fiz_1', category: 'TYT Fizik', title: 'Fizik Bilimine Giriş'),
      TopicItem(id: 'fiz_2', category: 'TYT Fizik', title: 'Madde ve Özkütle'),
      TopicItem(id: 'fiz_3', category: 'TYT Fizik', title: 'Sıvıların Kaldırma Kuvveti & Basınç'),
      TopicItem(id: 'fiz_4', category: 'TYT Fizik', title: 'Isı, Sıcaklık ve Genleşme'),
      TopicItem(id: 'fiz_5', category: 'TYT Fizik', title: 'Doğrusal Hareket ve Kuvvet'),
      TopicItem(id: 'fiz_6', category: 'TYT Fizik', title: 'Newton\'un Hareket Yasaları'),
      TopicItem(id: 'fiz_7', category: 'TYT Fizik', title: 'İş, Güç ve Mekanik Enerji'),
      TopicItem(id: 'fiz_8', category: 'TYT Fizik', title: 'Elektrostatik ve Elektrik Akımı'),
      TopicItem(id: 'fiz_9', category: 'TYT Fizik', title: 'Manyetizma'),
      TopicItem(id: 'fiz_10', category: 'TYT Fizik', title: 'Optik (Aydınlanma, Yansıma, Kırılma, Mercekler)'),
      TopicItem(id: 'fiz_11', category: 'TYT Fizik', title: 'Dalgalar (Yay, Su, Ses, Deprem)'),

      // TYT Kimya
      TopicItem(id: 'kim_1', category: 'TYT Kimya', title: 'Kimya Bilimi ve Güvenlik'),
      TopicItem(id: 'kim_2', category: 'TYT Kimya', title: 'Atom Modelleri ve Periyodik Sistem'),
      TopicItem(id: 'kim_3', category: 'TYT Kimya', title: 'Kimyasal Türler Arası Etkileşimler'),
      TopicItem(id: 'kim_4', category: 'TYT Kimya', title: 'Maddenin Halleri ve Gazlar'),
      TopicItem(id: 'kim_5', category: 'TYT Kimya', title: 'Doğa ve Kimya (Çevre)'),
      TopicItem(id: 'kim_6', category: 'TYT Kimya', title: 'Kimyanın Temel Kanunları & Mol'),
      TopicItem(id: 'kim_7', category: 'TYT Kimya', title: 'Kimyasal Hesaplamalar'),
      TopicItem(id: 'kim_8', category: 'TYT Kimya', title: 'Karışımlar ve Ayırma Yöntemleri'),
      TopicItem(id: 'kim_9', category: 'TYT Kimya', title: 'Asitler, Bazlar ve Tuzlar'),
      TopicItem(id: 'kim_10', category: 'TYT Kimya', title: 'Kimya Her Yerde'),

      // TYT Biyoloji
      TopicItem(id: 'bio_1', category: 'TYT Biyoloji', title: 'Canlıların Ortak Özellikleri'),
      TopicItem(id: 'bio_2', category: 'TYT Biyoloji', title: 'Temel Bileşikler (Organik-İnorganik)'),
      TopicItem(id: 'bio_3', category: 'TYT Biyoloji', title: 'Hücre Yapısı ve Organeller'),
      TopicItem(id: 'bio_4', category: 'TYT Biyoloji', title: 'Hücre Zarından Madde Geçişleri'),
      TopicItem(id: 'bio_5', category: 'TYT Biyoloji', title: 'Canlıların Sınıflandırılması'),
      TopicItem(id: 'bio_6', category: 'TYT Biyoloji', title: 'Mitoz ve Mayoz Bölünme'),
      TopicItem(id: 'bio_7', category: 'TYT Biyoloji', title: 'Kalıtım İlkeleri ve Genetik'),
      TopicItem(id: 'bio_8', category: 'TYT Biyoloji', title: 'Ekosistem Ekolojisi ve Çevre'),

      // AYT Matematik
      TopicItem(id: 'ayt_mat_1', category: 'AYT Matematik', title: 'Polinomlar ve Çarpanlara Ayırma'),
      TopicItem(id: 'ayt_mat_2', category: 'AYT Matematik', title: 'İkinci Dereceden Denklemler & Karmaşık Sayılar'),
      TopicItem(id: 'ayt_mat_3', category: 'AYT Matematik', title: 'Parabol (İkinci Dereceden Fonksiyonlar)'),
      TopicItem(id: 'ayt_mat_4', category: 'AYT Matematik', title: 'İkinci Dereceden Eşitsizlikler'),
      TopicItem(id: 'ayt_mat_5', category: 'AYT Matematik', title: 'Trigonometri I ve II'),
      TopicItem(id: 'ayt_mat_6', category: 'AYT Matematik', title: 'Logaritma Fonksiyonu'),
      TopicItem(id: 'ayt_mat_7', category: 'AYT Matematik', title: 'Diziler ve Seriler'),
      TopicItem(id: 'ayt_mat_8', category: 'AYT Matematik', title: 'Limit ve Süreklilik'),
      TopicItem(id: 'ayt_mat_9', category: 'AYT Matematik', title: 'Türev ve Uygulamaları (Geometrik Yorum, Maks-Min)'),
      TopicItem(id: 'ayt_mat_10', category: 'AYT Matematik', title: 'Belirsiz ve Belirli İntegral'),
      TopicItem(id: 'ayt_mat_11', category: 'AYT Matematik', title: 'İntegral ile Alan Hesabı'),

      // AYT Edebiyat
      TopicItem(id: 'edb_1', category: 'AYT Edebiyat', title: 'Şiir Bilgisi (Nazım Birimi, Ölçü, Kafiye, Söz Sanatları)'),
      TopicItem(id: 'edb_2', category: 'AYT Edebiyat', title: 'İslamiyet Öncesi ve Geçiş Dönemi Türk Edebiyatı'),
      TopicItem(id: 'edb_3', category: 'AYT Edebiyat', title: 'Halk Edebiyatı (Anonim, Âşık, Tekke)'),
      TopicItem(id: 'edb_4', category: 'AYT Edebiyat', title: 'Divan Edebiyatı (Şairler, Eserler, Nazım Biçimleri)'),
      TopicItem(id: 'edb_5', category: 'AYT Edebiyat', title: 'Tanzimat Dönemi Türk Edebiyatı'),
      TopicItem(id: 'edb_6', category: 'AYT Edebiyat', title: 'Servet-i Fünun ve Fecr-i Âti Edebiyatı'),
      TopicItem(id: 'edb_7', category: 'AYT Edebiyat', title: 'Milli Edebiyat Dönemi'),
      TopicItem(id: 'edb_8', category: 'AYT Edebiyat', title: 'Cumhuriyet Dönemi Türk Şiiri ve Romanı'),
      TopicItem(id: 'edb_9', category: 'AYT Edebiyat', title: 'Batı Edebiyat Akımları'),
    ];
  }
}
