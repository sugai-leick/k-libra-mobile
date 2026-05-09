import 'package:flutter/material.dart';

/// A customized icon button for the dashboard header.
///
/// Features a semi-transparent background and a thin border to match
/// the glassmorphic theme.
class DashboardIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const DashboardIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.6)),
      ),
    );
  }
}
