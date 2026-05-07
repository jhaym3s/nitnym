import 'package:flutter/material.dart';
import 'package:mintyn/core/images.dart';

enum TransactionType {
  eWallet,
  onlineShopping,
  banking,
  saving,
  donation,
  deposit,
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime dateTime;
  final TransactionType type;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.dateTime,
    required this.type,
  });

  bool get isIncome => amount > 0;

  String get icon {
    switch (type) {
      case TransactionType.eWallet:
        return ImageAssets.wallet;
      case TransactionType.onlineShopping:
        return ImageAssets.shopping;
      case TransactionType.banking:
        return ImageAssets.fee;
      case TransactionType.saving:
        return ImageAssets.saving;
      case TransactionType.donation:
        return ImageAssets.donations;
      case TransactionType.deposit:
        return ImageAssets.deposit;
    }
  }

  String get formattedAmount {
    final prefix = isIncome ? '+ ' : '- ';
    return '$prefix${amount.abs().toStringAsFixed(0)}';
  }

  static List<TransactionModel> mockList = [
    TransactionModel(
      id: 't1',
      title: 'E wallet',
      amount: 100,
      dateTime: DateTime(2024, 12, 12, 12, 10),
      type: TransactionType.eWallet,
    ),
    TransactionModel(
      id: 't2',
      title: 'Online Shopping',
      amount: -100,
      dateTime: DateTime(2024, 12, 12, 12, 10),
      type: TransactionType.onlineShopping,
    ),
    TransactionModel(
      id: 't3',
      title: 'E wallet',
      amount: 100,
      dateTime: DateTime(2024, 12, 12, 12, 10),
      type: TransactionType.eWallet,
    ),
    TransactionModel(
      id: 't4',
      title: 'Banking Fee',
      amount: 100,
      dateTime: DateTime(2024, 12, 12, 12, 10),
      type: TransactionType.banking,
    ),
    TransactionModel(
      id: 't5',
      title: 'Saving',
      amount: -300,
      dateTime: DateTime(2024, 12, 12, 12, 10),
      type: TransactionType.saving,
    ),
    TransactionModel(
      id: 't6',
      title: 'Donation',
      amount: -50,
      dateTime: DateTime(2024, 12, 12, 12, 10),
      type: TransactionType.donation,
    ),
    TransactionModel(
      id: 't7',
      title: 'Deposit',
      amount: 500,
      dateTime: DateTime(2024, 12, 12, 12, 10),
      type: TransactionType.deposit,
    ),
  ];
}