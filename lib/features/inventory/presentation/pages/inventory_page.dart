import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_app/core/widgets/shared/status_badge.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_hardware_entity.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_consumable_entity.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:flutter_app/features/inventory/data/dtos/add_hardware_dto.dart';
import 'package:flutter_app/features/inventory/data/dtos/inventory_transaction_dto.dart';

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
    return Column(
      children: [
        ModuleHeader(
          title: 'Estoque',
          subtitle:
              'Gestão de hardwares por serial e consumíveis por quantidade.',
          buttonLabel: 'Adicionar',
          buttonIcon: LucideIcons.box,
          onButtonPressed: () => _showAddInventoryDialog(context),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.accentBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: 'HARDWARE'),
                Tab(text: 'CONSUMÍVEIS'),
              ],
            ),
          ),
        ),

        Expanded(
          child: BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accentBlue),
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

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildHardwareList(hardwares),
                  _buildConsumablesList(consumables),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHardwareList(List<InventoryHardwareEntity> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Nenhum equipamento cadastrado.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        Color statusColor = Colors.grey;
        final statusLower = item.status.toLowerCase();

        if (statusLower.contains('disponível') ||
            statusLower.contains('available')) {
          statusColor = AppColors.success;
        }
        if (statusLower.contains('vendido') || statusLower.contains('sold')) {
          statusColor = AppColors.accentBlue;
        }
        if (statusLower.contains('manutenção') ||
            statusLower.contains('maintenance')) {
          statusColor = Colors.orange;
        }

        return _buildInventoryTile(
          item.name,
          item.serialNumber,
          item.status,
          statusColor,
          LucideIcons.monitor,
        );
      },
    );
  }

  Widget _buildConsumablesList(List<InventoryConsumableEntity> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Nenhum item consumível no estoque.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        Color statusColor = AppColors.success;

        if (item.quantity == 0) {
          statusColor = Colors.redAccent;
        } else if (item.quantity <= 5) {
          statusColor = Colors.orange;
        }

        return _buildInventoryTile(
          item.name,
          '${item.quantity} unidades',
          item.status,
          statusColor,
          Icons.inventory_2_rounded,
        );
      },
    );
  }

  Widget _buildInventoryTile(
    String title,
    String sub,
    String status,
    Color color,
    IconData icon,
  ) {
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(label: status, color: color),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05, end: 0);
  }

  void _showAddInventoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddInventoryBottomSheet(),
    );
  }
}

class _AddInventoryBottomSheet extends StatefulWidget {
  const _AddInventoryBottomSheet();

  @override
  State<_AddInventoryBottomSheet> createState() =>
      _AddInventoryBottomSheetState();
}

class _AddInventoryBottomSheetState extends State<_AddInventoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool isHardware = true;

  // Hardware Fields
  final _productSkController = TextEditingController();
  final _serialNumController = TextEditingController();

  // Transaction Fields
  final _productIdController = TextEditingController();
  final _quantityController = TextEditingController();
  String _transactionType = 'entrada';

  @override
  void dispose() {
    _productSkController.dispose();
    _serialNumController.dispose();
    _productIdController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (isHardware) {
        final dto = AddHardwareDto(
          productSk: int.tryParse(_productSkController.text) ?? 0,
          serialNumber: _serialNumController.text,
        );
        context.read<InventoryBloc>().add(AddHardwareEvent(dto));
      } else {
        final dto = InventoryTransactionDto(
          productId: _productIdController.text,
          quantity: int.tryParse(_quantityController.text) ?? 0,
          type: _transactionType,
        );
        context.read<InventoryBloc>().add(RegisterTransactionEvent(dto));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.only(bottom: bottomInset, top: 100),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adicionar ao Estoque',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeSelector(
                      title: 'Hardware',
                      icon: LucideIcons.monitor,
                      isSelected: isHardware,
                      onTap: () => setState(() => isHardware = true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeSelector(
                      title: 'Consumível',
                      icon: Icons.inventory_2_outlined,
                      isSelected: !isHardware,
                      onTap: () => setState(() => isHardware = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              isHardware ? _buildHardwareForm() : _buildConsumableForm(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    'Registrar',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentBlue.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isSelected ? AppColors.accentBlue : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accentBlue : Colors.white54,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHardwareForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'SK do Produto',
          controller: _productSkController,
          icon: LucideIcons.hash,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Número de Série',
          controller: _serialNumController,
          icon: LucideIcons.barcode,
        ),
      ],
    );
  }

  Widget _buildConsumableForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'ID do Produto (Consumível)',
          controller: _productIdController,
          icon: LucideIcons.box,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Quantidade',
                controller: _quantityController,
                icon: LucideIcons.layers,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _transactionType,
                dropdownColor: AppColors.cardDark,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                  DropdownMenuItem(value: 'saida', child: Text('Saída')),
                ],
                onChanged: (val) =>
                    setState(() => _transactionType = val ?? 'entrada'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54, size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Obrigatório' : null,
    );
  }
}
