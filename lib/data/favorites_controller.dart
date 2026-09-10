import 'package:flutter/foundation.dart';

/// Gère l'ensemble des identifiants de recettes mises en favori.
///
/// Séparé du [RecipeRepository] pour bien distinguer "les données"
/// (les recettes elles-mêmes) de "l'état utilisateur" (ses favoris).
class FavoritesController extends ChangeNotifier {
  FavoritesController._internal();
  static final FavoritesController instance = FavoritesController._internal();

  final Set<String> _favoriteIds = {};

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggle(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  List<String> get favoriteIds => _favoriteIds.toList();
}
