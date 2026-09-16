import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';

/// Écran de réglages : permet de choisir le thème clair, sombre ou
/// "système" (suit les préférences de l'appareil).
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ThemeController.instance.mode;

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Apparence', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<ThemeMode>(
              groupValue: mode,
              onChanged: (v) {
                if (v != null) ThemeController.instance.setMode(v);
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text('Clair'),
                    secondary: Icon(Icons.light_mode_outlined),
                    value: ThemeMode.light,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text('Sombre'),
                    secondary: Icon(Icons.dark_mode_outlined),
                    value: ThemeMode.dark,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text('Système'),
                    secondary: Icon(Icons.settings_suggest_outlined),
                    value: ThemeMode.system,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('À propos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App Recettes'),
              subtitle: Text(
                'Projet Flutter de démonstration — navigation, formulaires et thèmes.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
