import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipping = [
      {'id': 'TRK-99238', 'dest': 'Curitiba/PR', 'status': 'Em trânsito', 'carrier': 'Loggi'},
      {'id': 'TRK-44312', 'dest': 'São Paulo/SP', 'status': 'Entregue', 'carrier': 'Correios'},
      {'id': 'TRK-99240', 'dest': 'Belo Horizonte/MG', 'status': 'Separando', 'carrier': 'Total Express'},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Envios',
            subtitle: 'Rastreamento logístico e status de entrega de pedidos.',
            buttonLabel: 'Novo Envio',
            buttonIcon: Icons.local_shipping_rounded,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shipping.length,
              itemBuilder: (context, index) {
                final s = shipping[index];

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
                          color: AppColors.accentBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.inventory_2_rounded, color: AppColors.accentBlue, size: 18),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['id']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Destino: ${s['dest']}', style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(s['status']!, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentBlue)),
                          Text(s['carrier']!, style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.2))),
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
