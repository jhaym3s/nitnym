import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    final income = TransactionModel(
      id: 't1',
      title: 'Deposit',
      amount: 250.0,
      dateTime: DateTime(2024, 6, 1),
      type: TransactionType.deposit,
    );

    final expense = TransactionModel(
      id: 't2',
      title: 'Online Shopping',
      amount: -75.5,
      dateTime: DateTime(2024, 6, 2),
      type: TransactionType.onlineShopping,
    );

    group('constructor', () {
      test('creates instance with all fields', () {
        expect(income.id, 't1');
        expect(income.title, 'Deposit');
        expect(income.amount, 250.0);
        expect(income.dateTime, DateTime(2024, 6, 1));
        expect(income.type, TransactionType.deposit);
      });
    });

    group('isIncome getter', () {
      test('returns true for positive amount', () {
        expect(income.isIncome, isTrue);
      });

      test('returns false for negative amount', () {
        expect(expense.isIncome, isFalse);
      });

      test('returns false for zero amount', () {
        final zero = TransactionModel(
          id: 'tz',
          title: 'Zero',
          amount: 0,
          dateTime: DateTime.now(),
          type: TransactionType.banking,
        );
        expect(zero.isIncome, isFalse);
      });
    });

    group('formattedAmount getter', () {
      test('prefixes income with "+ "', () {
        expect(income.formattedAmount, '+ 250');
      });

      test('prefixes expense with "- "', () {
        expect(expense.formattedAmount, '- 76');
      });

      test('uses absolute value so the digits are always positive', () {
        final t = TransactionModel(
          id: 'tx',
          title: 'Saving',
          amount: -300,
          dateTime: DateTime.now(),
          type: TransactionType.saving,
        );
        expect(t.formattedAmount, '- 300');
      });

      test('rounds fractional amounts to nearest integer', () {
        final t = TransactionModel(
          id: 'tf',
          title: 'Donation',
          amount: -49.4,
          dateTime: DateTime.now(),
          type: TransactionType.donation,
        );
        expect(t.formattedAmount, '- 49');
      });
    });


  });
}