import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../screens/main_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/recipe_form_screen.dart';
import '../screens/not_found_screen.dart';

/// Configuration centrale de la navigation avec GoRouter.
///
/// Toutes les routes sont nommées (name: ...) afin de pouvoir naviguer
/// avec `context.pushNamed('detail', pathParameters: {...})` plutôt
/// qu'avec des chemins écrits en dur dans chaque écran.
///
/// La route `/add` sert à la fois pour l'ajout et l'édition : quand
/// une [Recipe] est transmise via `extra`, le formulaire bascule en
/// mode édition (voir [RecipeFormScreen]).
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => NotFoundScreen(location: state.uri.toString()),
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/recipe/:id',
      name: 'detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RecipeDetailScreen(recipeId: id);
      },
    ),
    GoRoute(
      path: '/add',
      name: 'add',
      builder: (context, state) {
        final existing = state.extra as Recipe?;
        return RecipeFormScreen(existing: existing);
      },
    ),
  ],
);
