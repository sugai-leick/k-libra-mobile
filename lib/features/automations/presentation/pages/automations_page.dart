import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AutomationsPage extends StatelessWidget {
  const AutomationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final automations = [
      {
        'title': 'Conciliação Automática',
        'desc': 'Sincroniza extratos bancários e baixa faturas pagas via Pix.',
        'status': 'Ativo',
        'tasks': 1420,
      },
      {
        'title': 'Fluxo de Recompra (CRM)',
        'desc': 'Dispara WhatsApp quando o cliente está no ciclo de recompra.',
        'status': 'Ativo',
        'tasks': 312,
      },
      {
        'title': 'Backup de Nuvem',
        'desc': 'Sincronização diária dos arquivos fiscais no Google Drive.',
        'status': 'Pausado',
        'tasks': 88,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Otimizações',
            subtitle: 'Automações inteligentes para aumentar a eficiência operacional.',
            buttonLabel: 'Nova Regra',
            buttonIcon: Icons.bolt_rounded,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: automations.length,
              itemBuilder: (context, index) {
                final item = automations[index];
                final bool isActive = item['status'] == 'Ativo';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (isActive ? AppColors.accentBlue : Colors.grey).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isActive ? LucideIcons.play : LucideIcons.pause,
                          color: isActive ? AppColors.accentBlue : Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'] as String,
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.4), height: 1.4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Execuções no mês: ${item['tasks']}',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isActive,
                        onChanged: (v) {},
                        activeThumbColor: AppColors.accentBlue,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (index * 150).ms).slideX(begin: 0.05, end: 0);
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
