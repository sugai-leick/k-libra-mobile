import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_app/core/widgets/shared/stat_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tipagem explícita para evitar confusão do analisador
    final List<Map<String, dynamic>> goals = [
      {
        'title': 'Vendas Mensais',
        'current': 145000.0,
        'target': 200000.0,
        'color': AppColors.accentBlue,
        'unit': 'R\$', // Escapado corretamente para evitar erro de interpolação
      },
      {
        'title': 'Novos Clientes',
        'current': 42.0,
        'target': 60.0,
        'color': AppColors.accentPurple,
        'unit': 'und',
      },
      {
        'title': 'Taxa de Retenção',
        'current': 88.0,
        'target': 95.0,
        'color': AppColors.success,
        'unit': '%',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Metas & KPIs',
            subtitle: 'Acompanhamento de performance e objetivos comerciais.',
            buttonLabel: 'Nova Meta',
            buttonIcon: Icons.add_task_rounded,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                StatCard(
                  label: 'Meta Global',
                  value: '72%',
                  icon: Icons.trending_up_rounded,
                  trend: '+5%',
                  positive: true,
                ),
                StatCard(
                  label: 'Forecast',
                  value: 'R\$ 192k',
                  icon: Icons.calendar_today_rounded,
                  color: AppColors.accentPurple,
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
                  'PROGRESSO DOS OBJETIVOS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.3),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ...goals.asMap().entries.map((entry) {
                  final index = entry.key;
                  final goal = entry.value;
                  final current = goal['current'] as double;
                  final target = goal['target'] as double;
                  final percent = current / target;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goal['title'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${goal['unit']} $current / $target',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            AnimatedContainer(
                              duration: 1000.ms,
                              curve: Curves.easeOutCubic,
                              height: 8,
                              width: (MediaQuery.of(context).size.width - 40) * (percent > 1.0 ? 1.0 : percent),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (goal['color'] as Color).withValues(alpha: 0.6),
                                    (goal['color'] as Color),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: (goal['color'] as Color).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 150).ms).slideX(begin: -0.05, end: 0);
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
