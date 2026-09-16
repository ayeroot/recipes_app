import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipes_app/main.dart';
import 'package:recipes_app/data/recipe_repository.dart';
import 'package:recipes_app/widgets/recipe_card.dart';

void main() {
  // Les écrans s'adaptent à la largeur (mobile / tablette / desktop).
  // On fixe une taille "téléphone" déterministe avant chaque test pour
  // que le rendu soit prévisible (liste verticale + NavigationBar), et
  // on la réinitialise après.
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

    // La barre de recherche est présente.
    expect(find.byType(TextField), findsOneWidget);

    // Au moins une carte de recette est affichée.
    expect(find.byType(RecipeCard), findsWidgets);

    // La barre de navigation propose bien les 3 sections principales.
    expect(find.text('Recettes'), findsWidgets);
    expect(find.text('Favoris'), findsWidgets);
    expect(find.text('Réglages'), findsWidgets);
  });

  testWidgets('La recherche filtre correctement la liste des recettes',
      (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const RecipesApp());
    await tester.pumpAndSettle();

    // Un mot-clé qui ne correspond à aucune recette -> état vide.
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

    // On filtre d'abord par le titre pour garantir que la carte visée
    // est bien construite et visible (la liste est paresseuse).
    await tester.enterText(find.byType(TextField), firstRecipe.title);
    await tester.pumpAndSettle();

    // widgetWithText cible la carte (et non le texte saisi dans le champ
    // de recherche, qui contient aussi le titre).
    await tester.tap(find.widgetWithText(RecipeCard, firstRecipe.title));
    await tester.pumpAndSettle();

    // La description de la recette est affichée sur l'écran de détail.
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
    // 4 champs de formulaire : titre, durée, personnes, description.
    expect(find.byType(TextFormField), findsNWidgets(4));
  });
}
