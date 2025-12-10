import 'package:flutter/material.dart';

class HomeMenu {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool selected;
  final bool enabled;

  HomeMenu({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.selected = false,
    this.enabled = true,
  });
}

