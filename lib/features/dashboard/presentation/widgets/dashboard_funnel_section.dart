import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'dashboard_glass_card.dart';
import 'dashboard_funnel_bar.dart';

/// A section displaying the conversion funnel using [DashboardFunnelBar]s.
///
/// Encapsulated within a [DashboardGlassCard], it visualizes the progression
/// from leads to recurrent clients.
class DashboardFunnelSection extends StatelessWidget {
  const DashboardFunnelSection({super.key});

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
                'Funil de Conversão',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const DashboardFunnelBar(
                label: 'Alunos + Clientes',
                pct: 100,
                color: Color(0xFFD946EF),
              ),
              const SizedBox(height: 16),
              const DashboardFunnelBar(
                label: 'Clientes K-Libra',
                pct: 58,
                color: AppColors.accentPurple,
              ),
              const SizedBox(height: 16),
              const DashboardFunnelBar(
                label: 'Clientes K-Libra Recorrente',
                pct: 22,
                color: Color(0xFF4338CA),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.97, 0.97)),
    );
  }
}
