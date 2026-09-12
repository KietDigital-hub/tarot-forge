import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/customer_profile.dart';

/// Quản lý trạng thái thông tin và sở thích của khách hàng đối với bộ bài Tarot.
class CustomerProfileNotifier extends Notifier<CustomerProfile> {
  @override
  CustomerProfile build() {
    return CustomerProfile.defaultProfile();
  }

  void updateName(String name) {
    state = state.copyWith(name: name.trim());
  }

  void updateStyle(String style) {
    state = state.copyWith(style: style);
  }

  void updateFavoriteColor(String color) {
    state = state.copyWith(favoriteColor: color);
  }

  void updateTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void saveProfile(CustomerProfile profile) {
    state = profile;
  }
}

final customerProfileProvider =
    NotifierProvider<CustomerProfileNotifier, CustomerProfile>(
  CustomerProfileNotifier.new,
);
