import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ApprovalsPage extends StatelessWidget {
  const ApprovalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = [
      {
        'title': 'Despesa Extraordinária',
        'requester': 'Financeiro - Carlos',
        'value': 12500.0,
        'category': 'Infraestrutura',
        'date': 'Há 30 min',
      },
      {
        'title': 'Desconto em Venda (15%)',
        'requester': 'Vendas - Marina',
        'value': 2800.0,
        'category': 'Comercial',
        'date': 'Há 2 horas',
      },
      {
        'title': 'Ajuste de Saldo Inventário',
        'requester': 'Estoque - Roberto',
        'value': 0.0,
        'category': 'Estoque',
        'date': 'Hoje, 09:15',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Aprovações',
            subtitle: 'Governança e controle de decisões críticas pendentes.',
            buttonLabel: 'Histórico',
            buttonIcon: Icons.history_rounded,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pending.length,
              itemBuilder: (context, index) {
                final item = pending[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              (item['category'] as String).toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: AppColors.accentBlue,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Text(
                            item['date'] as String,
                            style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.3)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item['title'] as String,
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Solicitado por: ${item['requester']}',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      if (item['value'] != 0.0) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Valor: R\$ ${item['value']}',
                          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success.withValues(alpha: 0.8), // 0.8
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('APROVAR'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent),
                                foregroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('REJEITAR'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (index * 150).ms).slideY(begin: 0.1, end: 0);
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
