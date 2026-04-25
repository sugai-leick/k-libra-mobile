import 'package:flutter_app/core/services/remember_email_service.dart';
import 'package:flutter_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_app/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:flutter_app/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:flutter_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:flutter_app/features/inventory/domain/usecases/fetch_inventory_usecase.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:flutter_app/features/inventory/domain/usecases/add_hardware_usecase.dart';
import 'package:flutter_app/features/inventory/domain/usecases/inventory_transaction_usecase.dart';
import 'package:flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_app/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:flutter_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter_app/features/financial/data/datasources/financial_remote_datasource.dart';
import 'package:flutter_app/features/financial/data/repositories/financial_repository_impl.dart';
import 'package:flutter_app/features/financial/domain/repositories/financial_repository.dart';
import 'package:flutter_app/features/financial/domain/usecases/financial_usecases.dart';
import 'package:flutter_app/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:flutter_app/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:flutter_app/features/sales/domain/repositories/sales_repository.dart';
import 'package:flutter_app/features/fiscal/data/datasources/fiscal_remote_datasource.dart';
import 'package:flutter_app/features/fiscal/data/repositories/fiscal_repository_impl.dart';
import 'package:flutter_app/features/fiscal/domain/repositories/fiscal_repository.dart';
import 'package:flutter_app/features/clients/data/datasources/customers_remote_datasource.dart';
import 'package:flutter_app/features/clients/data/repositories/customers_repository_impl.dart';
import 'package:flutter_app/features/clients/domain/repositories/customers_repository.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/domain/usecases/customers_usecases.dart';
import 'package:flutter_app/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:flutter_app/features/clients/presentation/bloc/total_clients_card_bloc.dart';
import 'package:flutter_app/features/clients/presentation/bloc/formulario/bloc/formulario_clientes_bloc.dart';
import 'package:flutter_app/features/clients/domain/usecases/total_customers_usecase.dart';
import 'package:flutter_app/features/sales/domain/usecases/get_sales_usecase.dart';
import 'package:flutter_app/features/sales/domain/usecases/total_sales_usecase.dart';
import 'package:flutter_app/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:flutter_app/features/clients/domain/usecases/get_students_usecase.dart';
import 'package:flutter_app/features/sales/presentation/bloc/sales_form_bloc.dart';
import 'package:flutter_app/features/sales/presentation/bloc/sales_bloc.dart';
import 'package:flutter_app/features/sales/presentation/bloc/total_sales_card_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/core/network/auth_interceptor.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/core/services/supabase_session_manager.dart';
import 'package:flutter_app/core/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. External - Third party packages
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => secureStorage);

  // Core Services
  sl.registerLazySingleton<ITokenService>(() => TokenService(sl()));
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => AuthInterceptor(sl()));
  sl.registerLazySingleton(() => HttpService(sl(), sl()));
  sl.registerLazySingleton<IRememberEmailService>(
    () => RememberEmailService(storage: sl<FlutterSecureStorage>()),
  );

  // Supabase — usa a instância singleton já inicializada no main.dart
  // Isso garante que a sessão setada pelo SessionManager vale em todos os datasources
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Supabase Session Manager — ponte entre JWT da API e SupabaseClient
  sl.registerLazySingleton<SupabaseSessionManager>(
    () => SupabaseSessionManager(sl<SupabaseClient>()),
  );

  // Features - Auth
  // Repositories
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      tokenService: sl(),
      supabaseSessionManager: sl<SupabaseSessionManager>(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      httpService: sl<HttpService>(),
      rememberEmailService: sl<IRememberEmailService>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<SendPasswordResetEmailUsecase>(
    () => SendPasswordResetEmailUsecase(authRepo: sl<IAuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(authRepo: sl<IAuthRepository>()),
  );
  //auth bloc
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUsecase: sl<LoginUsecase>(),
      logoutUsecase: sl<LogoutUsecase>(),
      tokenService: sl<ITokenService>(),
      supabaseSessionManager: sl<SupabaseSessionManager>(),
      httpService: sl<HttpService>(),
      rememberEmailService: sl<IRememberEmailService>(),
    ),
  );

  // Features - Clients
  // Repositories
  sl.registerLazySingleton<ICustomersRepository>(
    () => CustomersRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ICustomersRemoteDataSource>(
    () => CustomersRemoteDataSource(
      httpService: sl(),
      supabase: sl<SupabaseClient>(),
    ),
  );

  sl.registerLazySingleton<TotalCustomersUsecase>(
    () => TotalCustomersUsecase(repository: sl<ICustomersRepository>()),
  );

  // Usecases
  sl.registerLazySingleton<GetCustomersUseCase>(
    () => GetCustomersUseCase(sl()),
  );
  sl.registerLazySingleton<CreateCustomerUseCase>(
    () => CreateCustomerUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateCustomerUseCase>(
    () => UpdateCustomerUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteCustomerUseCase>(
    () => DeleteCustomerUseCase(sl()),
  );
  sl.registerLazySingleton<GetCustomerByIdUseCase>(
    () => GetCustomerByIdUseCase(sl()),
  );

  // blocs
  sl.registerFactory<TotalClientsCardBloc>(
    () => TotalClientsCardBloc(totalCustomersUsecase: sl()),
  );

  sl.registerFactory<ClientsBloc>(
    () => ClientsBloc(
      getCustomersUseCase: sl(),
      createCustomerUseCase: sl(),
      deleteCustomerUseCase: sl(),
    ),
  );

  sl.registerFactoryParam<FormularioClientesBloc, CustomerEntity?, void>(
    (customer, _) => FormularioClientesBloc(
      createCustomerUseCase: sl<CreateCustomerUseCase>(),
      updateCustomerUseCase: sl<UpdateCustomerUseCase>(),
      initialCustomer: customer,
    ),
  );

  // Features - Financial
  sl.registerLazySingleton<IFinancialRepository>(
    () => FinancialRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<IFinancialRemoteDataSource>(
    () => FinancialRemoteDataSource(sl()),
  );
  sl.registerLazySingleton(() => GetCashFlowUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));

  // Features - Sales
  sl.registerLazySingleton<ISalesRepository>(
    () => SalesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ISalesRemoteDataSource>(
    () => SalesRemoteDataSource(
      httpService: sl<HttpService>(),
      supabase: sl<SupabaseClient>(),
    ),
  );

  sl.registerLazySingleton<GetSalesUsecase>(
    () => GetSalesUsecase(repository: sl<ISalesRepository>()),
  );

  sl.registerLazySingleton<TotalSalesUsecase>(
    () => TotalSalesUsecase(repository: sl<ISalesRepository>()),
  );

  sl.registerLazySingleton<CreateSaleUseCase>(
    () => CreateSaleUseCase(repository: sl<ISalesRepository>()),
  );

  sl.registerLazySingleton<GetStudentsUseCase>(
    () => GetStudentsUseCase(repository: sl<ICustomersRepository>()),
  );

  sl.registerFactory<TotalSalesCardBloc>(
    () => TotalSalesCardBloc(totalSalesUsecase: sl()),
  );

  sl.registerFactory<SalesBloc>(
    () => SalesBloc(getSalesUsecase: sl<GetSalesUsecase>()),
  );

  sl.registerFactory<SalesFormBloc>(
    () => SalesFormBloc(
      getStudentsUseCase: sl<GetStudentsUseCase>(),
      createSaleUseCase: sl<CreateSaleUseCase>(),
    ),
  );

  // Features - Fiscal
  sl.registerLazySingleton<IFiscalRepository>(() => FiscalRepositoryImpl(sl()));
  sl.registerLazySingleton<IFiscalRemoteDataSource>(
    () => FiscalRemoteDataSource(sl()),
  );

  // Features - Inventory
  sl.registerLazySingleton<InventoryRemoteDatasource>(
    () => InventoryRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => FetchInventoryUseCase(sl()));
  sl.registerLazySingleton(() => AddHardwareUseCase(sl()));
  sl.registerLazySingleton(() => InventoryTransactionUseCase(sl()));
  sl.registerFactory(
    () => InventoryBloc(
      fetchInventoryUseCase: sl(),
      addHardwareUseCase: sl(),
      inventoryTransactionUseCase: sl(),
    ),
  );
}
