import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/status_badge.dart';
import 'package:flutter_app/features/sales/presentation/bloc/sales_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SalesBuilder extends StatelessWidget {
  const SalesBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesBloc, SalesState>(
      builder: (context, state) {
        if (state.isLoading && state.list == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.accentPurple),
            ),
          );
        }

        if (state.error != null) {
          return Center(
            child: Text(
              'Erro: ${state.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }
        final sales = state.list ?? [];
        if (sales.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma venda encontrada',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];

            Color statusColor = Colors.grey;
            if (sale.status == 'concluída') {
              statusColor = AppColors.success;
            }
            if (sale.status == 'pendente') {
              statusColor = Colors.amber;
            }
            if (sale.status == 'parcial') {
              statusColor = AppColors.accentBlue;
            }

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
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      sale.status == 'concluída'
                          ? LucideIcons.check
                          : LucideIcons.clock,
                      color: statusColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pedido Libra',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'ID: ${(sale.id ?? "Nov.").length > 8 ? (sale.id ?? "Nov.").substring(0, 8) : (sale.id ?? "Nov.")}...',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${sale.totalAmount.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(label: sale.status ?? '', color: statusColor),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
          },
        );
      },
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? ''),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }
}
