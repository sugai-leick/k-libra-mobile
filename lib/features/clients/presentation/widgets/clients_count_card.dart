import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/dashboard/kpi_card.dart';
import 'package:flutter_app/features/clients/presentation/bloc/total_clients_card_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsCountCard extends StatelessWidget {
  const ClientsCountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalClientsCardBloc, TotalClientsCardState>(
      buildWhen: (previous, current) => previous.totalCount != current.totalCount,
      builder: (context, state) {
        return KpiCard(
          label: 'Total de Clientes',
          value: state.totalCount?.toString() ?? '...', 
          icon: Icons.people_alt_rounded,
          color: AppColors.accentPurple,
        );
      },
    );
  }
}
