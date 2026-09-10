import 'package:flutter/material.dart';
import '../data/recipe_repository.dart';
import '../data/favorites_controller.dart';
import '../widgets/rating_stars.dart';

/// Écran de détail d'une recette.
///
/// Reçoit uniquement un [recipeId] (paramètre de route transmis par
/// GoRouter) et va chercher les données correspondantes dans le
/// [RecipeRepository] : aucune donnée n'est passée ou codée en dur
/// directement dans le widget.
class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    FavoritesController.instance.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    FavoritesController.instance.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = RecipeRepository.instance.findById(widget.recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Recette introuvable.')),
      );
    }

    final isFav = FavoritesController.instance.isFavorite(recipe.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : null,
                ),
                onPressed: () => FavoritesController.instance.toggle(recipe.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(recipe.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Theme.of(context).colorScheme.primaryContainer),
                  Center(child: Text(recipe.emoji, style: const TextStyle(fontSize: 96))),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.45)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.category_outlined, size: 18),
                      label: Text(recipe.category),
                    ),
                    Chip(
                      avatar: const Icon(Icons.speed_outlined, size: 18),
                      label: Text(recipe.difficulty),
                    ),
                    Chip(
                      avatar: const Icon(Icons.timer_outlined, size: 18),
                      label: Text('${recipe.durationMinutes} min'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.people_outline, size: 18),
                      label: Text('${recipe.servings} pers.'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RatingStars(rating: recipe.rating, size: 20),
                const SizedBox(height: 20),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(recipe.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Text(
                  'Ingrédients',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      for (final ing in recipe.ingredients)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.circle, size: 8),
                          title: Text(ing),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
