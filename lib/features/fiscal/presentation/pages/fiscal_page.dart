import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FiscalPage extends StatelessWidget {
  const FiscalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nfes = [
      {'id': 'NFe #8821', 'client': 'João Silva', 'status': 'Emitida', 'date': 'Hoje'},
      {'id': 'NFe #8820', 'client': 'Beatriz Santos', 'status': 'Transmitida', 'date': 'Hoje'},
      {'id': 'NFe #8819', 'client': 'OdontoTop', 'status': 'Emitida', 'date': 'Ontem'},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Fiscal / NFe',
            subtitle: 'Gerenciamento de notas fiscais e obrigações tributárias.',
            buttonLabel: 'Emitir NFe',
            buttonIcon: Icons.table_view_rounded,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nfes.length,
              itemBuilder: (context, index) {
                final n = nfes[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description_rounded, color: Colors.white24, size: 20),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n['id']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(n['client']!, style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          n['status']!.toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.success),
                        ),
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
