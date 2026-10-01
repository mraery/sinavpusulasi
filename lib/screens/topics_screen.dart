import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../services/exam_service.dart';

class TopicsScreen extends StatefulWidget {
  final ExamService examService;

  const TopicsScreen({super.key, required this.examService});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  String _selectedCategory = 'TYT Matematik';

  final List<String> _categories = [
    'TYT Matematik',
    'TYT Türkçe',
    'TYT Geometri',
    'TYT Fizik',
    'TYT Kimya',
    'TYT Biyoloji',
    'AYT Matematik',
    'AYT Edebiyat',
  ];

  void _showAddQuestionsDialog(TopicItem topic) {
    int count = 20;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "${topic.title} - Soru Ekle",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bu konuda çözdüğünüz soru adedini ekleyin:',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF38BDF8)),
                    onPressed: () {
                      if (count > 5) {
                        setDialogState(() => count -= 5);
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$count Soru",
                      style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF38BDF8)),
                    onPressed: () {
                      setDialogState(() => count += 5);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [10, 20, 30, 50].map((quick) {
                  return ActionChip(
                    label: Text("+$quick"),
                    backgroundColor: const Color(0xFF0F172A),
                    labelStyle: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
                    onPressed: () {
                      setDialogState(() => count += quick);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: const Color(0xFF0F172A),
            ),
            onPressed: () async {
              await widget.examService.addTopicSolvedQuestions(topic.id, count);
              await widget.examService.addQuestionLog(topic.category, count);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTopics = widget.examService.getTopics();
    final currentTopics =
        allTopics.where((t) => t.category == _selectedCategory).toList();

    final completedCount = currentTopics.where((t) => t.isCompleted).length;
    final totalCount = currentTopics.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    final totalSolvedForCat =
        currentTopics.fold(0, (sum, t) => sum + t.solvedQuestions);

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Konu Takip & Müfredat',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Category selector scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedCategory = cat);
                    },
                    backgroundColor: const Color(0xFF1E293B),
                    selectedColor: const Color(0xFF38BDF8),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0F172A) : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
          ),

          // Progress Overview Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF1E3A5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "%${(progress * 100).toInt()} Tamamlandı",
                      style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFF0F172A),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$completedCount / $totalCount Konu Bitti",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      "$totalSolvedForCat Soru Çözüldü",
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Topics Checklist
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: currentTopics.length,
              itemBuilder: (context, index) {
                final topic = currentTopics[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: topic.isCompleted
                          ? const Color(0xFF10B981).withValues(alpha: 0.4)
                          : const Color(0xFF334155),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: Checkbox(
                        value: topic.isCompleted,
                        activeColor: const Color(0xFF10B981),
                        checkColor: Colors.white,
                        side: const BorderSide(color: Colors.white54, width: 1.5),
                        onChanged: (val) async {
                          await widget.examService.toggleTopicCompletion(topic.id);
                          setState(() {});
                        },
                      ),
                      title: Text(
                        topic.title,
                        style: TextStyle(
                          color: topic.isCompleted ? Colors.white60 : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: topic.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: const Color(0xFF10B981),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "${topic.solvedQuestions} soru çözüldü",
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add_task_rounded,
                          color: Color(0xFF38BDF8),
                          size: 22,
                        ),
                        tooltip: 'Soru Ekle',
                        onPressed: () => _showAddQuestionsDialog(topic),
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
}
