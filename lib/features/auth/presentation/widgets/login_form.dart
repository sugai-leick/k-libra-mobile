import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';
import 'package:flutter_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

/// LoginForm — widget Stateful que contém os campos de input,
/// botão de login e toda a lógica de interação do formulário.
class LoginForm extends StatefulWidget {
  final bool isLoading;

  const LoginForm({super.key, this.isLoading = false});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 💎 Logo & Brand
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.accentBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Text(
            'K-Libra',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ).animate().scale(
          delay: 200.ms,
          duration: 500.ms,
          curve: Curves.easeOutBack,
        ),

        const SizedBox(height: 24),

        Text(
          'Bem-vindo',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 400.ms).moveY(begin: 10, end: 0),

        Text(
          'Gestão inteligente para odontologia digital',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 48),

        // 📧 Input Fields
        _buildTextField(
          controller: _emailController,
          hint: 'Seu email institucional',
          icon: LucideIcons.user,
        ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1, end: 0),

        const SizedBox(height: 16),

        _buildTextField(
          controller: _passwordController,
          hint: 'Sua senha secreta',
          icon: LucideIcons.lock,
          isPassword: true,
          isVisible: _isPasswordVisible,
          onToggleVisibility: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1, end: 0),

        const SizedBox(height: 32),

        // 🚀 Login Button
        SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        final params = LoginParams(
                          email: _emailController.text,
                          password: _passwordController.text,
                          rememberMe: _rememberMe,
                        );
                        context.read<AuthBloc>().add(
                          AuthLoginRequested(params: params),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryDark,
                        AppColors.primaryDark.withBlue(150),
                        AppColors.accentBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Acessar ERP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                        const SizedBox(width: 8),
                        const Icon(
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
            .fadeIn(delay: 800.ms)
            .scale(begin: const Offset(0.95, 0.95)),

        const SizedBox(height: 16),

        // 🔘 Remember Me & Forgot Password
        _buildCheckBox(
          label: 'Mantenha-me conectado',
          value: _rememberMe,
          onChanged: (val) {
            setState(() => _rememberMe = val ?? false);
          },
        ).animate().fadeIn(delay: 750.ms),

        const SizedBox(height: 40),

        Text(
          'K-LIBRA MANAGEMENT SYSTEM',
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.3),
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // ─── Helper Widgets ───────────────────────────────────────

  Widget _buildCheckBox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primaryDark,
                checkColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            // Forgot password logic
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 36),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Esqueci minha senha',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.5),
            size: 20,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
