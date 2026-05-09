import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// A horizontal progress bar representing a stage in the conversion funnel.
///
/// It displays a [label], the percentage [pct], and animates the bar
/// fill from left to right.
class DashboardFunnelBar extends StatelessWidget {
  final String label;
  final int pct;
  final Color color;

  const DashboardFunnelBar({
   super.key,
    required this.label,
    required this.pct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$pct%',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: Stack(
              children: [
                // Track
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: 0, // starts at 0, animated below
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ).animate().custom(
                  duration: 800.ms,
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return FractionallySizedBox(
                      widthFactor: (pct / 100) * value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
