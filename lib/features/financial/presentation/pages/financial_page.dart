import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinancialPage extends StatelessWidget {
  const FinancialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Financeiro',
        style: GoogleFonts.inter(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
