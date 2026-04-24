import 'package:flutter/material.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'client_card_item.dart';
import '../pages/add_client_page.dart';

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
            // TODO: Integrar com Bloc/Navegação para exclusão
          },
        );
      },
    );
  }
}
