part of 'sales_bloc.dart';

@immutable
sealed class SalesEvent {}

class FetchSalesRequested extends SalesEvent {}
