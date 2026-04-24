import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_app/core/widgets/shared/stat_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final alerts = [
      {
        'title': 'Risco de Fluxo de Caixa',
        'desc':
            'Projeção indica saldo negativo em 15 dias caso as duplicatas em atraso não sejam liquidadas.',
        'type': 'critical',
        'time': 'Há 2 horas',
        'icon': Icons.warning_amber_rounded,
      },
      {
        'title': 'Anomalia em Vendas',
        'desc':
            'O volume de vendas do Produto X caiu 40% abaixo da média histórica para esta região.',
        'type': 'warning',
        'time': 'Há 5 horas',
        'icon': Icons.trending_down_rounded,
      },
      {
        'title': 'Oportunidade de Recompra',
        'desc':
            '32 clientes estão no ciclo ideal para nova aquisição do Consumível Y.',
        'type': 'info',
        'time': 'Ontem',
        'icon': Icons.auto_awesome_rounded,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Alertas de IA',
            subtitle: 'Monitoramento preditivo e anomalias em tempo real.',
            buttonLabel: 'Configurar',
            buttonIcon: Icons.settings_rounded,
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
                  label: 'Críticos',
                  value: '02',
                  icon: Icons.error_outline_rounded,
                  color: Colors.redAccent,
                ),
                StatCard(
                  label: 'Sugestões',
                  value: '14',
                  icon: Icons.lightbulb_rounded,
                  color: AppColors.accentPurple,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                final color = alert['type'] == 'critical'
                    ? Colors.redAccent
                    : (alert['type'] == 'warning'
                          ? Colors.amber
                          : Colors.blueAccent);

                return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withValues(alpha: 0.2)), // 0.2
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1), // 0.1
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              alert['icon'] as IconData,
                              color: color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      alert['title'] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      alert['time'] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.white.withValues(alpha: 0.3), // 0.3
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  alert['desc'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.5), // 0.5
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'AGIR AGORA',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'IGNORAR',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white.withValues(alpha: 0.2), // 0.2
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .slideX(begin: 0.1, end: 0, delay: (index * 100).ms)
                    .fadeIn();
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
