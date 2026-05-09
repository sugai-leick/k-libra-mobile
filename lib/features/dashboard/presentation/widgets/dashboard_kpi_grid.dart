import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/dashboard/kpi_card.dart';
import 'package:flutter_app/features/clients/presentation/widgets/clients_count_card.dart';
import 'package:flutter_app/features/sales/presentation/widgets/sales_count_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A grid of KPI (Key Performance Indicator) cards.
///
/// This widget handles the layout and sequential entrance animation for
/// various performance metrics such as Clients Count, Sales, and Revenue.
class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
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
    );
  }

  List<Widget> _buildKpiCards() {
    final cards = [
      const ClientsCountCard(),
      const SalesCountCard(),
      const KpiCard(
        label: 'Receita Líquida',
        value: 'R\$ 42.300',
        icon: Icons.attach_money_rounded,
        color: Color(0xFF8B5CF6),
      ),
      const KpiCard(
        label: 'Saldo Financeiro',
        value: 'R\$ 28.750',
        icon: Icons.trending_up_rounded,
        color: AppColors.success,
      ),
      const KpiCard(
        label: 'Pgtos Pendentes',
        value: '5 (R\$ 4.200)',
        icon: Icons.credit_card_rounded,
        color: Color(0xFFF59E0B),
      ),
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
