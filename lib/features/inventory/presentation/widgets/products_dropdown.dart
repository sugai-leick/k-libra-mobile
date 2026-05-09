import 'package:flutter/material.dart';
import 'package:flutter_app/core/di/injection_container.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/products_list/bloc/products_list_bloc.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart' as entity;
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsDropdown extends StatelessWidget {
  final void Function(entity.Product) onSelected;
  final String? filterType;
  final entity.Product? value;
  
  const ProductsDropdown({
    super.key,
    required this.onSelected,
    this.filterType,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsListBloc, ProductsListState>(
        builder: (context, state) {
          if (state is ProductsListLoading || state is ProductsListInitial) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                  ),
                ),
              ),
            );
          }
          

          if (state is ProductsListLoaded) {
            final filteredList = filterType != null
                ? state.productList
                    .where((p) =>
                        p.tipo.toLowerCase() == filterType!.toLowerCase())
                    .toList()
                : state.productList;
            
            debugPrint('Dropdown Filter: Type=$filterType | Total=${state.productList.length} | Filtered=${filteredList.length}');
            if (filteredList.isEmpty && state.productList.isNotEmpty) {
               debugPrint('Available types in state: ${state.productList.map((e) => e.tipo).toSet()}');
            }

            return DropdownButtonFormField<entity.Product>(
              value: value,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Selecionar Produto',
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white54),
              ),
              items: filteredList.map((product) {
                return DropdownMenuItem<entity.Product>(
                  value: product,
                  child: Text(
                    product.nome,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (entity.Product? val) {
                if (val != null) onSelected(val);
              },
              validator: (val) => val == null ? 'Selecione um produto' : null,
            );
          }

          return const SizedBox();
        },
        listener: (context, state) {
          if (state is ProductsListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
  }
}
