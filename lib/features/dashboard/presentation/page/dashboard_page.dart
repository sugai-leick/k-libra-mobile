import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/dashboard/kpi_card.dart';
import 'package:flutter_app/features/clients/presentation/widgets/clients_count_card.dart';
import 'package:flutter_app/features/sales/presentation/widgets/sales_count_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Profile / Notification area
                        Row(
                          children: [
                            _IconButton(icon: Icons.notifications_active_rounded, onTap: () {}),
                            const SizedBox(width: 8),
                            _IconButton(
                              icon: Icons.settings_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Visão geral do Instituto e K-Libra System.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── KPI Cards ──
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.55,
                ),
                delegate: SliverChildListDelegate(_buildKpiCards()),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Insights de Negócio ──
            SliverToBoxAdapter(
              child:
                  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _GlassCard(
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
                              // Grid 2x2 of insight cards
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.4,
                                children: const [
                                  _InsightTile(
                                    emoji: '🏆',
                                    title: 'MAIOR COMPRADOR',
                                    value: 'Carlos Silva',
                                    subtitle: 'R\$ 12.500,00',
                                    color: AppColors.accentPurple,
                                  ),
                                  _InsightTile(
                                    emoji: '💳',
                                    title: 'FORMA MAIS USADA',
                                    value: 'PIX',
                                    subtitle: '23 pagamentos',
                                    color: Color(0xFFD946EF), // fuchsia
                                  ),
                                  _InsightTile(
                                    emoji: '📦',
                                    title: 'TICKET MÉDIO',
                                    value: 'R\$ 2.350,00',
                                    subtitle: 'por venda',
                                    color: Color(0xFF8B5CF6), // violet
                                  ),
                                  _InsightTile(
                                    emoji: '🎯',
                                    title: 'TAXA DE CONVERSÃO',
                                    value: '42%',
                                    subtitle: 'Lead → Cliente K-Libra',
                                    color: Color(0xFFEC4899), // pink
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .scale(begin: const Offset(0.97, 0.97)),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Funil de Conversão ──
            SliverToBoxAdapter(
              child:
                  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _GlassCard(
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
                              const _FunnelBar(
                                label: 'Alunos + Clientes',
                                pct: 100,
                                color: Color(0xFFD946EF),
                              ),
                              const SizedBox(height: 16),
                              const _FunnelBar(
                                label: 'Clientes K-Libra',
                                pct: 58,
                                color: AppColors.accentPurple,
                              ),
                              const SizedBox(height: 16),
                              const _FunnelBar(
                                label: 'Clientes K-Libra Recorrente',
                                pct: 22,
                                color: Color(0xFF4338CA),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .scale(begin: const Offset(0.97, 0.97)),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildKpiCards() {
    final cards = [
      // Feature Client
      const ClientsCountCard()
          .animate()
          .fadeIn(duration: 500.ms)
          .moveX(begin: -30, end: 0),

      // Feature Vendas
      const SalesCountCard()
          .animate()
          .fadeIn(duration: 500.ms)
          .moveX(begin: 30, end: 0),

      // Placeholder Receita
      const KpiCard(
        label: 'Receita Líquida',
        value: 'R\$ 42.300',
        icon: Icons.attach_money_rounded,
        color: Color(0xFF8B5CF6),
      ),

      // Placeholder Saldo
      const KpiCard(
        label: 'Saldo Financeiro',
        value: 'R\$ 28.750',
        icon: Icons.trending_up_rounded,
        color: AppColors.success,
      ),

      // Placeholder Pendentes
      const KpiCard(
        label: 'Pgtos Pendentes',
        value: '5 (R\$ 4.200)',
        icon: Icons.credit_card_rounded,
        color: Color(0xFFF59E0B),
      ),

      // Placeholder Cursos
      const KpiCard(
        label: 'Cursos Ativos',
        value: '—',
        icon: LucideIcons.activity,
        color: Color(0xFFEC4899),
      ),
    ];

    return cards.asMap().entries.map((entry) {
      final i = entry.key;
      final cardWidget = entry.value;
      return cardWidget
          .animate()
          .fadeIn(delay: (80 * i).ms, duration: 400.ms)
          .moveY(begin: 20, end: 0, duration: 400.ms);
    }).toList();
  }
}

// ─── Glass Card Container ─────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

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

// ─── Insight Tile ─────────────────────────────────────────────

class _InsightTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _InsightTile({
    required this.emoji,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$emoji $title',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.8,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Funnel Progress Bar ──────────────────────────────────────

class _FunnelBar extends StatelessWidget {
  final String label;
  final int pct;
  final Color color;

  const _FunnelBar({
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

// ─── Small Icon Button ────────────────────────────────────────

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap});

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
