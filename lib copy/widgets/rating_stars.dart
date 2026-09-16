import 'package:flutter/material.dart';

/// Widget réutilisable : affiche une note sous forme d'étoiles.
///
/// Ne dépend d'aucune donnée codée en dur : la note est toujours
/// reçue en paramètre par celui qui l'utilise.
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < fullStars
                ? Icons.star_rounded
                : (i == fullStars && hasHalfStar)
                    ? Icons.star_half_rounded
                    : Icons.star_border_rounded,
            size: size,
            color: Colors.amber,
          ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size * 0.75, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
