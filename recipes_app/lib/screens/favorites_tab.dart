import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_repository.dart';
import '../data/favorites_controller.dart';
import '../widgets/recipe_card.dart';
import '../widgets/empty_state.dart';

/// Écran listant uniquement les recettes marquées en favori.
///
/// Réutilise les mêmes widgets (RecipeCard, EmptyState) que l'écran
/// d'accueil, avec la même adaptation mobile / tablette.
class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  void initState() {
    super.initState();
    FavoritesController.instance.addListener(_onChanged);
    RecipeRepository.instance.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    FavoritesController.instance.removeListener(_onChanged);
    RecipeRepository.instance.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favIds = FavoritesController.instance.favoriteIds;
    final recipes = RecipeRepository.instance.all.where((r) => favIds.contains(r.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: recipes.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              message:
                  "Vous n'avez pas encore de recette favorite.\n"
                  "Appuyez sur le cœur d'une recette pour l'ajouter ici.",
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 600;
                  if (isTablet) {
                    return GridView.builder(
                      itemCount: recipes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth >= 900 ? 3 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) => _buildCard(context, recipes[index].id),
                    );
                  }
                  return ListView.separated(
                    itemCount: recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _buildCard(context, recipes[index].id),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCard(BuildContext context, String id) {
    final recipe = RecipeRepository.instance.findById(id)!;
    return RecipeCard(
      recipe: recipe,
      isFavorite: true,
      onTap: () => context.pushNamed('detail', pathParameters: {'id': recipe.id}),
      onFavoriteToggle: () => FavoritesController.instance.toggle(recipe.id),
    );
  }
}
