import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'dashboard_glass_card.dart';
import 'dashboard_insight_tile.dart';

/// A section containing business insights displayed in a [DashboardGlassCard].
///
/// It features a grid of [DashboardInsightTile]s showing data like top buyers
/// and conversion rates.
class DashboardInsightsSection extends StatelessWidget {
  const DashboardInsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: DashboardGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📊 Insights de Negócio',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
                children: const [
                  DashboardInsightTile(
                    emoji: '🏆',
                    title: 'MAIOR COMPRADOR',
                    value: 'Carlos Silva',
                    subtitle: 'R\$ 12.500,00',
                    color: AppColors.accentPurple,
                  ),
                  DashboardInsightTile(
                    emoji: '💳',
                    title: 'FORMA MAIS USADA',
                    value: 'PIX',
                    subtitle: '23 pagamentos',
                    color: Color(0xFFD946EF),
                  ),
                  DashboardInsightTile(
                    emoji: '📦',
                    title: 'TICKET MÉDIO',
                    value: 'R\$ 2.350,00',
                    subtitle: 'por venda',
                    color: Color(0xFF8B5CF6),
                  ),
                  DashboardInsightTile(
                    emoji: '🎯',
                    title: 'TAXA DE CONVERSÃO',
                    value: '42%',
                    subtitle: 'Lead → Cliente K-Libra',
                    color: Color(0xFFEC4899),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.97, 0.97)),
    );
  }
}
