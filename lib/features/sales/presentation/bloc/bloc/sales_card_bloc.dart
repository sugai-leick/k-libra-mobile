import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'sales_card_event.dart';
part 'sales_card_state.dart';

class SalesCardBloc extends Bloc<SalesCardEvent, SalesCardState> {
  SalesCardBloc() : super(SalesCardInitial()) {
    on<SalesCardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
