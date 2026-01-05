import 'package:flutter/material.dart';

class HomeMenu {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool selected;
  final bool enabled;
  final bool? _isLoading;

  HomeMenu({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.selected = false,
    this.enabled = true,
    bool? isLoading,
  }) : _isLoading = isLoading ?? false;

  bool get isLoading => _isLoading ?? false;
}

