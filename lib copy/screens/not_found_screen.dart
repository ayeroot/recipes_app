import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Écran affiché par GoRouter (`errorBuilder`) lorsqu'une route ne
/// correspond à rien — par exemple une recette dont l'identifiant a
/// été supprimé, ou un lien direct invalide.
class NotFoundScreen extends StatelessWidget {
  final String location;
  const NotFoundScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page introuvable')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(
                "Aucun écran ne correspond à « $location ».",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.goNamed('home'),
                icon: const Icon(Icons.home_outlined),
                label: const Text("Retour à l'accueil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
