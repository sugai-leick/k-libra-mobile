import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/status_badge.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_hardware_entity.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_consumable_entity.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InventoryTabView extends StatelessWidget {
  final List<InventoryHardwareEntity> hardwareList;
  final List<InventoryConsumableEntity> consumableList;
  final TabController controller;

  const InventoryTabView({
    super.key,
    required this.hardwareList,
    required this.consumableList,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: [
        _buildHardwareList(),
        _buildConsumablesList(),
      ],
    );
  }

  Widget _buildHardwareList() {
    if (hardwareList.isEmpty) {
      return Center(
        child: Text(
          'Nenhum equipamento cadastrado.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: hardwareList.length,
      itemBuilder: (context, index) {
        final item = hardwareList[index];
        Color statusColor = Colors.grey;
        final statusLower = item.status.toLowerCase();
        if (statusLower.contains('disponível') || statusLower.contains('available')) {
          statusColor = AppColors.success;
        }
        if (statusLower.contains('vendido') || statusLower.contains('sold')) {
          statusColor = AppColors.accentBlue;
        }
        if (statusLower.contains('manutenção') || statusLower.contains('maintenance')) {
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

  Widget _buildConsumablesList() {
    if (consumableList.isEmpty) {
      return Center(
        child: Text(
          'Nenhum item consumível no estoque.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: consumableList.length,
      itemBuilder: (context, index) {
        final item = consumableList[index];
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
                    color: Colors.white.withOpacity(0.4),
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
}
