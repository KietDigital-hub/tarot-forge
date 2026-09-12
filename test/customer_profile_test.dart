import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_forge/features/customer_profile/domain/models/customer_profile.dart';

void main() {
  group('CustomerProfile Model & Recommendation Engine', () {
    test('Default profile has valid values', () {
      final profile = CustomerProfile.defaultProfile();
      expect(profile.name, 'Nhà Chiêm Tinh');
      expect(profile.style, 'Huyền bí');
      expect(profile.suggestedTemplateId, 'celestial_mystic');
    });

    test('Correctly maps customer styles to matching Tarot card templates', () {
      final now = DateTime.now();

      final classic = CustomerProfile(
        name: 'Alex',
        style: 'Cổ điển',
        favoriteColor: 'Vàng Kim & Chàm Tím',
        theme: 'Thần thoại cổ đại',
        notes: '',
        createdAt: now,
      );
      expect(classic.suggestedTemplateId, 'classic_arcana');

      final minimal = classic.copyWith(style: 'Tối giản');
      expect(minimal.suggestedTemplateId, 'minimalist_alchemy');

      final royal = classic.copyWith(style: 'Hoàng gia');
      expect(royal.suggestedTemplateId, 'full_bleed_art');

      final nature = classic.copyWith(style: 'Thiên nhiên');
      expect(nature.suggestedTemplateId, 'full_bleed_art');

      final mystic = classic.copyWith(style: 'Huyền bí');
      expect(mystic.suggestedTemplateId, 'celestial_mystic');
    });

    test('Correctly maps customer styles & themes to distinct Tarot presets', () {
      final now = DateTime.now();

      final royal = CustomerProfile(
        name: 'Vương Giả',
        style: 'Hoàng gia',
        favoriteColor: 'Đỏ Nhung & Đen Huyền',
        theme: 'Thần thoại cổ đại',
        notes: '',
        createdAt: now,
      );
      expect(royal.suggestedPreset.romanNumeral, 'IV');
      expect(royal.suggestedPreset.name, 'HOÀNG ĐẾ');
      expect(royal.suggestedPreset.assetImagePath, 'assets/images/the_emperor.jpg');

      final nature = royal.copyWith(style: 'Thiên nhiên');
      expect(nature.suggestedPreset.romanNumeral, 'III');
      expect(nature.suggestedPreset.name, 'NỮ HOÀNG');
      expect(nature.suggestedPreset.assetImagePath, 'assets/images/the_empress.jpg');

      final classic = royal.copyWith(style: 'Cổ điển');
      expect(classic.suggestedPreset.romanNumeral, 'I');
      expect(classic.suggestedPreset.name, 'PHÁP SƯ');
      expect(classic.suggestedPreset.assetImagePath, 'assets/images/the_magician.jpg');

      final mystic = royal.copyWith(style: 'Huyền bí');
      expect(mystic.suggestedPreset.romanNumeral, 'XVIII');
      expect(mystic.suggestedPreset.name, 'MẶT TRĂNG');
      expect(mystic.suggestedPreset.assetImagePath, 'assets/images/the_moon.jpg');

      final minimal = royal.copyWith(style: 'Tối giản');
      expect(minimal.suggestedPreset.romanNumeral, 'XVII');
      expect(minimal.suggestedPreset.name, 'NGÔI SAO');
      expect(minimal.suggestedPreset.assetImagePath, 'assets/images/the_star.jpg');

      // Theme fallbacks when style is custom
      final customNature = royal.copyWith(style: 'Tự do', theme: 'Hoa lá & Thảo mộc');
      expect(customNature.suggestedPreset.name, 'NỮ HOÀNG');

      final customWitch = royal.copyWith(style: 'Tự do', theme: 'Phù thủy & Huyền thuật');
      expect(customWitch.suggestedPreset.name, 'PHÁP SƯ');
    });

    test('Changing favoriteColor creates distinct preset and template variations', () {
      final now = DateTime.now();

      // Base: Huyền bí + Vàng Kim & Chàm Tím
      final baseMystic = CustomerProfile(
        name: 'Chiêm Tinh',
        style: 'Huyền bí',
        favoriteColor: 'Vàng Kim & Chàm Tím',
        theme: 'Thiên văn & Tinh tú',
        notes: '',
        createdAt: now,
      );
      expect(baseMystic.suggestedPreset.name, 'MẶT TRĂNG');
      expect(baseMystic.suggestedTemplateId, 'celestial_mystic');

      // Change color to Đen Tuyền & Đỏ Máu: shifts to HOÀNG ĐẾ + full_bleed_art
      final redBlackMystic = baseMystic.copyWith(favoriteColor: 'Đen Tuyền & Đỏ Máu');
      expect(redBlackMystic.suggestedPreset.name, 'HOÀNG ĐẾ');
      expect(redBlackMystic.suggestedTemplateId, 'full_bleed_art');

      // Change color to Bạc Tinh Tú & Xanh Băng: shifts to NGÔI SAO
      final silverMystic = baseMystic.copyWith(favoriteColor: 'Bạc Tinh Tú & Xanh Băng');
      expect(silverMystic.suggestedPreset.name, 'NGÔI SAO');

      // Change color to Xanh Lục Rừng & Nâu Gỗ: shifts to NỮ HOÀNG + full_bleed_art
      final greenMystic = baseMystic.copyWith(favoriteColor: 'Xanh Lục Rừng & Nâu Gỗ');
      expect(greenMystic.suggestedPreset.name, 'NỮ HOÀNG');
      expect(greenMystic.suggestedTemplateId, 'full_bleed_art');
    });

    test('All 20 artistic styles produce valid prompts and defined presets', () {
      const allStyles = [
        'Huyền bí', 'Cổ điển', 'Tối giản', 'Hoàng gia', 'Thiên nhiên',
        'Gothic tối', 'Nghệ thuật Nouveau', 'Phù thủy dân gian', 'Phương Đông huyền bí', 'Ai Cập cổ đại',
        'Thiên hà vũ trụ', 'Cyberpunk huyền huyễn', 'Baroque tráng lệ', 'Thủy mặc tối giản', 'Rừng nhiệt đới',
        'Đại dương huyền bí', 'Hoàng hôn sa mạc', 'Băng giá phương Bắc', 'Cổ tích Châu Âu', 'Hiện đại tối giản neon'
      ];

      for (final s in allStyles) {
        final p = CustomerProfile(
          name: 'Test',
          style: s,
          favoriteColor: 'Vàng Kim & Chàm Tím',
          theme: 'Thiên văn & Tinh tú',
          notes: '',
          createdAt: DateTime.now(),
        );
        expect(p.suggestedTemplateId, isNotEmpty);
        expect(p.suggestedPreset.name, isNotEmpty);
        final prompt = p.buildTarotPrompt(cardName: 'THE FOOL', userDescription: '');
        expect(prompt, contains('Masterpiece occult tarot card illustration for "THE FOOL"'));
      }
    });

    test('All 12 color palettes produce valid prompt keywords', () {
      const allColors = [
        'Vàng Kim & Chàm Tím', 'Đỏ Nhung & Đen Huyền', 'Xanh Ngọc & Đồng Cổ', 'Bạc Tinh Tú & Xanh Băng',
        'Cam Hoàng Hôn & Nâu Đất', 'Hồng Phấn & Bạc', 'Tím Than & Xanh Lá Đậm', 'Trắng Ngà & Vàng Nhạt',
        'Đen Tuyền & Đỏ Máu', 'Xanh Dương Hoàng Gia & Vàng Đồng', 'Xanh Lục Rừng & Nâu Gỗ', 'Cầu Vồng Ánh Kim & Trắng'
      ];

      for (final c in allColors) {
        final p = CustomerProfile(
          name: 'Test',
          style: 'Cổ điển',
          favoriteColor: c,
          theme: 'Thần thoại cổ đại',
          notes: '',
          createdAt: DateTime.now(),
        );
        final prompt = p.buildTarotPrompt(cardName: 'THE STAR', userDescription: '');
        expect(prompt, contains('Color palette:'));
      }
    });

    test('buildTarotPrompt generates authentic tarot occult prompt with strict constraints', () {
      final profile = CustomerProfile(
        name: 'Linh Đan',
        style: 'Hoàng gia',
        favoriteColor: 'Đỏ Nhung & Đen Huyền',
        theme: 'Thiên thần & Thánh tích',
        notes: 'Chữa lành',
        createdAt: DateTime.now(),
      );

      final prompt = profile.buildTarotPrompt(
        cardName: 'THE EMPRESS',
        userDescription: 'Nữ hoàng ngồi trên ngai vàng quyền uy giữa vườn hoa hồng',
      );

      // Verify tarot integrity constraints
      expect(prompt, contains('Masterpiece occult tarot card illustration for "THE EMPRESS"'));
      expect(prompt, contains('Authentic vintage tarot card aesthetic'));
      expect(prompt, contains('Imperial baroque regality with opulent golden filigree'));
      expect(prompt, contains('velvet crimson red, obsidian black and burnished bronze'));
      expect(prompt, contains('seraphic divine wings, sacred halos, angelic light beams'));
      expect(prompt, contains('Constraints: Genuine tarot artwork only, no modern photorealism, no cartoon, no anime'));
    });
  });
}
