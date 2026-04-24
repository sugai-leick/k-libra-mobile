import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_app/core/widgets/shared/stat_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {'title': 'Recebimento Pix', 'desc': 'Venda #9923 - João Silva', 'value': 1200.0, 'isCredit': true, 'date': '14:20'},
      {'title': 'Pagamento Aluguel', 'desc': 'Imobiliária Central', 'value': -4500.0, 'isCredit': false, 'date': '11:15'},
      {'title': 'Cartão de Crédito', 'desc': 'Venda #9910 - Dra. Beatriz', 'value': 2850.0, 'isCredit': true, 'date': 'Ontem'},
      {'title': 'Fornecedor Resina', 'desc': 'Dental Prime Ltda', 'value': -1250.0, 'isCredit': false, 'date': 'Ontem'},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Pagamentos',
            subtitle: 'Controle de fluxo de caixa e histórico de transações.',
            buttonLabel: 'Lançar',
            buttonIcon: Icons.add_rounded,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Entradas',
                    value: 'R\$ 12k',
                    icon: LucideIcons.arrowDownLeft,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'Saídas',
                    value: 'R\$ 5.4k',
                    icon: LucideIcons.arrowUpRight,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MOVIMENTAÇÕES RECENTES',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.3),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ...transactions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final t = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (t['isCredit'] as bool ? AppColors.success : Colors.redAccent).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            t['isCredit'] as bool ? Icons.add_rounded : LucideIcons.minus,
                            color: t['isCredit'] as bool ? AppColors.success : Colors.redAccent,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t['title'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(t['desc'] as String, style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'R\$ ${t['value']}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: (t['isCredit'] as bool ? AppColors.success : Colors.white),
                              ),
                            ),
                            Text(
                              t['date'] as String,
                              style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.2)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.05, end: 0);
                }),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
