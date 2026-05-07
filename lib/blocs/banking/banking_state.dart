part of 'banking_bloc.dart';

enum TransactionFilter { weekly, monthly, today }

class BankingState extends Equatable {
  const BankingState({
    required this.user,
    required this.transactions,
    required this.monthlySpending,
    this.filter = TransactionFilter.weekly,
    this.isLoading = false,
  });

  final UserModel user;
  final List<TransactionModel> transactions;
  final List<double> monthlySpending;
  final TransactionFilter filter;
  final bool isLoading;


  List<TransactionModel> get filteredTransactions {
    final now = DateTime.now();
    switch (filter) {
      case TransactionFilter.today:
        return transactions
            .where((t) =>
                t.dateTime.year == now.year &&
                t.dateTime.month == now.month &&
                t.dateTime.day == now.day)
            .toList();
      case TransactionFilter.weekly:
        final weekAgo = now.subtract(const Duration(days: 7));
        return transactions
            .where((t) => t.dateTime.isAfter(weekAgo))
            .toList();
      case TransactionFilter.monthly:
        return transactions
            .where((t) =>
                t.dateTime.year == now.year &&
                t.dateTime.month == now.month)
            .toList();
    }
  }

  List<TransactionModel> get allTransactions => transactions;

  double get totalSpend => transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount.abs());


  BankingState copyWith({
    UserModel? user,
    List<TransactionModel>? transactions,
    List<double>? monthlySpending,
    TransactionFilter? filter,
    bool? isLoading,
  }) {
    return BankingState(
      user: user ?? this.user,
      transactions: transactions ?? this.transactions,
      monthlySpending: monthlySpending ?? this.monthlySpending,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        user,
        transactions,
        monthlySpending,
        filter,
        isLoading,
      ];


  factory BankingState.initial() => BankingState(
        user: UserModel.mock,
        transactions: TransactionModel.mockList,
        monthlySpending: const [1200, 3657, 4200, 3800, 4800, 6100],
      );
}