import 'package:flutter/material.dart';

/// Contrôleur global du thème (clair / sombre / système).
///
/// Utilise [ChangeNotifier] plutôt qu'un package de state management
/// externe, afin de garder le projet simple à installer et à lire.
class ThemeController extends ChangeNotifier {
  ThemeController._internal();
  static final ThemeController instance = ThemeController._internal();

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }
}
