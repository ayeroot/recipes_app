import 'package:flutter/foundation.dart';
import '../models/recipe.dart';

/// Source de données pour les recettes.
///
/// Dans une vraie application, cette classe interrogerait une API ou
/// une base de données locale. Ici elle simule ce rôle avec une liste
/// en mémoire, mais l'important est que **les widgets et écrans ne
/// contiennent jamais de données en dur** : ils passent toujours par
/// ce dépôt (repository pattern).
class RecipeRepository extends ChangeNotifier {
  RecipeRepository._internal();
  static final RecipeRepository instance = RecipeRepository._internal();

  final List<Recipe> _recipes = [
    const Recipe(
      id: 'r1',
      title: 'Poulet Yassa',
      category: 'Plat',
      difficulty: 'Moyen',
      durationMinutes: 60,
      servings: 4,
      rating: 4.7,
      emoji: '🍗',
      description:
          "Un classique ouest-africain : poulet mariné au citron et aux "
          "oignons, puis mijoté avec une touche de moutarde.",
      ingredients: [
        '4 cuisses de poulet',
        '3 oignons',
        '2 citrons',
        '2 c. à soupe de moutarde',
        'Huile',
        'Sel, poivre',
      ],
    ),
    const Recipe(
      id: 'r2',
      title: 'Riz au gras',
      category: 'Plat',
      difficulty: 'Facile',
      durationMinutes: 45,
      servings: 6,
      rating: 4.5,
      emoji: '🍚',
      description:
          "Riz cuit dans une sauce tomate riche avec légumes et viande, "
          "parfumé aux épices locales.",
      ingredients: [
        '500 g de riz',
        'Viande de bœuf',
        'Tomates',
        'Concentré de tomate',
        'Carottes, chou',
        'Épices',
      ],
    ),
    const Recipe(
      id: 'r3',
      title: "Salade d'avocat",
      category: 'Entrée',
      difficulty: 'Facile',
      durationMinutes: 15,
      servings: 2,
      rating: 4.2,
      emoji: '🥑',
      description:
          "Une entrée fraîche et rapide à base d'avocat mûr, de tomates "
          "et d'une vinaigrette légère.",
      ingredients: [
        '2 avocats',
        '2 tomates',
        'Jus de citron',
        "Huile d'olive",
        'Sel, poivre',
      ],
    ),
    const Recipe(
      id: 'r4',
      title: 'Beignets sucrés',
      category: 'Dessert',
      difficulty: 'Facile',
      durationMinutes: 30,
      servings: 8,
      rating: 4.8,
      emoji: '🍩',
      description:
          "Petits beignets moelleux et sucrés, parfaits pour le goûter "
          "ou le petit-déjeuner.",
      ingredients: [
        '2 tasses de farine',
        '1 sachet de levure',
        'Sucre',
        'Eau tiède',
        'Huile de friture',
      ],
    ),
    const Recipe(
      id: 'r5',
      title: 'Soupe de légumes',
      category: 'Entrée',
      difficulty: 'Facile',
      durationMinutes: 35,
      servings: 4,
      rating: 4.0,
      emoji: '🥣',
      description:
          "Une soupe réconfortante avec des légumes de saison mixés et "
          "légèrement épicés.",
      ingredients: [
        'Carottes',
        'Pommes de terre',
        'Courgettes',
        'Bouillon de légumes',
        'Épices',
      ],
    ),
    const Recipe(
      id: 'r6',
      title: 'Poisson braisé',
      category: 'Plat',
      difficulty: 'Moyen',
      durationMinutes: 50,
      servings: 3,
      rating: 4.6,
      emoji: '🐟',
      description:
          "Poisson mariné aux épices puis braisé au four jusqu'à obtenir "
          "une croûte savoureuse.",
      ingredients: [
        '1 poisson entier',
        'Ail, gingembre',
        'Piment',
        'Huile',
        'Citron',
      ],
    ),
    const Recipe(
      id: 'r7',
      title: 'Tarte aux fruits',
      category: 'Dessert',
      difficulty: 'Difficile',
      durationMinutes: 90,
      servings: 8,
      rating: 4.9,
      emoji: '🥧',
      description:
          "Une pâte croustillante garnie de crème pâtissière et de "
          "fruits frais de saison.",
      ingredients: [
        'Pâte sablée',
        'Crème pâtissière',
        'Fruits frais',
        'Nappage',
      ],
    ),
    const Recipe(
      id: 'r8',
      title: 'Jus de bissap',
      category: 'Boisson',
      difficulty: 'Facile',
      durationMinutes: 20,
      servings: 6,
      rating: 4.4,
      emoji: '🍹',
      description:
          "Boisson rafraîchissante à base de fleurs d'hibiscus, sucrée "
          "et parfumée à la menthe.",
      ingredients: [
        "Fleurs d'hibiscus séchées",
        'Sucre',
        'Eau',
        'Menthe (optionnel)',
      ],
    ),
    const Recipe(
      id: 'r9',
      title: 'Attiéké au poisson',
      category: 'Plat',
      difficulty: 'Moyen',
      durationMinutes: 40,
      servings: 3,
      rating: 4.6,
      emoji: '🍽️',
      description:
          "Semoule de manioc légère servie avec un poisson frit et des "
          "légumes sautés.",
      ingredients: [
        'Attiéké',
        'Poisson',
        'Oignons',
        'Tomates',
        'Piment',
      ],
    ),
    const Recipe(
      id: 'r10',
      title: 'Smoothie mangue',
      category: 'Boisson',
      difficulty: 'Facile',
      durationMinutes: 10,
      servings: 2,
      rating: 4.3,
      emoji: '🥭',
      description:
          "Smoothie onctueux à la mangue fraîche, glacé et légèrement "
          "sucré.",
      ingredients: [
        '2 mangues',
        'Lait ou yaourt',
        'Glaçons',
        'Miel (optionnel)',
      ],
    ),
  ];

  List<Recipe> get all => List.unmodifiable(_recipes);

  List<String> get categories {
    final set = _recipes.map((r) => r.category).toSet().toList();
    set.sort();
    return set;
  }

  Recipe? findById(String id) {
    for (final r in _recipes) {
      if (r.id == id) return r;
    }
    return null;
  }

  void addRecipe(Recipe recipe) {
    _recipes.insert(0, recipe);
    notifyListeners();
  }

  /// Remplace une recette existante (même [Recipe.id]) par sa version
  /// modifiée. Ne fait rien si l'identifiant n'existe pas.
  void updateRecipe(Recipe updated) {
    final index = _recipes.indexWhere((r) => r.id == updated.id);
    if (index == -1) return;
    _recipes[index] = updated;
    notifyListeners();
  }

  /// Supprime une recette. Utilisé par le swipe-to-delete de la liste
  /// et par le bouton de suppression de l'écran de détail.
  void deleteRecipe(String id) {
    _recipes.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
