import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_repository.dart';
import '../data/favorites_controller.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/empty_state.dart';

/// Tri disponible sur l'écran d'accueil.
enum _SortOption { name, duration, rating }

/// Écran de liste : recherche + filtrage par catégorie + tri.
///
/// S'adapte à la largeur disponible (mobile -> liste verticale,
/// tablette -> grille de 2 ou 3 colonnes) grâce à [LayoutBuilder].
/// Chaque carte peut être supprimée par glissement (swipe), avec une
/// option "Annuler" via SnackBar.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Toutes';
  _SortOption _sortBy = _SortOption.name;

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
    final list = RecipeRepository.instance.all.where((r) {
      final matchesQuery = query.isEmpty || r.title.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'Toutes' || r.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    switch (_sortBy) {
      case _SortOption.name:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case _SortOption.duration:
        list.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
      case _SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }

  void _deleteRecipe(Recipe recipe) {
    RecipeRepository.instance.deleteRecipe(recipe.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${recipe.title}" supprimée.'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () => RecipeRepository.instance.addRecipe(recipe),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes recettes'),
        actions: [
          PopupMenuButton<_SortOption>(
            tooltip: 'Trier',
            icon: const Icon(Icons.sort),
            initialValue: _sortBy,
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: _SortOption.name, child: Text('Trier par nom')),
              PopupMenuItem(value: _SortOption.duration, child: Text('Trier par durée')),
              PopupMenuItem(value: _SortOption.rating, child: Text('Trier par note')),
            ],
          ),
        ],
      ),
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
                            itemBuilder: (context, index) => _buildDismissibleCard(recipes[index]),
                          );
                        }
                        return ListView.separated(
                          itemCount: recipes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) => _buildDismissibleCard(recipes[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleCard(Recipe recipe) {
    return Dismissible(
      key: ValueKey(recipe.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => _deleteRecipe(recipe),
      child: RecipeCard(
        recipe: recipe,
        isFavorite: FavoritesController.instance.isFavorite(recipe.id),
        onTap: () => context.pushNamed('detail', pathParameters: {'id': recipe.id}),
        onFavoriteToggle: () => FavoritesController.instance.toggle(recipe.id),
      ),
    );
  }
}
