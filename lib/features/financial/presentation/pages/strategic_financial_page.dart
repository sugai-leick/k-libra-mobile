import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_app/core/widgets/shared/stat_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StrategicFinancialPage extends StatelessWidget {
  const StrategicFinancialPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock DRE Data
    final dreRows = [
      {'label': 'Receita Bruta', 'value': 285400.0, 'isHeader': true},
      {'label': '(-) Impostos e Devoluções', 'value': -42810.0, 'isHeader': false},
      {'label': 'Receita Líquida', 'value': 242590.0, 'isDivider': true},
      {'label': '(-) Custos (CPV/CSP)', 'value': -98600.0, 'isHeader': false},
      {'label': 'Margem de Contribuição', 'value': 143990.0, 'isDivider': true},
      {'label': '(-) Despesas Fixas', 'value': -85000.0, 'isHeader': false},
      {'label': 'EBITDA (LAJIDA)', 'value': 58990.0, 'isHeader': true, 'color': AppColors.success},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Finanças Estratégicas',
            subtitle: 'Demonstrativo de Resultados (DRE) e análise de margem.',
            buttonLabel: 'Exportar PDF',
            buttonIcon: Icons.picture_as_pdf_rounded,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Margem Líquida',
                    value: '20.6%',
                    icon: Icons.percent_rounded,
                    trend: '+2.1%',
                    positive: true,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'Ponto de Equilíbrio',
                    value: 'R\$ 168k',
                    icon: Icons.track_changes_rounded,
                    color: AppColors.accentPurple,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DRE DETALHADO — MARÇO 2024',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withValues(alpha: 0.3),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...dreRows.map((row) {
                    final bool isHeader = row['isHeader'] as bool? ?? false;
                    final bool isDivider = row['isDivider'] as bool? ?? false;
                    final double value = row['value'] as double;
                    final Color? textColor = row['color'] as Color?;

                    if (isDivider) {
                      return Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                row['label'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              Text(
                                'R\$ ${value.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                        ],
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            row['label'] as String,
                            style: GoogleFonts.inter(
                              fontSize: isHeader ? 14 : 13,
                              fontWeight: isHeader ? FontWeight.w800 : FontWeight.w500,
                              color: isHeader ? Colors.white : Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            'R\$ ${value.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: isHeader ? 14 : 13,
                              fontWeight: isHeader ? FontWeight.w800 : FontWeight.w600,
                              color: textColor ?? (value < 0 ? Colors.redAccent.withValues(alpha: 0.8) : Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
