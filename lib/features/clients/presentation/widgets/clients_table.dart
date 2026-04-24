import 'package:flutter/material.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'client_card_item.dart';
import '../pages/add_client_page.dart';
import 'package:flutter/services.dart';

class ClientsTable extends StatelessWidget {
  final List<CustomerEntity> clients;

  const ClientsTable({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      return Center(
        child: Text(
          'Nenhum cliente retornado da base.',
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.54),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: clients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final client = clients[index];
        return ClientCardItem(
          client: client,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddClientPage(client: client),
              ),
            );
          },
          onDelete: () {
            HapticFeedback.heavyImpact();
            _showDeleteConfirmation(context, client);
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, CustomerEntity client) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Excluir Cliente',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Tem certeza que deseja remover ${client.nomeCompleto}? Esta ação é permanente.',
          style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (client.id != null) {
                context.read<ClientsBloc>().add(DeleteClientEvent(client.id!));
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
              foregroundColor: Colors.redAccent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.redAccent, width: 0.5),
              ),
            ),
            child: Text(
              'Excluir',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
