import 'package:flutter/material.dart';
import 'category_chip.dart';

/// Widget réutilisable : barre de recherche + filtres par catégorie.
///
/// Ne contient aucune donnée en dur : la liste des catégories, la
/// catégorie sélectionnée et le contrôleur de texte sont tous fournis
/// par l'écran parent.
class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final String hintText;

  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.hintText = 'Rechercher une recette...',
  });

  @override
  Widget build(BuildContext context) {
    final allCategories = ['Toutes', ...categories];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clear,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final cat = allCategories[index];
              return CategoryChip(
                label: cat,
                selected: selectedCategory == cat,
                onTap: () => onCategoryChanged(cat),
              );
            },
          ),
        ),
      ],
    );
  }
}
