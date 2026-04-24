import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/widgets/auth_builder.dart';
import 'package:flutter_app/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_app/features/sales/presentation/bloc/sales_bloc.dart';
import 'package:flutter_app/features/clients/presentation/bloc/total_clients_card_bloc.dart';
import 'package:flutter_app/features/sales/presentation/bloc/total_sales_card_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //le o .env com as variaveis de ambiente para conectar ao banco de dados
  await dotenv.load(fileName: ".env");

  // Inicializa o Supabase ANTES do DI para que o DI use a instância singleton
  await Supabase.initialize(
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    url: dotenv.env['SUPABASE_URL'] ?? '',
  );

  // Initialize Dependency Injection (usa Supabase.instance.client)
  await di.init();

  runApp(const KLibraApp());
}

class KLibraApp extends StatelessWidget {
  const KLibraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (context) => di.sl<TotalClientsCardBloc>()),
        BlocProvider(create: (context) => di.sl<TotalSalesCardBloc>()),
        BlocProvider(
          create: (context) => di.sl<SalesBloc>()..add(FetchSalesRequested()),
        ),
        // BlocProvider(create: (context) => di.sl<DashboardBloc>()),
        BlocProvider(
          create: (context) =>
              di.sl<ClientsBloc>()..add(FetchClientsListEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'K-Libra System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const AuthBuilder(),
      ),
    );
  }
}
