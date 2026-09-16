import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipes_app/main.dart';
import 'package:recipes_app/data/recipe_repository.dart';
import 'package:recipes_app/router/app_router.dart';
import 'package:recipes_app/widgets/recipe_card.dart';

void main() {
  // Le routeur GoRouter est global : on le ramène à l'accueil avant
  // chaque test pour que les tests soient indépendants de leur ordre.
  setUp(() => appRouter.go('/'));

  // Les écrans s'adaptent à la largeur (mobile / tablette / desktop).
  // On fixe une taille "téléphone" déterministe avant chaque test pour
  // que le rendu soit prévisible (liste verticale + NavigationBar).
  void usePhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets("L'écran d'accueil affiche la barre de recherche et des recettes",
      (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(RecipeCard), findsWidgets);
    expect(find.text('Recettes'), findsWidgets);
    expect(find.text('Favoris'), findsWidgets);
    expect(find.text('Réglages'), findsWidgets);
  });

  testWidgets('La recherche filtre correctement la liste des recettes',
      (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'xyzabc_introuvable');
    await tester.pumpAndSettle();

    expect(
      find.text('Aucune recette ne correspond à votre recherche.'),
      findsOneWidget,
    );
    expect(find.byType(RecipeCard), findsNothing);
  });

  testWidgets("Toucher une recette ouvre l'écran de détail avec ses infos",
      (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    final firstRecipe = RecipeRepository.instance.all.first;

    // On filtre par le titre pour garantir que la carte visée est bien
    // construite et visible (la liste est paresseuse).
    await tester.enterText(find.byType(TextField), firstRecipe.title);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(RecipeCard, firstRecipe.title));
    await tester.pumpAndSettle();

    expect(find.text(firstRecipe.description), findsOneWidget);
  });

  testWidgets('Le bouton "Ajouter" ouvre le formulaire de nouvelle recette',
      (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    expect(find.text('Nouvelle recette'), findsOneWidget);
    // 4 champs texte validés : titre, durée, personnes, description.
    expect(find.byType(TextFormField), findsNWidgets(4));
  });
}
