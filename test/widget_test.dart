import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipes_app/main.dart';
import 'package:recipes_app/data/recipe_repository.dart';

void main() {
  testWidgets("L'écran d'accueil affiche la barre de recherche et des recettes", (tester) async {
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    // La barre de recherche est présente.
    expect(find.byType(TextField), findsOneWidget);

    // Au moins une recette du jeu de données initial est visible.
    final firstTitle = RecipeRepository.instance.all.first.title;
    expect(find.text(firstTitle), findsWidgets);

    // La barre de navigation propose bien les 3 sections principales.
    expect(find.text('Recettes'), findsWidgets);
    expect(find.text('Favoris'), findsWidgets);
    expect(find.text('Réglages'), findsWidgets);
  });

  testWidgets('La recherche filtre correctement la liste des recettes', (tester) async {
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    // Recherche d'un mot-clé qui ne correspond à aucune recette.
    await tester.enterText(find.byType(TextField), 'xyzabc_introuvable');
    await tester.pumpAndSettle();

    expect(find.text('Aucune recette ne correspond à votre recherche.'), findsOneWidget);
  });

  testWidgets("Toucher une recette ouvre l'écran de détail avec ses informations", (tester) async {
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    final firstRecipe = RecipeRepository.instance.all.first;
    await tester.tap(find.text(firstRecipe.title).first);
    await tester.pumpAndSettle();

    // La description de la recette est bien affichée sur l'écran de détail.
    expect(find.text(firstRecipe.description), findsOneWidget);
  });
}
