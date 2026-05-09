import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';

class InventoryFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? placeholder;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const InventoryFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.placeholder,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.white12),
            prefixIcon: Icon(icon, color: Colors.white24, size: 18),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentBlue, width: 1),
            ),
          ),
          validator: validator ?? (val) => val == null || val.isEmpty ? 'Obrigatório' : null,
        ),
      ],
    );
  }
}
