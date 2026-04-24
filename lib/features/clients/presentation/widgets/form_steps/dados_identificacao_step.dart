import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/clients/presentation/bloc/formulario/bloc/formulario_clientes_bloc.dart';
import 'package:flutter_app/features/clients/presentation/widgets/custom_form_field.dart';

class DadosIdentificacaoStep extends StatefulWidget {
  const DadosIdentificacaoStep({super.key});

  @override
  State<DadosIdentificacaoStep> createState() => _DadosIdentificacaoStepState();
}

class _DadosIdentificacaoStepState extends State<DadosIdentificacaoStep> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;

  String? _nomeError;
  String? _emailError;
  String? _telefoneError;

  bool _isLead = true;
  bool _isCustomer = false;
  bool _isSupplier = false;

  @override
  void initState() {
    super.initState();
    final dto = context.read<FormularioClientesBloc>().state.clientDto;
    _nomeController = TextEditingController(text: dto.nomeCompleto);
    _emailController = TextEditingController(text: dto.email);
    _telefoneController = TextEditingController(text: dto.telefone);

    _isCustomer = dto.isCustomer;
    _isSupplier = dto.isSupplier;
    _isLead = !_isCustomer && !_isSupplier;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _toggleRole(String role) {
    setState(() {
      if (role == 'lead') {
        _isLead = true;
        _isCustomer = false;
        _isSupplier = false;
      } else if (role == 'customer') {
        _isCustomer = !_isCustomer;
        if (_isCustomer) {
          _isLead = false;
        }
      } else if (role == 'supplier') {
        _isSupplier = !_isSupplier;
        if (_isSupplier) {
          _isLead = false;
        }
      }

      if (!_isCustomer && !_isSupplier) {
        _isLead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados de Identificação',
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 8),
          Text(
            'Preencha as informações fundamentais do novo cadastro.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ).animate().fadeIn(delay: 100.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 32),

          Text(
            'Tipo de Cadastro',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildRoleCard(
                'Lead',
                LucideIcons.userPlus,
                _isLead,
                () => _toggleRole('lead'),
              ),
              const SizedBox(width: 12),
              _buildRoleCard(
                'Cliente',
                LucideIcons.users,
                _isCustomer,
                () => _toggleRole('customer'),
              ),
              const SizedBox(width: 12),
              _buildRoleCard(
                'Fornecedor',
                LucideIcons.truck,
                _isSupplier,
                () => _toggleRole('supplier'),
              ),
            ],
          ).animate().fadeIn(delay: 250.ms),
          const SizedBox(height: 32),

          CustomFormField(
            controller: _nomeController,
            hint: 'Nome Completo *',
            icon: LucideIcons.user,
            errorText: _nomeError,
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          CustomFormField(
            controller: _emailController,
            hint: 'E-mail principal *',
            icon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          CustomFormField(
            controller: _telefoneController,
            hint: 'Telefone (WhatsApp) *',
            icon: LucideIcons.phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter(),
            ],
            errorText: _telefoneError,
          ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 48),

          SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _nomeError = _nomeController.text.isEmpty
                          ? 'Nome é obrigatório'
                          : null;

                      final email = _emailController.text;
                      if (email.isEmpty) {
                        _emailError = 'E-mail é obrigatório';
                      } else if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(email)) {
                        _emailError = 'E-mail inválido';
                      } else {
                        _emailError = null;
                      }

                      final telefone = _telefoneController.text.replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      );
                      if (telefone.isEmpty) {
                        _telefoneError = 'WhatsApp é obrigatório';
                      } else if (telefone.length < 10) {
                        _telefoneError = 'Telefone incompleto';
                      } else {
                        _telefoneError = null;
                      }
                    });

                    if (_nomeError != null ||
                        _emailError != null ||
                        _telefoneError != null) {
                      return;
                    }

                    final bloc = context.read<FormularioClientesBloc>();
                    final atualDto = bloc.state.clientDto;
                    bloc.add(
                      DadosIdentificacaoEvent(
                        clientDto: atualDto.copyWith(
                          nomeCompleto: _nomeController.text,
                          email: _emailController.text,
                          telefone: _telefoneController.text,
                          isCustomer: _isCustomer,
                          isSupplier: _isSupplier,
                          status: _isLead ? 'lead' : 'cliente_klibra',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.accentBlue],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Próximo Passo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            LucideIcons.arrowRight,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    String title,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const activeColor = Color(0xFF3B82F6);
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withValues(alpha: 0.1)
                : inactiveColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? activeColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive
                    ? activeColor
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.4)),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive
                      ? activeColor
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.6)
                            : Colors.black.withValues(alpha: 0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
