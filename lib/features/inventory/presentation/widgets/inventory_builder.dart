import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/di/injection_container.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:flutter_app/features/inventory/presentation/pages/inventory_page.dart';

class InventoryBuilder extends StatelessWidget {
  const InventoryBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InventoryBloc>(),
      child: const InventoryPage(),
    );
  }
}
