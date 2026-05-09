import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/add_inventory_modal.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/inventory_header.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/inventory_tab_bar.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/inventory_tab_view.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<InventoryBloc>().add(FetchInventoryListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const InventoryHeader(),
          InventoryTabBar(controller: _tabController),
          Expanded(
            child: BlocBuilder<InventoryBloc, InventoryState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentBlue,
                    ),
                  );
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Falha no estoque: ${state.error}',
                          style: GoogleFonts.inter(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () => context.read<InventoryBloc>().add(
                            FetchInventoryListEvent(),
                          ),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                final hardwares = state.hardwareList ?? [];
                final consumables = state.consumablesList ?? [];

                return InventoryTabView(
                  hardwareList: hardwares,
                  consumableList: consumables,
                  controller: _tabController,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddInventoryDialog(context),
        backgroundColor: AppColors.accentBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Entrada de Estoque',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showAddInventoryDialog(BuildContext context) {
    AddInventoryModal.show(context);
  }
}
