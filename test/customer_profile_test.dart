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
