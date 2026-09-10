import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_repository.dart';
import '../data/favorites_controller.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/empty_state.dart';

/// Écran de liste : recherche + filtrage par catégorie.
///
/// S'adapte à la largeur disponible (mobile -> liste verticale,
/// tablette -> grille de 2 ou 3 colonnes) grâce à [LayoutBuilder].
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Toutes';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    RecipeRepository.instance.addListener(_onDataChanged);
    FavoritesController.instance.addListener(_onDataChanged);
  }

  void _onDataChanged() => setState(() {});

  @override
  void dispose() {
    _searchController.dispose();
    RecipeRepository.instance.removeListener(_onDataChanged);
    FavoritesController.instance.removeListener(_onDataChanged);
    super.dispose();
  }

  List<Recipe> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return RecipeRepository.instance.all.where((r) {
      final matchesQuery = query.isEmpty || r.title.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'Toutes' || r.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('Mes recettes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add'),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchFilterBar(
              controller: _searchController,
              categories: RecipeRepository.instance.categories,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: recipes.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off,
                      message: 'Aucune recette ne correspond à votre recherche.',
                    )
                  : LayoutBuilder(
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
                            itemBuilder: (context, index) => _buildCard(recipes[index]),
                          );
                        }
                        return ListView.separated(
                          itemCount: recipes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) => _buildCard(recipes[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Recipe recipe) {
    return RecipeCard(
      recipe: recipe,
      isFavorite: FavoritesController.instance.isFavorite(recipe.id),
      onTap: () => context.pushNamed('detail', pathParameters: {'id': recipe.id}),
      onFavoriteToggle: () => FavoritesController.instance.toggle(recipe.id),
    );
  }
}
