import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'rating_stars.dart';

/// Widget réutilisable : carte représentant une recette dans une liste
/// ou une grille (écran d'accueil et écran des favoris).
///
/// Toutes les données affichées proviennent du paramètre [recipe] :
/// aucune valeur n'est codée en dur dans ce widget.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  color: theme.colorScheme.primaryContainer,
                  alignment: Alignment.center,
                  child: Text(recipe.emoji, style: const TextStyle(fontSize: 48)),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.redAccent : Colors.white,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 8,
                  child: Chip(
                    label: Text(recipe.category, style: const TextStyle(fontSize: 11)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14),
                      const SizedBox(width: 4),
                      Text('${recipe.durationMinutes} min', style: theme.textTheme.bodySmall),
                      const SizedBox(width: 12),
                      const Icon(Icons.people_outline, size: 14),
                      const SizedBox(width: 4),
                      Text('${recipe.servings}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RatingStars(rating: recipe.rating, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
