import 'package:flutter/material.dart';
import 'package:flutter_app/features/products/presentation/blocs/products_page/bloc/products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_form_modal.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_card.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_filter_header.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: const Center(child: ProductsBuilder()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ProductFormModal.show(
            context,
            onSave: (dto) async {
              // Agora a gente só dispara o evento pro BLoC!
              context.read<ProductsBloc>().add(NewProductSubmitted(dto));
            },
          );
        },
        backgroundColor: const Color(0xFFA855F7), // primaryDark
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Novo Registro',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProductsBuilder extends StatefulWidget {
  const ProductsBuilder({super.key});

  @override
  State<ProductsBuilder> createState() => _ProductsBuilderState();
}

class _ProductsBuilderState extends State<ProductsBuilder> {
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Tudo', 'Hardware', 'Consumíveis', 'Insumos'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        // Escuta os alertas de sucesso ou erro que vêm do BLoC
        if (state.status == ProductsStatus.success && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == ProductsStatus.error &&
            state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        // Filtra a lista
        final filteredProducts = state.products.where((product) {
          // Busca
          final matchesSearch = product.nome.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                product.descricao.toLowerCase().contains(_searchQuery.toLowerCase());
          
          if (!matchesSearch) return false;
          
          // Categorias
          if (_selectedCategoryIndex == 0) return true; // Tudo
          final category = _categories[_selectedCategoryIndex].toLowerCase();
          final productType = product.tipo.toLowerCase();
          
          if (category == 'hardware' && productType.contains('hardware')) return true;
          if (category == 'consumíveis' && (productType.contains('consumivel') || productType.contains('consumível'))) return true;
          if (category == 'insumos' && productType.contains('insumo')) return true;
          
          return productType == category;
        }).toList();

        return Column(
          children: [
            ProductFilterHeader(
              searchQuery: _searchQuery,
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              selectedCategoryIndex: _selectedCategoryIndex,
              onCategoryChanged: (index) => setState(() => _selectedCategoryIndex = index),
              categories: _categories,
            ),
            const SizedBox(height: 8),
            // Expanded List with Refresh Indicator
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFFA855F7),
                backgroundColor: const Color(0xFF1E1E1E),
                onRefresh: () async {
                  context.read<ProductsBloc>().add(FetchProductsEvent());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Se a lista (filtrada) for vazia, mostra estado vazio
                    if (filteredProducts.isEmpty)
                      ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.inventory_2_rounded,
                                  size: 64,
                                  color: Colors.white24,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty || _selectedCategoryIndex != 0
                                      ? 'Nenhum resultado encontrado'
                                      : 'Hub de Produtos',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isNotEmpty || _selectedCategoryIndex != 0
                                      ? 'Tente ajustar os filtros da busca.'
                                      : 'Nenhum item indexado no momento.',
                                  style: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      // Se tiver itens, renderiza a lista filtrada
                      ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                          bottom: 100,
                        ),
                        itemCount: filteredProducts.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(product: product);
                        },
                      ),

                    // Loading global
                    if (state.status == ProductsStatus.loading)
                      Container(
                        color: Colors.black38,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: Color(0xFFA855F7),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}
