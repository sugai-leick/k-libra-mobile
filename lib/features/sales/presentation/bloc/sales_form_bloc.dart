import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/domain/usecases/get_students_usecase.dart';
import 'package:flutter_app/features/sales/domain/entities/sale_entity.dart';
import 'package:flutter_app/features/sales/domain/usecases/create_sale_usecase.dart';

part 'sales_form_event.dart';
part 'sales_form_state.dart';

class SalesFormBloc extends Bloc<SalesFormEvent, SalesFormState> {
  final GetStudentsUseCase getStudentsUseCase;
  final CreateSaleUseCase createSaleUseCase;

  SalesFormBloc({
    required this.getStudentsUseCase,
    required this.createSaleUseCase,
  }) : super(const SalesFormState()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<ChangeSaleTypeEvent>(_onChangeSaleType);
    on<ChangePlanTypeEvent>(_onChangePlanType);
    on<ChangeSelectedItemEvent>(_onChangeSelectedItem);
    on<ChangeFinancialEvent>(_onChangeFinancial);
    on<ChangeSelectedStudentEvent>(_onChangeSelectedStudent);
    on<ChangeAddressEvent>(_onChangeAddressField);
    on<ToggleDifferentAddressEvent>(_onToggleDifferentAddress);
    on<UpdateFieldEvent>(_onUpdateField);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<SubmitSaleEvent>(_onSubmitSale);

    add(LoadStudentsEvent());
  }

  void _onChangeSaleType(ChangeSaleTypeEvent event, Emitter<SalesFormState> emit) {
    emit(state.copyWith(
      saleType: event.saleType,
      selectedItemId: null,
      selectedItemName: null,
    ));
  }

  void _onChangePlanType(ChangePlanTypeEvent event, Emitter<SalesFormState> emit) {
    emit(state.copyWith(planType: event.planType));
  }

  void _onChangeSelectedItem(ChangeSelectedItemEvent event, Emitter<SalesFormState> emit) {
    emit(state.copyWith(
      selectedItemId: event.itemId,
      selectedItemName: event.itemName,
    ));
  }

  void _onChangeFinancial(ChangeFinancialEvent event, Emitter<SalesFormState> emit) {
    emit(state.copyWith(
      valor: event.valor ?? state.valor,
      quantidade: event.quantidade ?? state.quantidade,
    ));
  }

  void _onChangeSelectedStudent(ChangeSelectedStudentEvent event, Emitter<SalesFormState> emit) {
    emit(state.copyWith(selectedCustomerId: event.studentId));
  }

  void _onChangeAddressField(ChangeAddressEvent event, Emitter<SalesFormState> emit) {
    final current = state.shippingAddress ?? const ShippingAddressEntity(
      nome: '', cep: '', rua: '', numero: '', bairro: '', cidade: '', estado: '',
    );
    
    emit(state.copyWith(
      shippingAddress: current.copyWith(
        nome: event.nome ?? current.nome,
        cep: event.cep ?? current.cep,
        rua: event.rua ?? current.rua,
        numero: event.numero ?? current.numero,
      ),
    ));
  }

  void _onToggleDifferentAddress(ToggleDifferentAddressEvent event, Emitter<SalesFormState> emit) {
    emit(state.copyWith(useDifferentAddress: event.useDifferentAddress));
  }

  String _generateRequestId() {
    return 'req_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  Future<void> _onLoadStudents(LoadStudentsEvent event, Emitter<SalesFormState> emit) async {
    emit(state.copyWith(isLoadingStudents: true));
    final result = await getStudentsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(isLoadingStudents: false, error: failure.msg)),
      (students) => emit(state.copyWith(isLoadingStudents: false, students: students)),
    );
  }

  void _onUpdateField(UpdateFieldEvent event, Emitter<SalesFormState> emit) {
    emit(event.updateState(state));
  }

  void _onUpdateAddress(UpdateAddressEvent event, Emitter<SalesFormState> emit) {
    final newAddress = event.updateAddress(state.shippingAddress ?? const ShippingAddressEntity(
      nome: '', cep: '', rua: '', numero: '', bairro: '', cidade: '', estado: '',
    ));
    emit(state.copyWith(shippingAddress: newAddress));
  }

  Future<void> _onSubmitSale(SubmitSaleEvent event, Emitter<SalesFormState> emit) async {
    if (state.selectedCustomerId == null) {
      emit(state.copyWith(error: 'Selecione um aluno primeiro.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null, isSuccess: false));

    // Mapeamento dinâmico baseado no tipo de oferta
    String? courseId;
    List<SaleItemEntity> items = [];

    if (state.saleType == 'course') {
      courseId = state.selectedItemId;
    } else {
      // Se for hardware ou insumo, adicionamos como item da venda
      if (state.selectedItemId != null) {
        items = [
          SaleItemEntity(
            productId: state.selectedItemId,
            quantidade: state.quantidade,
            valorUnitario: state.valor,
          ),
        ];
      }
    }

    final sale = SaleEntity(
      requestId: _generateRequestId(),
      customerId: state.selectedCustomerId!,
      saleType: state.saleType,
      courseSk: state.courseSk,
      courseId: courseId,
      planType: state.planType,
      quantidade: state.quantidade,
      valor: state.valor,
      desconto: state.desconto,
      frete: state.frete,
      shippingAddress: state.useDifferentAddress ? state.shippingAddress : null,
      items: items,
    );

    final result = await createSaleUseCase(sale);

    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, error: failure.msg)),
      (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }
}
