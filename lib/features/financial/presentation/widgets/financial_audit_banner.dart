import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';
import 'package:flutter_app/core/theme/app_colors.dart';

/// [FinancialAuditBanner] is displayed when the data quality is healthy or moderate.
/// It shows the current data quality score and potential risk impact.
class FinancialAuditBanner extends StatelessWidget {
  final DreMetadataEntity metadata;

  const FinancialAuditBanner({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final isHigh = metadata.dataQualityScore >= 0.95;
    final statusColor = isHigh ? AppColors.success : Colors.amber;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isHigh ? LucideIcons.circleCheck : LucideIcons.triangleAlert,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUALIDADE DE DADOS: ${(metadata.dataQualityScore * 100).round()}% (${metadata.qualityLevel})',
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metadata.riskImpact,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}
