import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';

class ClientCardContent extends StatelessWidget {
  final CustomerEntity client;

  const ClientCardContent({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    // Cores e Icones baseados no Status vindo da API
    Color badgeColor = Colors.grey;
    Color badgeText = Colors.white;
    String badgeTitle = client.status.toUpperCase();
    IconData avatarIcon = Icons.person_rounded;

    if (client.isSupplier == true) {
      badgeColor = Colors.indigo.withValues(alpha: 0.2);
      badgeText = Colors.indigo.shade300;
      avatarIcon = Icons.local_shipping_rounded;
      badgeTitle = 'FORNECEDOR';
    } else {
      switch (client.status.toLowerCase()) {
        case 'lead':
          badgeColor = Colors.blue.withValues(alpha: 0.2);
          badgeText = Colors.blue.shade300;
          avatarIcon = Icons.star_rounded;
          break;
        case 'aluno':
          badgeColor = Colors.amber.withValues(alpha: 0.2);
          badgeText = Colors.amber.shade300;
          avatarIcon = Icons.school_rounded;
          break;
        case 'cliente_klibra':
          badgeColor = Colors.teal.withValues(alpha: 0.2);
          badgeText = Colors.teal.shade300;
          avatarIcon = Icons.verified_user_rounded;
          badgeTitle = 'K-LIBRA';
          break;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badgeColor,
                ),
                child: Icon(avatarIcon, size: 20, color: badgeText),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.nomeCompleto,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      client.email ?? 'Sem e-mail registrado',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.54),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeTitle,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: badgeText,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Localização',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    client.enderecoResidencial != null
                        ? '${client.enderecoResidencial!.cidade}/${client.enderecoResidencial!.estado}'
                        : 'Não Informado',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'CPF/CNPJ',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    client.cpf ?? client.cnpj ?? '—',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\$ 0,00 total',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.tealAccent.withValues(alpha: 0.8),
                ),
              ),
              Text(
                'Deslize para ações',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.3),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
