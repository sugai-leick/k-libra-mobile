import 'package:flutter/material.dart';
import 'package:flutter_app/core/widgets/dashboard/kpi_card.dart';
import 'package:flutter_app/features/sales/presentation/bloc/total_sales_card_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesCountCard extends StatelessWidget {
  const SalesCountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalSalesCardBloc, TotalSalesCardState>(
      buildWhen: (previous, current) => previous.totalCount != current.totalCount,
      builder: (context, state) {
        return KpiCard(
          label: 'Pedidos de Venda',
          value: state.totalCount?.toString() ?? '...', 
          icon: Icons.shopping_bag_rounded,
          color: const Color(0xFFD946EF),
        );
      },
    );
  }
}
