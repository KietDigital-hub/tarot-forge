import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot_forge/features/customer_profile/presentation/screens/customer_profile_screen.dart';
import 'package:tarot_forge/features/deck_manager/presentation/screens/deck_manager_screen.dart';
import 'package:tarot_forge/features/help/presentation/screens/help_guide_screen.dart';
import 'package:tarot_forge/features/home/presentation/screens/home_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('Renders HomeScreen with title, tagline, showcase card, and action buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Check title and tagline
      expect(find.text('TAROT FORGE'), findsWidgets); // In AppBar and Hero section
      expect(
        find.text('Tự thiết kế bộ bài Tarot của riêng bạn, chuẩn in ấn chuyên nghiệp'),
        findsOneWidget,
      );

      // Check badge and tags
      expect(find.text('XƯỞNG CHẾ TÁC BÀI TAROT CHUYÊN NGHIỆP'), findsOneWidget);
      expect(find.text('20 Phong Cách'), findsOneWidget);
      expect(find.text('Chuẩn In 300 DPI'), findsOneWidget);
      expect(find.text('AI Gemini'), findsOneWidget);

      // Check hero card
      expect(find.text('XVII • NGÔI SAO'), findsOneWidget);
      expect(find.text('70x120mm • 300 DPI Bleed'), findsOneWidget);

      // Check primary & secondary buttons exist
      expect(find.text('BẮT ĐẦU THIẾT KẾ BỘ BÀI MỚI'), findsOneWidget);
      expect(find.text('KHO 78 LÁ BÀI'), findsOneWidget);
      expect(find.text('HƯỚNG DẪN'), findsOneWidget);
    });

    testWidgets('Tapping "BẮT ĐẦU THIẾT KẾ BỘ BÀI MỚI" pushes CustomerProfileScreen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BỘ BÀI MỚI');
      expect(startButton, findsOneWidget);
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // CustomerProfileScreen header check
      expect(find.byType(CustomerProfileScreen), findsOneWidget);
      expect(find.text('BƯỚC 1: HỒ SƠ BỘ BÀI CÁ NHÂN'), findsOneWidget);
    });

    testWidgets('Tapping "KHO 78 LÁ BÀI" pushes DeckManagerScreen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final deckButton = find.text('KHO 78 LÁ BÀI');
      expect(deckButton, findsOneWidget);
      await tester.ensureVisible(deckButton);
      await tester.tap(deckButton);
      await tester.pumpAndSettle();

      expect(find.byType(DeckManagerScreen), findsOneWidget);
      expect(find.text('BỘ BÀI TAROT (78 LÁ)'), findsOneWidget);
    });

    testWidgets('Tapping "HƯỚNG DẪN" pushes HelpGuideScreen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final helpButton = find.text('HƯỚNG DẪN');
      expect(helpButton, findsOneWidget);
      await tester.ensureVisible(helpButton);
      await tester.tap(helpButton);
      await tester.pumpAndSettle();

      expect(find.byType(HelpGuideScreen), findsOneWidget);
      expect(find.text('HƯỚNG DẪN SỬ DỤNG'), findsOneWidget);
    });
  });
}
