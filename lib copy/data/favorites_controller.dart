import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gère l'ensemble des identifiants de recettes mises en favori.
///
/// Séparé du [RecipeRepository] pour bien distinguer "les données"
/// (les recettes elles-mêmes) de "l'état utilisateur" (ses favoris).
///
/// Les favoris sont persistés localement avec `shared_preferences` :
/// ils survivent donc à la fermeture de l'application.
class FavoritesController extends ChangeNotifier {
  FavoritesController._internal();
  static final FavoritesController instance = FavoritesController._internal();

  static const _prefsKey = 'favorite_recipe_ids';

  final Set<String> _favoriteIds = {};
  bool _initialized = false;

  /// À appeler une fois au démarrage de l'app (avant `runApp`) pour
  /// recharger les favoris précédemment enregistrés sur l'appareil.
  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey) ?? const [];
    _favoriteIds
      ..clear()
      ..addAll(saved);
    _initialized = true;
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggle(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favoriteIds.toList());
  }

  List<String> get favoriteIds => _favoriteIds.toList();
}
