import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/core/widgets/layout/nav_models.dart';

class TopMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onPageSelected;

  TopMenu({
    super.key,
    required this.currentIndex,
    required this.onPageSelected,
  });

  final List<NavGroup> navigation = [
    const NavGroup(
      groupName: '',
      items: [
        NavMenuItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
      ],
    ),
    const NavGroup(
      groupName: 'Receita',
      items: [
        NavMenuItem(icon: Icons.shopping_cart_rounded, label: 'Vendas'),
      ],
    ),
    const NavGroup(
      groupName: 'Operação',
      items: [
        NavMenuItem(icon: Icons.people_alt_rounded, label: 'Contatos'),
        NavMenuItem(icon: Icons.inventory_2_rounded, label: 'Estoque'),
        NavMenuItem(icon: Icons.local_shipping_rounded, label: 'Envios'),
      ],
    ),
    const NavGroup(
      groupName: 'Financeiro',
      items: [
        NavMenuItem(icon: Icons.account_balance_wallet_rounded, label: 'Pagamentos'),
        NavMenuItem(icon: Icons.account_balance_rounded, label: 'Conciliação'),
      ],
    ),
    const NavGroup(
      groupName: 'Inteligência Financeira',
      items: [
        NavMenuItem(icon: Icons.bolt_rounded, label: 'Otimizações'),
        NavMenuItem(icon: Icons.notifications_active_rounded, label: 'Alertas'),
        NavMenuItem(icon: Icons.verified_user_rounded, label: 'Aprovações'),
        NavMenuItem(icon: Icons.trending_up_rounded, label: 'Finanças Estratégicas'),
        NavMenuItem(icon: Icons.bar_chart_rounded, label: 'Relatórios'),
        NavMenuItem(icon: Icons.track_changes_rounded, label: 'Metas & KPIs'),
        NavMenuItem(icon: Icons.psychology_rounded, label: 'Insights'),
      ],
    ),
    const NavGroup(
      groupName: 'Fiscal',
      items: [
        NavMenuItem(icon: Icons.description_rounded, label: 'Fiscal / NFe'),
      ],
    ),
    const NavGroup(
      groupName: 'Sistema',
      items: [
        NavMenuItem(icon: Icons.support_agent_rounded, label: 'Suporte'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int flatIndexOffset = 0;
    final List<DropdownMenuItem<int>> dropdownItems = [];

    for (var group in navigation) {
      if (group.groupName.isNotEmpty) {
        dropdownItems.add(
          DropdownMenuItem<int>(
            enabled: false,
            value: -1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                group.groupName.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accentBlue.withValues(alpha: 0.6), // 0.6
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        );
      }

      for (var i = 0; i < group.items.length; i++) {
        final currentFlatIdx = flatIndexOffset + i;
        final item = group.items[i];
        dropdownItems.add(
          DropdownMenuItem<int>(
            value: currentFlatIdx,
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: currentIndex == currentFlatIdx
                      ? AppColors.accentBlue
                      : Colors.white70,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: currentIndex == currentFlatIdx
                        ? AppColors.accentBlue
                        : Colors.white.withValues(alpha: 0.7), // 0.7
                    fontWeight: currentIndex == currentFlatIdx
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      flatIndexOffset += group.items.length;
    }

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)), // 0.08
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.balance_rounded,
                color: AppColors.accentBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'K-Libra',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ).animate().fadeIn(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05), // 0.05
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)), // 0.1
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: currentIndex,
                dropdownColor: AppColors.cardDark,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white38,
                  size: 16,
                ),
                items: dropdownItems,
                onChanged: (int? newIndex) {
                  if (newIndex != null && newIndex != -1) {
                    onPageSelected(newIndex);
                  }
                },
              ),
            ),
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),
        ],
      ),
    );
  }
}
