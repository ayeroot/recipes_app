import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';

/// Formulaire d'ajout ou de modification d'une recette.
///
/// Un seul écran gère les deux cas : si [existing] est fourni (passé
/// via `extra` par GoRouter), le formulaire se pré-remplit et bascule
/// en mode édition ; sinon il crée une nouvelle recette.
///
/// Contient 6 champs, dont 4 validés (titre, durée, personnes,
/// description) via [FormState.validate].
class RecipeFormScreen extends StatefulWidget {
  final Recipe? existing;
  const RecipeFormScreen({super.key, this.existing});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _servingsController;
  late final TextEditingController _descriptionController;

  late String _category;
  late String _difficulty;

  static const _categories = ['Entrée', 'Plat', 'Dessert', 'Boisson'];
  static const _difficulties = ['Facile', 'Moyen', 'Difficile'];

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _durationController = TextEditingController(text: existing?.durationMinutes.toString() ?? '');
    _servingsController = TextEditingController(text: existing?.servings.toString() ?? '');
    _descriptionController = TextEditingController(text: existing?.description ?? '');
    _category = existing?.category ?? _categories.first;
    _difficulty = existing?.difficulty ?? _difficulties.first;
  }

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
      id: _isEditing ? widget.existing!.id : 'r${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      category: _category,
      difficulty: _difficulty,
      durationMinutes: int.parse(_durationController.text.trim()),
      servings: int.parse(_servingsController.text.trim()),
      // La note et les ingrédients d'une recette existante sont
      // conservés tels quels : ce formulaire ne les modifie pas.
      rating: _isEditing ? widget.existing!.rating : 0,
      emoji: _isEditing ? widget.existing!.emoji : '🍽️',
      description: _descriptionController.text.trim(),
      ingredients: _isEditing ? widget.existing!.ingredients : const [],
    );

    if (_isEditing) {
      RecipeRepository.instance.updateRecipe(recipe);
    } else {
      RecipeRepository.instance.addRecipe(recipe);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? '"${recipe.title}" a été mise à jour.'
              : '"${recipe.title}" a été ajoutée avec succès !',
        ),
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Modifier la recette' : 'Nouvelle recette')),
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
              icon: Icon(_isEditing ? Icons.save_outlined : Icons.check),
              label: Text(_isEditing ? 'Enregistrer les modifications' : 'Enregistrer la recette'),
            ),
          ],
        ),
      ),
    );
  }
}
