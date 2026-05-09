import 'package:flutter/material.dart';

/// A reusable glassmorphic card container.
///
/// It provides a semi-transparent white background with a subtle border,
/// creating a "glass" effect suitable for the dashboard's aesthetic.
class DashboardGlassCard extends StatelessWidget {
  final Widget child;
  const DashboardGlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }
}
