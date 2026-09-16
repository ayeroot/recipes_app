/// Modèle de données représentant une recette.
///
/// Cette classe ne contient aucune logique d'affichage : elle sert
/// uniquement à transporter les données entre la couche "data" et
/// les écrans / widgets (séparation UI / données).
class Recipe {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final int durationMinutes;
  final int servings;
  final double rating;
  final String emoji;
  final String description;
  final List<String> ingredients;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.servings,
    required this.rating,
    required this.emoji,
    required this.description,
    required this.ingredients,
  });
}
