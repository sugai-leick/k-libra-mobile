import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:flutter_app/features/clients/presentation/pages/add_client_page.dart';
import 'package:flutter_app/features/clients/presentation/widgets/clients_table.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  void initState() {
    super.initState();
    // Carregamento inicial via API REST
    context.read<ClientsBloc>().add(FetchClientsListEvent());
  }

  String _activeTab = 'suporte_ativo';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CustomerEntity> _getFilteredList(List<CustomerEntity> allClients) {
    return allClients.where((client) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchNome = client.nomeCompleto.toLowerCase().contains(q);
        final matchEmail = (client.email ?? '').toLowerCase().contains(q);
        final rawCpf = (client.cpf ?? '').replaceAll(RegExp(r'[^0-9]'), '');
        final matchCpf = rawCpf.contains(q.replaceAll(RegExp(r'[^0-9]'), ''));

        if (!matchNome && !matchEmail && !matchCpf) {
          return false;
        }
      }

      if (_activeTab == 'toda_base') return true;

      final status = client.status.toLowerCase();
      switch (_activeTab) {
        case 'suporte_ativo':
          return status == 'aluno' || status == 'cliente_klibra';
        case 'leads':
          return status == 'lead';
        case 'fornecedores':
          return client.isSupplier == true;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddClientPage()),
          );
        },
        backgroundColor: AppColors.accentPurple,
        elevation: 8,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Novo Cadastro',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ModuleHeader(
              title: 'Contatos / CRM',
              subtitle: 'Gestão unificada de Leads, Clientes e Fornecedores.',
            ),
            const SizedBox(height: 8),

            _buildSearchBar(),
            const SizedBox(height: 16),

            // TABS FILTER AREA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab('Suporte Ativo', 'suporte_ativo'),
                    const SizedBox(width: 8),
                    _buildTab('Toda Base', 'toda_base'),
                    const SizedBox(width: 8),
                    _buildTab('Leads', 'leads'),
                    const SizedBox(width: 8),
                    _buildTab('Fornecedores', 'fornecedores'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // REATIVE CONTENT via BLoc
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: BlocBuilder<ClientsBloc, ClientsGlobalState>(
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
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Erro ao carregar dados:\n${state.error}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => context.read<ClientsBloc>().add(
                              FetchClientsListEvent(),
                            ),
                            child: const Text('Tentar Novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredList = _getFilteredList(state.list ?? []);

                  return SizedBox(
                    height: 500,
                    child: ClientsTable(clients: filteredList)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.05, end: 0),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, String id) {
    final bool isActive = _activeTab == id;

    return InkWell(
      onTap: () => setState(() => _activeTab = id),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentPurple : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.accentPurple
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Buscar por Nome, E-mail ou CPF',
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            LucideIcons.search,
            color: Colors.white54,
            size: 18,
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.06),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.accentPurple),
          ),
        ),
      ),
    );
  }
}
