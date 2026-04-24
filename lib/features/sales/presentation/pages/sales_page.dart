import 'package:flutter/material.dart';
import 'package:flutter_app/features/sales/presentation/bloc/sales_bloc.dart';
import 'package:flutter_app/features/sales/presentation/bloc/total_sales_card_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_app/core/widgets/shared/stat_card.dart';
import 'package:flutter_app/core/widgets/shared/status_badge.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<TotalSalesCardBloc, TotalSalesCardState>(
                      builder: (context, state) {
                        return StatCard(
                          label: 'Total Pedidos',
                          value: state.totalCount?.toString() ?? '...',
                          icon: Icons.shopping_bag_rounded,
                          trend: '+ Realtime',
                          positive: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: StatCard(
                      label: 'Conversão',
                      value: '3.4%',
                      icon: Icons.track_changes_rounded,
                      color: AppColors.accentPurple,
                    ),
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
                    'ÚLTIMAS TRANSAÇÕES',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withValues(alpha: 0.3),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<SalesBloc, SalesState>(
                    builder: (context, state) {
                      if (state.isLoading &&
                          (state.list == null || state.list!.isEmpty)) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(
                              color: AppColors.accentPurple,
                            ),
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
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              color: Colors.white.withValues(
                                                alpha: 0.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                        StatusBadge(
                                          label: sale.status ?? '',
                                          color: statusColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (index * 50).ms)
                              .slideY(begin: 0.1, end: 0);
                        },
                      );
                    },
                  ),
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
