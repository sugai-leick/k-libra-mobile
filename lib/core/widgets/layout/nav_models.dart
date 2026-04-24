import 'package:flutter/widgets.dart';

class NavMenuItem {
  final IconData icon;
  final String label;
  final String? badge;

  const NavMenuItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

class NavGroup {
  final String groupName;
  final List<NavMenuItem> items;

  const NavGroup({
    required this.groupName,
    required this.items,
  });
}
