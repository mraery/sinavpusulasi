import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exam.dart';
import '../models/trial_exam.dart';
import '../models/topic.dart';
import '../models/question_target.dart';

class ExamService {
  static const String _customExamsKey = 'sinav_custom_exams_v1';
  static const String _trialExamsKey = 'sinav_trial_exams_v1';
  static const String _topicStatesKey = 'sinav_topic_states_v1';
  static const String _questionLogsKey = 'sinav_question_logs_v1';
  static const String _dailyTargetKey = 'sinav_daily_target_v1';

  final SharedPreferences _prefs;

  ExamService(this._prefs);

  static Future<ExamService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ExamService(prefs);
  }

  // --- Countdown & Exams ---
  List<ExamItem> getAllExams() {
    final preset = ExamItem.defaultPresetExams;
    final customList = getCustomExams();
    return [...customList, ...preset];
  }

  List<ExamItem> getCustomExams() {
    final raw = _prefs.getStringList(_customExamsKey) ?? [];
    return raw.map((str) => ExamItem.fromJson(str)).toList();
  }

  Future<void> addCustomExam(ExamItem exam) async {
    final list = getCustomExams();
    list.insert(0, exam);
    await _prefs.setStringList(
      _customExamsKey,
      list.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> deleteCustomExam(String id) async {
    final list = getCustomExams();
    list.removeWhere((e) => e.id == id);
    await _prefs.setStringList(
      _customExamsKey,
      list.map((e) => e.toJson()).toList(),
    );
  }

  // --- Trial Exams ---
  List<TrialExam> getAllTrials() {
    final raw = _prefs.getStringList(_trialExamsKey) ?? [];
    final trials = raw.map((str) => TrialExam.fromJson(str)).toList();
    trials.sort((a, b) => b.date.compareTo(a.date));
    return trials;
  }

  Future<void> addTrial(TrialExam trial) async {
    final trials = getAllTrials();
    trials.insert(0, trial);
    await _prefs.setStringList(
      _trialExamsKey,
      trials.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> deleteTrial(String id) async {
    final trials = getAllTrials();
    trials.removeWhere((e) => e.id == id);
    await _prefs.setStringList(
      _trialExamsKey,
      trials.map((e) => e.toJson()).toList(),
    );
  }

  // --- Curriculum Topics ---
  Map<String, dynamic> _getTopicStates() {
    final raw = _prefs.getString(_topicStatesKey);
    if (raw == null) return {};
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  List<TopicItem> getTopics() {
    final base = TopicItem.defaultTopics;
    final states = _getTopicStates();

    return base.map((t) {
      if (states.containsKey(t.id)) {
        final state = states[t.id] as Map<String, dynamic>;
        return t.copyWith(
          isCompleted: state['completed'] as bool? ?? false,
          solvedQuestions: state['solved'] as int? ?? 0,
        );
      }
      return t;
    }).toList();
  }

  Future<void> toggleTopicCompletion(String topicId) async {
    final states = _getTopicStates();
    final current = states[topicId] as Map<String, dynamic>? ?? {};
    final bool completed = !(current['completed'] as bool? ?? false);
    final int solved = current['solved'] as int? ?? 0;

    states[topicId] = {'completed': completed, 'solved': solved};
    await _prefs.setString(_topicStatesKey, json.encode(states));
  }

  Future<void> addTopicSolvedQuestions(String topicId, int count) async {
    final states = _getTopicStates();
    final current = states[topicId] as Map<String, dynamic>? ?? {};
    final bool completed = current['completed'] as bool? ?? false;
    final int solved = (current['solved'] as int? ?? 0) + count;

    states[topicId] = {'completed': completed, 'solved': solved};
    await _prefs.setString(_topicStatesKey, json.encode(states));
  }

  // --- Daily Question Targets & Logs ---
  int getDailyTarget() {
    return _prefs.getInt(_dailyTargetKey) ?? 150;
  }

  Future<void> setDailyTarget(int target) async {
    await _prefs.setInt(_dailyTargetKey, target);
  }

  String _getTodayString() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  List<DailyQuestionLog> getAllQuestionLogs() {
    final raw = _prefs.getStringList(_questionLogsKey) ?? [];
    final logs = raw.map((str) => DailyQuestionLog.fromJson(str)).toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  List<DailyQuestionLog> getTodayQuestionLogs() {
    final today = _getTodayString();
    return getAllQuestionLogs().where((l) => l.dateString == today).toList();
  }

  int getTodayTotalSolved() {
    return getTodayQuestionLogs().fold(0, (sum, l) => sum + l.count);
  }

  Future<void> addQuestionLog(String subject, int count) async {
    final logs = getAllQuestionLogs();
    final newLog = DailyQuestionLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateString: _getTodayString(),
      subject: subject,
      count: count,
      timestamp: DateTime.now(),
    );
    logs.insert(0, newLog);
    await _prefs.setStringList(
      _questionLogsKey,
      logs.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> deleteQuestionLog(String id) async {
    final logs = getAllQuestionLogs();
    logs.removeWhere((l) => l.id == id);
    await _prefs.setStringList(
      _questionLogsKey,
      logs.map((e) => e.toJson()).toList(),
    );
  }
}
