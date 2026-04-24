part of 'sales_form_bloc.dart';

abstract class SalesFormEvent extends Equatable {
  const SalesFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentsEvent extends SalesFormEvent {}

class ChangeSaleTypeEvent extends SalesFormEvent {
  final String saleType;
  const ChangeSaleTypeEvent(this.saleType);
}

class ChangePlanTypeEvent extends SalesFormEvent {
  final String planType;
  const ChangePlanTypeEvent(this.planType);
}

class ToggleDifferentAddressEvent extends SalesFormEvent {
  final bool useDifferentAddress;
  const ToggleDifferentAddressEvent(this.useDifferentAddress);
}

class ChangeSelectedItemEvent extends SalesFormEvent {
  final String? itemId;
  final String? itemName;
  const ChangeSelectedItemEvent({this.itemId, this.itemName});
}

class ChangeFinancialEvent extends SalesFormEvent {
  final double? valor;
  final int? quantidade;
  const ChangeFinancialEvent({this.valor, this.quantidade});
}

class ChangeSelectedStudentEvent extends SalesFormEvent {
  final String? studentId;
  const ChangeSelectedStudentEvent(this.studentId);
}

class ChangeAddressEvent extends SalesFormEvent {
  final String? nome;
  final String? cep;
  final String? rua;
  final String? numero;
  const ChangeAddressEvent({this.nome, this.cep, this.rua, this.numero});
}

class SubmitSaleEvent extends SalesFormEvent {}

// Mantendo para compatibilidade temporária se necessário, mas vamos migrar
class UpdateFieldEvent extends SalesFormEvent {
  final SalesFormState Function(SalesFormState) updateState;
  const UpdateFieldEvent(this.updateState);
}

class UpdateAddressEvent extends SalesFormEvent {
  final ShippingAddressEntity Function(ShippingAddressEntity) updateAddress;
  const UpdateAddressEvent(this.updateAddress);
}
