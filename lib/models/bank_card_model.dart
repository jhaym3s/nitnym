enum CardType { physical, virtual }

class BankCardModel {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String validDate;
  final String cvv;
  final CardType type;
  bool isFrozen;
  bool qrPaymentEnabled;
  bool onlineShoppingEnabled;
  bool tapPayEnabled;

  BankCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.validDate,
    required this.cvv,
    required this.type,
    this.isFrozen = false,
    this.qrPaymentEnabled = true,
    this.onlineShoppingEnabled = false,
    this.tapPayEnabled = true,
  });

  String get maskedNumber =>
      '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';

  String get lastFour => cardNumber.substring(cardNumber.length - 4);

  BankCardModel copyWith({
    bool? isFrozen,
    bool? qrPaymentEnabled,
    bool? onlineShoppingEnabled,
    bool? tapPayEnabled,
  }) {
    return BankCardModel(
      id: id,
      cardNumber: cardNumber,
      cardHolder: cardHolder,
      validDate: validDate,
      cvv: cvv,
      type: type,
      isFrozen: isFrozen ?? this.isFrozen,
      qrPaymentEnabled: qrPaymentEnabled ?? this.qrPaymentEnabled,
      onlineShoppingEnabled:
          onlineShoppingEnabled ?? this.onlineShoppingEnabled,
      tapPayEnabled: tapPayEnabled ?? this.tapPayEnabled,
    );
  }

  static List<BankCardModel> mockCards = [
    BankCardModel(
      id: 'c1',
      cardNumber: '1234567890123466',
      cardHolder: 'Tayyab Sohail',
      validDate: '12/02/2024',
      cvv: '663',
      type: CardType.physical,
      isFrozen: false,
      qrPaymentEnabled: true,
      onlineShoppingEnabled: false,
      tapPayEnabled: true,
    ),
    BankCardModel(
      id: 'c2',
      cardNumber: '9876543210987654',
      cardHolder: 'Tayyab Sohail',
      validDate: '06/03/2025',
      cvv: '421',
      type: CardType.physical,
      isFrozen: false,
      qrPaymentEnabled: true,
      onlineShoppingEnabled: true,
      tapPayEnabled: false,
    ),
    BankCardModel(
      id: 'c3',
      cardNumber: '5555444433332222',
      cardHolder: 'Tayyab Sohail',
      validDate: '03/05/2026',
      cvv: '789',
      type: CardType.virtual,
    ),
  ];
}