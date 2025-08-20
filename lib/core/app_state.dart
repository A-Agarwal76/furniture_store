import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  AppState._();
  static final AppState instance = AppState._();

  static const _favoritesKey = 'favorites_ids_v1';
  static const _cartKey = 'cart_ids_v1';

  final ValueNotifier<Set<String>> favoriteIds = ValueNotifier<Set<String>>({});
  final ValueNotifier<List<String>> cartProductIds =
      ValueNotifier<List<String>>([]);

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final fav = _prefs!.getStringList(_favoritesKey) ?? <String>[];
    final cart = _prefs!.getStringList(_cartKey) ?? <String>[];
    favoriteIds.value = fav.toSet();
    cartProductIds.value = List<String>.from(cart);
  }

  void toggleFavorite(String productId) {
    final next = Set<String>.from(favoriteIds.value);
    if (next.contains(productId)) {
      next.remove(productId);
    } else {
      next.add(productId);
    }
    favoriteIds.value = next;
    _prefs?.setStringList(_favoritesKey, next.toList());
  }

  bool isFavorite(String productId) => favoriteIds.value.contains(productId);

  void addToCart(String productId) {
    final next = List<String>.from(cartProductIds.value)..add(productId);
    cartProductIds.value = next;
    _prefs?.setStringList(_cartKey, next);
  }

  void removeFromCartAt(int index) {
    if (index < 0 || index >= cartProductIds.value.length) return;
    final next = List<String>.from(cartProductIds.value)..removeAt(index);
    cartProductIds.value = next;
    _prefs?.setStringList(_cartKey, next);
  }
}
