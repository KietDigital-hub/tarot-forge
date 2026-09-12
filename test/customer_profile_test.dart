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
