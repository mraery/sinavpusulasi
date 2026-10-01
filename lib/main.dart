import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/exam_service.dart';
import 'screens/countdown_screen.dart';
import 'screens/net_tracker_screen.dart';
import 'screens/topics_screen.dart';
import 'screens/target_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F172A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final examService = await ExamService.init();
  runApp(SinavPusulasiApp(examService: examService));
}

class SinavPusulasiApp extends StatelessWidget {
  final ExamService examService;

  const SinavPusulasiApp({super.key, required this.examService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SınavPusulası',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
        ),
        useMaterial3: true,
      ),
      home: MainShell(examService: examService),
    );
  }
}

class MainShell extends StatefulWidget {
  final ExamService examService;

  const MainShell({super.key, required this.examService});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      CountdownScreen(examService: widget.examService),
      NetTrackerScreen(examService: widget.examService),
      TopicsScreen(examService: widget.examService),
      TargetScreen(examService: widget.examService),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          border: Border(
            top: BorderSide(color: Color(0xFF1E293B), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF0F172A),
          selectedItemColor: const Color(0xFF38BDF8),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer_rounded),
              label: 'Geri Sayım',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics_rounded),
              label: 'Net Takip',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rounded),
              activeIcon: Icon(Icons.checklist_rtl_rounded),
              label: 'Konular',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_rounded),
              activeIcon: Icon(Icons.track_changes_sharp),
              label: 'Hedef & Odak',
            ),
          ],
        ),
      ),
    );
  }
}
