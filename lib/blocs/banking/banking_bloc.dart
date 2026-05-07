import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../models/transaction_model.dart';

part 'banking_event.dart';
part 'banking_state.dart';

class BankingBloc extends Bloc<BankingEvent, BankingState> {
  BankingBloc() : super(BankingState.initial()) {
    on<BankingStarted>(_onStarted);
    on<BankingFilterChanged>(_onFilterChanged);
  }

  void _onStarted(BankingStarted event, Emitter<BankingState> emit) {
    emit(BankingState.initial());
  }

  void _onFilterChanged(
      BankingFilterChanged event, Emitter<BankingState> emit) {
    if (state.filter == event.filter) return;
    emit(state.copyWith(filter: event.filter));
  }

}