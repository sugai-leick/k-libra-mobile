import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final insights = [
      {
        'title': 'Otimização de Preços',
        'desc': 'Baseado na concorrência, o Produto A pode ter um ajuste de +5% sem afetar a demanda atual.',
        'impact': 'ALTO IMPACTO',
        'color': AppColors.accentBlue,
      },
      {
        'title': 'Previsão de Churn',
        'desc': 'Identificamos 12 clientes com queda de engajamento. Recomenda-se contato proativo.',
        'impact': 'MÉDIO IMPACTO',
        'color': AppColors.accentPurple,
      },
      {
        'title': 'Análise de Fluxo',
        'desc': 'Sextas-feiras têm 30% mais volume de pedidos. Considere reforçar a equipe de envios.',
        'impact': 'OPERACIONAL',
        'color': AppColors.success,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Insights e IA',
            subtitle: 'Sugestões inteligentes baseadas no comportamento dos seus dados.',
            buttonLabel: 'Gerar Novo',
            buttonIcon: LucideIcons.sparkles,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentBlue.withValues(alpha: 0.2),
                    AppColors.accentPurple.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.brainCircuit, color: AppColors.accentBlue, size: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assistente K-Libra',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Analisando 4.2k transações recentes...',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().shimmer(duration: 2.seconds),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...insights.asMap().entries.map((entry) {
                  final index = entry.key;
                  final insight = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: (insight['color'] as Color).withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              insight['title'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (insight['color'] as Color).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                insight['impact'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: insight['color'] as Color,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          insight['desc'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.5),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (insight['color'] as Color).withValues(alpha: 0.15),
                            foregroundColor: insight['color'] as Color,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Ver Detalhes'),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 200).ms).slideY(begin: 0.1, end: 0);
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
