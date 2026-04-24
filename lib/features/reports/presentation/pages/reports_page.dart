import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reportCategories = [
      {
        'title': 'Comercial',
        'reports': ['Ranking de Clientes', 'Performance de Vendas', 'Funil de Conversão'],
        'icon': Icons.shopping_bag_rounded,
      },
      {
        'title': 'Financeiro',
        'reports': ['Fluxo de Caixa Mensal', 'DRE Expandido', 'Inadimplência'],
        'icon': Icons.attach_money_rounded,
      },
      {
        'title': 'Estoque',
        'reports': ['Giro de Estoque', 'Valuation de Inventário', 'Necessidade de Compra'],
        'icon': Icons.inventory_2_rounded,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Relatórios',
            subtitle: 'Central de exportação de dados e inteligência de negócio.',
            buttonLabel: 'Agendar',
            buttonIcon: Icons.calendar_today_rounded,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: reportCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final cat = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(cat['icon'] as IconData, color: AppColors.accentBlue, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            (cat['title'] as String).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (cat['reports'] as List).length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.5,
                        ),
                        itemBuilder: (context, rIdx) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.description_rounded, color: Colors.white24, size: 16),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    (cat['reports'] as List)[rIdx] as String,
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: (index * 200 + rIdx * 50).ms).scale(begin: const Offset(0.9, 0.9));
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
