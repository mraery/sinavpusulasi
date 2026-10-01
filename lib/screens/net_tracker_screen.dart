import 'package:flutter/material.dart';
import '../models/trial_exam.dart';
import '../services/exam_service.dart';

class NetTrackerScreen extends StatefulWidget {
  final ExamService examService;

  const NetTrackerScreen({super.key, required this.examService});

  @override
  State<NetTrackerScreen> createState() => _NetTrackerScreenState();
}

class _NetTrackerScreenState extends State<NetTrackerScreen> {
  void _openAddTrialModal() {
    String selectedType = 'TYT';
    final titleController = TextEditingController(text: 'Türkiye Geneli Deneme');
    final publisherController = TextEditingController(text: 'Özdebir / 3D');
    DateTime selectedDate = DateTime.now();

    List<TrialSection> sections = TrialExam.createDefaultSections(selectedType);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          double calculatedTotalNet = sections.fold(0.0, (sum, s) => sum + s.net);

          return Container(
            height: MediaQuery.of(context).size.height * 0.88,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Yeni Deneme Kaydı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Exam Type selector
                Row(
                  children: [
                    const Text(
                      'Sınav Türü: ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedType,
                      dropdownColor: const Color(0xFF0F172A),
                      style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                      items: const [
                        DropdownMenuItem(value: 'TYT', child: Text('TYT (120 Soru)')),
                        DropdownMenuItem(value: 'AYT_SAY', child: Text('AYT Sayısal (80 Soru)')),
                        DropdownMenuItem(value: 'AYT_EA', child: Text('AYT Eşit Ağırlık (80 Soru)')),
                        DropdownMenuItem(value: 'LGS', child: Text('LGS (90 Soru)')),
                        DropdownMenuItem(value: 'KPSS', child: Text('KPSS (120 Soru)')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            selectedType = val;
                            sections = TrialExam.createDefaultSections(val);
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Deneme Başlığı & Yayın',
                    labelStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Live Net Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hesaplanan Toplam Net:',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        calculatedTotalNet.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Sections List
                Expanded(
                  child: ListView.builder(
                    itemCount: sections.length,
                    itemBuilder: (context, i) {
                      final section = sections[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${section.name} (${section.totalQuestions} Soru)",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Net: ${section.net.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Color(0xFF38BDF8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                // Doğru
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Text(
                                        'D: ',
                                        style: TextStyle(
                                          color: Color(0xFF10B981),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: section.correct.toString(),
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFF1E293B),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            final c = int.tryParse(val) ?? 0;
                                            setModalState(() {
                                              sections[i] = TrialSection(
                                                name: section.name,
                                                totalQuestions: section.totalQuestions,
                                                correct: c.clamp(0, section.totalQuestions),
                                                wrong: section.wrong,
                                                penaltyRate: section.penaltyRate,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Yanlış
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Y: ',
                                        style: TextStyle(
                                          color: Color(0xFFF43F5E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: section.wrong.toString(),
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFF1E293B),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            final w = int.tryParse(val) ?? 0;
                                            setModalState(() {
                                              sections[i] = TrialSection(
                                                name: section.name,
                                                totalQuestions: section.totalQuestions,
                                                correct: section.correct,
                                                wrong: w.clamp(0, section.totalQuestions),
                                                penaltyRate: section.penaltyRate,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Boş
                                Text(
                                  "B: ${section.blank}",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;
                    final trial = TrialExam(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      examType: selectedType,
                      date: selectedDate,
                      publisher: publisherController.text.trim(),
                      sections: sections,
                    );
                    await widget.examService.addTrial(trial);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  child: const Text(
                    'Deneme Sonucunu Kaydet',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trials = widget.examService.getAllTrials();

    final totalTrials = trials.length;
    final avgNet = totalTrials == 0
        ? 0.0
        : trials.fold(0.0, (sum, t) => sum + t.totalNet) / totalTrials;
    final maxNet = totalTrials == 0
        ? 0.0
        : trials.map((t) => t.totalNet).reduce((a, b) => a > b ? a : b);
    final lastNet = totalTrials == 0 ? 0.0 : trials.first.totalNet;

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Deneme Net Takibi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF38BDF8),
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add),
        label: const Text('Deneme Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _openAddTrialModal,
      ),
      body: Column(
        children: [
          // Statistics Summary Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStatCard('Deneme', totalTrials.toString(), Icons.assignment_outlined, const Color(0xFF38BDF8)),
                const SizedBox(width: 8),
                _buildStatCard('Ort. Net', avgNet.toStringAsFixed(1), Icons.analytics_outlined, const Color(0xFF10B981)),
                const SizedBox(width: 8),
                _buildStatCard('En Yüksek', maxNet.toStringAsFixed(1), Icons.emoji_events_outlined, const Color(0xFFFBBF24)),
                const SizedBox(width: 8),
                _buildStatCard('Son Net', lastNet.toStringAsFixed(1), Icons.trending_up_rounded, const Color(0xFFA78BFA)),
              ],
            ),
          ),

          // List of Trials
          Expanded(
            child: trials.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Henüz kaydedilmiş deneme sınavı yok.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Aşağıdaki buton ile ilk denemenizi kaydedin!',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: trials.length,
                    itemBuilder: (context, index) {
                      final trial = trials[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            trial.examType,
                                            style: const TextStyle(
                                              color: Color(0xFF38BDF8),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${trial.date.day}.${trial.date.month}.${trial.date.year}",
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.white38,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await widget.examService.deleteTrial(trial.id);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        trial.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${trial.totalNet.toStringAsFixed(2)} Net",
                                      style: const TextStyle(
                                        color: Color(0xFF38BDF8),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: trial.sections.map((sec) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F172A),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${sec.name}: ${sec.net.toStringAsFixed(1)} Net (${sec.correct}D / ${sec.wrong}Y)",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
