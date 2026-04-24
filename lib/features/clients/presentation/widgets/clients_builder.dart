import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:flutter_app/features/clients/presentation/pages/clients_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsBuilder extends StatelessWidget {
  const ClientsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    // Nota: ClientsPage agora gerencia seu próprio estado reativo internamente.
    // ClientsBuilder serve como um ponto de entrada seguro que garante o disparo do evento inicial.

    return BlocConsumer<ClientsBloc, ClientsGlobalState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ClientsBloc>().add(FetchClientsListEvent());
            // Aguarda o BLoC terminar de carregar para fechar o indicador de refresh
            // Lembrando que se fosse um stream direto do banco n precisaria dessa porra de refresh
            await context.read<ClientsBloc>().stream.firstWhere(
              (state) => !state.isLoading,
            );
          },
          color: AppColors.accentPurple,
          child: const ClientsPage(),
        );
      },
    );
  }
}
