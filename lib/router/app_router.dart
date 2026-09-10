import 'package:go_router/go_router.dart';
import '../screens/main_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/add_recipe_screen.dart';

/// Configuration centrale de la navigation avec GoRouter.
///
/// Toutes les routes sont nommées (name: ...) afin de pouvoir naviguer
/// avec `context.pushNamed('detail', pathParameters: {...})` plutôt
/// qu'avec des chemins écrits en dur dans chaque écran.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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
      builder: (context, state) => const AddRecipeScreen(),
    ),
  ],
);
