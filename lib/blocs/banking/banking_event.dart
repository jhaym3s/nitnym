part of 'banking_bloc.dart';

abstract class BankingEvent extends Equatable {
  const BankingEvent();

  @override
  List<Object?> get props => [];
}

class BankingStarted extends BankingEvent {
  const BankingStarted();
}

class BankingFilterChanged extends BankingEvent {
  const BankingFilterChanged(this.filter);
  final TransactionFilter filter;

  @override
  List<Object?> get props => [filter];
}

