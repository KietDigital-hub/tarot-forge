import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot_forge/features/card_designer/presentation/providers/card_designer_provider.dart';
import 'package:tarot_forge/features/customer_profile/presentation/providers/customer_profile_provider.dart';
import 'package:tarot_forge/features/customer_profile/presentation/screens/customer_profile_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Customer Profile to Card Designer Flow Integration', () {
    testWidgets('Selecting "Hoàng gia" updates Card Designer to IV - HOÀNG ĐẾ and full_bleed_art',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final royalChip = find.text('Hoàng gia');
      expect(royalChip, findsOneWidget);
      await tester.ensureVisible(royalChip);
      await tester.pumpAndSettle();
      await tester.tap(royalChip);
      await tester.pumpAndSettle();

      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BÀI');
      expect(startButton, findsOneWidget);
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final activeCard = container.read(cardDesignerProvider);
      expect(activeCard.name, 'HOÀNG ĐẾ');
      expect(activeCard.romanNumeral, 'IV');
      expect(activeCard.templateId, 'full_bleed_art');
      expect(activeCard.assetImagePath, 'assets/images/the_emperor.jpg');
    });

    testWidgets('Selecting "Thiên nhiên" updates Card Designer to III - NỮ HOÀNG and full_bleed_art',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final natureChip = find.text('Thiên nhiên');
      expect(natureChip, findsOneWidget);
      await tester.ensureVisible(natureChip);
      await tester.pumpAndSettle();
      await tester.tap(natureChip);
      await tester.pumpAndSettle();

      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BÀI');
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final activeCard = container.read(cardDesignerProvider);
      expect(activeCard.name, 'NỮ HOÀNG');
      expect(activeCard.romanNumeral, 'III');
      expect(activeCard.templateId, 'full_bleed_art');
      expect(activeCard.assetImagePath, 'assets/images/the_empress.jpg');
    });

    testWidgets('Selecting "Cổ điển" updates Card Designer to I - PHÁP SƯ and classic_arcana',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final classicChip = find.text('Cổ điển');
      expect(classicChip, findsOneWidget);
      await tester.ensureVisible(classicChip);
      await tester.pumpAndSettle();
      await tester.tap(classicChip);
      await tester.pumpAndSettle();

      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BÀI');
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final activeCard = container.read(cardDesignerProvider);
      expect(activeCard.name, 'PHÁP SƯ');
      expect(activeCard.romanNumeral, 'I');
      expect(activeCard.templateId, 'classic_arcana');
      expect(activeCard.assetImagePath, 'assets/images/the_magician.jpg');
    });

    testWidgets('Selecting "Huyền bí" updates Card Designer to XVIII - MẶT TRĂNG and celestial_mystic',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final mysticChip = find.text('Huyền bí');
      expect(mysticChip, findsOneWidget);
      await tester.ensureVisible(mysticChip);
      await tester.pumpAndSettle();
      await tester.tap(mysticChip);
      await tester.pumpAndSettle();

      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BÀI');
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final activeCard = container.read(cardDesignerProvider);
      expect(activeCard.name, 'MẶT TRĂNG');
      expect(activeCard.romanNumeral, 'XVIII');
      expect(activeCard.templateId, 'celestial_mystic');
      expect(activeCard.assetImagePath, 'assets/images/the_moon.jpg');
    });

    testWidgets('Selecting "Tối giản" updates Card Designer to XVII - NGÔI SAO and minimalist_alchemy',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final minimalChip = find.text('Tối giản');
      expect(minimalChip, findsOneWidget);
      await tester.ensureVisible(minimalChip);
      await tester.pumpAndSettle();
      await tester.tap(minimalChip);
      await tester.pumpAndSettle();

      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BÀI');
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final activeCard = container.read(cardDesignerProvider);
      expect(activeCard.name, 'NGÔI SAO');
      expect(activeCard.romanNumeral, 'XVII');
      expect(activeCard.templateId, 'minimalist_alchemy');
      expect(activeCard.assetImagePath, 'assets/images/the_star.jpg');
    });

    testWidgets('Section 5 displays note about Gemini API key requirement',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Expand advanced section to reveal note
      final advancedToggle = find.text('TÙY CHỈNH NÂNG CAO');
      expect(advancedToggle, findsOneWidget);
      await tester.ensureVisible(advancedToggle);
      await tester.pumpAndSettle();
      await tester.tap(advancedToggle);
      await tester.pumpAndSettle();

      final noteFinder = find.text(
        '(Lưu ý: nội dung này chỉ ảnh hưởng đến ảnh khi bạn đã gắn API key AI ở bước sau — chưa gắn API key thì ghi gì cũng chưa có tác dụng)',
      );
      expect(noteFinder, findsOneWidget);
    });

    testWidgets('Selecting "Gothic tối" and "Đen Tuyền & Đỏ Máu" applies custom card design',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Select Gothic tối popular card
      final gothicChip = find.text('Gothic tối');
      expect(gothicChip, findsOneWidget);
      await tester.ensureVisible(gothicChip);
      await tester.pumpAndSettle();
      await tester.tap(gothicChip);
      await tester.pumpAndSettle();

      // Select color Đen Tuyền & Đỏ Máu from popular card
      final colorItem = find.text('Đen Tuyền & Đỏ Máu');
      expect(colorItem, findsOneWidget);
      await tester.ensureVisible(colorItem);
      await tester.pumpAndSettle();
      await tester.tap(colorItem);
      await tester.pumpAndSettle();

      // Start design
      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BÀI');
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final activeCard = container.read(cardDesignerProvider);
      expect(activeCard.name, 'CÁI CHẾT');
      expect(activeCard.romanNumeral, 'XIII');
      expect(activeCard.templateId, 'full_bleed_art');
      expect(activeCard.assetImagePath, 'assets/images/gothic_dark.jpg');

      final customerProfile = container.read(customerProfileProvider);
      expect(customerProfile.favoriteColor, 'Đen Tuyền & Đỏ Máu');
      expect(customerProfile.palette.name, 'Đen Tuyền & Đỏ Máu');
      expect(customerProfile.palette.getAccent(true), const Color(0xFFFF4D4F));
    });

    testWidgets('Selecting color palette "Bạc Tinh Tú & Xanh Băng" dynamically updates accentColor',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CustomerProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expand advanced section to access full 12 color palettes
      final advancedToggle = find.text('TÙY CHỈNH NÂNG CAO');
      expect(advancedToggle, findsOneWidget);
      await tester.ensureVisible(advancedToggle);
      await tester.pumpAndSettle();
      await tester.tap(advancedToggle);
      await tester.pumpAndSettle();

      // Select color Bạc Tinh Tú & Xanh Băng
      final colorItem = find.text('Bạc Tinh Tú & Xanh Băng');
      expect(colorItem, findsOneWidget);
      await tester.ensureVisible(colorItem);
      await tester.pumpAndSettle();
      await tester.tap(colorItem);
      await tester.pumpAndSettle();

      // Start design
      final startButton = find.text('BẮT ĐẦU THIẾT KẾ BÀI');
      await tester.ensureVisible(startButton);
      await tester.pumpAndSettle();
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final customerProfile = container.read(customerProfileProvider);
      expect(customerProfile.favoriteColor, 'Bạc Tinh Tú & Xanh Băng');
      expect(customerProfile.palette.getAccent(true), const Color(0xFF74C0FC));
      expect(customerProfile.palette.getAccent(false), const Color(0xFF1971C2));
    });
  });
}
