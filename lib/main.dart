import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'data/favorites_controller.dart';

Future<void> main() async {
  // Nécessaire pour pouvoir utiliser des plugins (shared_preferences)
  // avant l'appel à runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Recharge le thème et les favoris précédemment enregistrés sur
  // l'appareil, afin que l'utilisateur retrouve ses préférences après
  // avoir fermé l'application.
  await ThemeController.instance.init();
  await FavoritesController.instance.init();

  runApp(const RecipesApp());
}

/// Racine de l'application.
///
/// Écoute le [ThemeController] pour reconstruire le [MaterialApp]
/// avec le bon `themeMode` (clair / sombre / système) et délègue
/// toute la navigation à [appRouter] (GoRouter).
class RecipesApp extends StatefulWidget {
  const RecipesApp({super.key});

  @override
  State<RecipesApp> createState() => _RecipesAppState();
}

class _RecipesAppState extends State<RecipesApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.addListener(_onThemeChanged);
  }

  void _onThemeChanged() => setState(() {});

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App Recettes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeController.instance.mode,
      routerConfig: appRouter,
    );
  }
}
