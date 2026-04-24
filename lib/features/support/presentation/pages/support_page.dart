import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = [
      {'title': 'Dúvida em Configuração X1', 'id': '#TK-992', 'status': 'Aberto', 'priority': 'Alta'},
      {'title': 'Acesso ao Portal do Aluno', 'id': '#TK-901', 'status': 'Aguardando', 'priority': 'Média'},
      {'title': 'Problema na Impressão 3D', 'id': '#TK-885', 'status': 'Fechado', 'priority': 'Baixa'},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Suporte',
            subtitle: 'Central de ajuda e chamados técnicos de clientes.',
            buttonLabel: 'Novo Ticket',
            buttonIcon: Icons.chat_bubble_rounded,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final t = tickets[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.help_outline_rounded, color: AppColors.accentBlue, size: 18),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['title']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Protocolo: ${t['id']}', style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(t['status']!, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentBlue)),
                          Text(t['priority']!, style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.2))),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (index * 100).ms);
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
