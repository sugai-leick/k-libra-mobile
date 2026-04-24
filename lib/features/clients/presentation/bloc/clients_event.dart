part of 'clients_bloc.dart';

@immutable
sealed class ClientsEvent {}

class FetchClientsListEvent extends ClientsEvent {
  final String? type;
  final String? pending;
  final String? filter;

  FetchClientsListEvent({this.type, this.pending, this.filter});
}

class AddClientEvent extends ClientsEvent {
  final CustomerEntity customer;
  AddClientEvent(this.customer);
}

class DeleteClientEvent extends ClientsEvent {
  final String clientId;
  DeleteClientEvent(this.clientId);
}
