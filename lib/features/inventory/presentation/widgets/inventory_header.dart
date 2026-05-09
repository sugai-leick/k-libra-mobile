import 'package:flutter/material.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InventoryHeader extends StatelessWidget {
  const InventoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModuleHeader(
      title: 'Estoque',
      subtitle: 'Gestão de hardwares por serial e consumíveis por quantidade.',
    );
  }
}
