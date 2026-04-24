import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/layout/main_layout.dart';
import 'package:flutter_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget responsável por decidir qual tela exibir
/// com base no estado atual do AuthBloc.
class AuthBuilder extends StatelessWidget {
  const AuthBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(state.msg),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoaded) return const MainLayout();
        // AuthInitial, AuthLoading, AuthError → mostra login
        return LoginPage(isLoading: state is AuthLoading);
      },
    );
  }
}
