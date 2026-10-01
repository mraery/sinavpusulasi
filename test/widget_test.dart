import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinavpusulasi/main.dart';
import 'package:sinavpusulasi/services/exam_service.dart';

void main() {
  testWidgets('SinavPusulasi smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final service = await ExamService.init();

    await tester.pumpWidget(SinavPusulasiApp(examService: service));
    await tester.pump();

    // Verify presence of title and key elements
    expect(find.text('Sınav Geri Sayımı'), findsOneWidget);
    expect(find.text('Geri Sayım'), findsOneWidget);
    expect(find.text('Net Takip'), findsOneWidget);
    expect(find.text('Konular'), findsOneWidget);
    expect(find.text('Hedef & Odak'), findsOneWidget);
  });
}
