import 'package:flutter/material.dart';
import 'package:flutter_app/features/sales/presentation/pages/sales_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/features/sales/presentation/pages/add_sale_page.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSalePage()),
          );
        },
        backgroundColor: AppColors.accentPurple,
        elevation: 8,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Novo Pedido',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ModuleHeader(
              title: 'Vendas K-Libra',
              subtitle: 'Pedidos de venda — cursos, hardwares e consumíveis.',
            ).animate().fadeIn(delay: (200).milliseconds),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ÚLTIMAS TRANSAÇÕES',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withValues(alpha: 0.3),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SalesBuilder()
                      .animate()
                      .fadeIn(delay: (300).ms)
                      .slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
