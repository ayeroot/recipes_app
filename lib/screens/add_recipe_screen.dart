import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';

/// Formulaire d'ajout d'une nouvelle recette.
///
/// Contient 6 champs, dont 4 validés (titre, durée, personnes,
/// description) via [FormState.validate]. À la soumission, la
/// nouvelle recette est envoyée au [RecipeRepository] puis l'écran
/// se ferme automatiquement.
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _servingsController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = 'Plat';
  String _difficulty = 'Facile';

  static const _categories = ['Entrée', 'Plat', 'Dessert', 'Boisson'];
  static const _difficulties = ['Facile', 'Moyen', 'Difficile'];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _servingsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final recipe = Recipe(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      category: _category,
      difficulty: _difficulty,
      durationMinutes: int.parse(_durationController.text.trim()),
      servings: int.parse(_servingsController.text.trim()),
      rating: 0,
      emoji: '🍽️',
      description: _descriptionController.text.trim(),
      ingredients: const [],
    );

    RecipeRepository.instance.addRecipe(recipe);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${recipe.title}" a été ajoutée avec succès !')),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle recette')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de la recette',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Le titre est obligatoire.';
                if (value.trim().length < 3) return 'Le titre doit contenir au moins 3 caractères.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Durée (min)',
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Requis';
                      final n = int.tryParse(value.trim());
                      if (n == null || n <= 0) return 'Nombre invalide';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Personnes',
                      prefixIcon: Icon(Icons.people_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Requis';
                      final n = int.tryParse(value.trim());
                      if (n == null || n <= 0) return 'Nombre invalide';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _difficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulté',
                prefixIcon: Icon(Icons.speed_outlined),
              ),
              items: _difficulties.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _difficulty = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'La description est obligatoire.';
                if (value.trim().length < 10) return 'Décrivez la recette en au moins 10 caractères.';
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Enregistrer la recette'),
            ),
          ],
        ),
      ),
    );
  }
}
