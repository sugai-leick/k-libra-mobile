import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_form_modal.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_rounded, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              'Hub de Produtos',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhum item indexado no momento.',
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ProductFormModal.show(context, onSave: (dto) async {
            // TODO: call the usecase to create the product
            print('Product to save: ${dto.nome}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produto salvo com sucesso! (Mock)'), backgroundColor: Colors.green),
            );
          });
        },
        backgroundColor: const Color(0xFFA855F7), // primaryDark
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Novo Registro', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
