import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';

/// [FinancialCriticalBanner] is displayed when inconsistencies are detected in
/// the financial data that may affect the accuracy of the net income report.
class FinancialCriticalBanner extends StatelessWidget {
  final DreMetadataEntity metadata;

  const FinancialCriticalBanner({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[600],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.triangleAlert, color: Colors.white, size: 20)
                .animate(onPlay: (controller) => controller.repeat())
                .shake(duration: 1000.ms),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INCONSISTÊNCIAS DETECTADAS',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Seu lucro pode estar incorreto. ${metadata.inconsistentCount} registros precisam de revisão.',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: Colors.white, size: 20),
        ],
      ),
    ).animate().shake();
  }
}
