import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// LoginPage — responsável apenas pelo layout e fundo visual.
/// O formulário de login fica em [LoginForm].
class LoginPage extends StatelessWidget {
  final bool isLoading;

  const LoginPage({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundDark,
              AppColors.backgroundDark.withBlue(40),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 🌌 Background Orbs (Premium look)
            Positioned(
              top: -size.height * 0.1,
              left: -size.width * 0.1,
              child:
                  Container(
                    width: size.width * 0.5,
                    height: size.width * 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryDark.withValues(alpha: 0.15),
                    ),
                  ).animate().blur(
                    begin: const Offset(80, 80),
                    end: const Offset(120, 120),
                  ),
            ),
            Positioned(
              bottom: -size.height * 0.1,
              right: -size.width * 0.1,
              child:
                  Container(
                    width: size.width * 0.6,
                    height: size.width * 0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentBlue.withValues(alpha: 0.1),
                    ),
                  ).animate().blur(
                    begin: const Offset(80, 80),
                    end: const Offset(120, 120),
                  ),
            ),

            // 📄 Form Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(32),
                    blur: 30,
                    opacity: 0.08,
                    child: LoginForm(isLoading: isLoading),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
