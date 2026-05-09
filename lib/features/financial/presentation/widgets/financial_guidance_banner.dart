import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';

/// [FinancialGuidanceBanner] is displayed when data exists in the database,
/// but there is no data for the currently selected period. It provides options
/// to jump to the latest available data or view the full period.
class FinancialGuidanceBanner extends StatelessWidget {
  final String from;
  final DreMetadataEntity metadata;
  final Function(String from, String to) onJump;

  const FinancialGuidanceBanner({
    super.key,
    required this.from,
    required this.metadata,
    required this.onJump,
  });

  @override
  Widget build(BuildContext context) {
    String capitalizedMonth = 'ESTE PERÍODO';
    try {
      final date = DateTime.parse('${from}T12:00:00');
      final formattedMonth = DateFormat('MMMM', 'pt_BR').format(date);
      if (formattedMonth.isNotEmpty) {
        capitalizedMonth = formattedMonth[0].toUpperCase() + formattedMonth.substring(1);
      }
    } catch (_) {
      // Fallback if parsing or locale fails
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.calendar, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.circleAlert, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'NENHUM DADO EM $capitalizedMonth',
                          style: GoogleFonts.inter(
                            color: Colors.amber,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Encontramos ${metadata.dbTotalCount} transações em outros períodos.',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (metadata.dataHorizon != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      try {
                        final latest = DateTime.parse('${metadata.dataHorizon!.max}T12:00:00');
                        final jumpFrom = DateTime(latest.year, latest.month, 1);
                        final jumpTo = DateTime(latest.year, latest.month + 1, 0);
                        onJump(
                          DateFormat('yyyy-MM-dd').format(jumpFrom),
                          DateFormat('yyyy-MM-dd').format(jumpTo),
                        );
                      } catch (_) {}
                    },
                    icon: const Icon(LucideIcons.mousePointer2, size: 14),
                    label: const Text('IR PARA ÚLTIMO DADO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onJump(metadata.dataHorizon!.min, metadata.dataHorizon!.max),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.amber.withValues(alpha: 0.5)),
                      foregroundColor: Colors.amber,
                      textStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('VER PERÍODO COMPLETO'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn().moveY(begin: 10, end: 0);
  }
}
