import 'package:flutter_test/flutter_test.dart';
import 'package:mintyn/models/bank_card_model.dart';

void main() {
  group('BankCardModel', () {
    final physicalCard = BankCardModel(
      id: 'c1',
      cardNumber: '1234567890123456',
      cardHolder: 'John Doe',
      validDate: '12/28',
      cvv: '123',
      type: CardType.physical,
    );

    final virtualCard = BankCardModel(
      id: 'c2',
      cardNumber: '9876543210987654',
      cardHolder: 'Jane Smith',
      validDate: '06/27',
      cvv: '456',
      type: CardType.virtual,
    );

    group('constructor', () {
      test('creates instance with all provided fields', () {
        expect(physicalCard.id, 'c1');
        expect(physicalCard.cardNumber, '1234567890123456');
        expect(physicalCard.cardHolder, 'John Doe');
        expect(physicalCard.validDate, '12/28');
        expect(physicalCard.cvv, '123');
        expect(physicalCard.type, CardType.physical);
      });

      test('isFrozen defaults to false', () {
        expect(physicalCard.isFrozen, isFalse);
      });

      test('qrPaymentEnabled defaults to true', () {
        expect(physicalCard.qrPaymentEnabled, isTrue);
      });

      test('onlineShoppingEnabled defaults to false', () {
        expect(physicalCard.onlineShoppingEnabled, isFalse);
      });

      test('tapPayEnabled defaults to true', () {
        expect(physicalCard.tapPayEnabled, isTrue);
      });

      test('accepts explicit flag overrides', () {
        final card = BankCardModel(
          id: 'cx',
          cardNumber: '1111222233334444',
          cardHolder: 'Test User',
          validDate: '01/30',
          cvv: '000',
          type: CardType.virtual,
          isFrozen: true,
          qrPaymentEnabled: false,
          onlineShoppingEnabled: true,
          tapPayEnabled: false,
        );
        expect(card.isFrozen, isTrue);
        expect(card.qrPaymentEnabled, isFalse);
        expect(card.onlineShoppingEnabled, isTrue);
        expect(card.tapPayEnabled, isFalse);
      });
    });

    group('maskedNumber getter', () {
      test('masks all but last 4 digits with bullet groups', () {
        expect(physicalCard.maskedNumber, '•••• •••• •••• 3456');
      });

      test('works correctly for virtual card', () {
        expect(virtualCard.maskedNumber, '•••• •••• •••• 7654');
      });

      test('always starts with bullet characters', () {
        expect(physicalCard.maskedNumber.startsWith('••••'), isTrue);
      });
    });

    group('lastFour getter', () {
      test('returns last 4 characters of card number', () {
        expect(physicalCard.lastFour, '3456');
      });

      test('matches the trailing segment of maskedNumber', () {
        expect(virtualCard.lastFour, virtualCard.maskedNumber.split(' ').last);
      });

      test('is always exactly 4 characters long', () {
        expect(physicalCard.lastFour.length, 4);
        expect(virtualCard.lastFour.length, 4);
      });
    });

    group('copyWith', () {
      test('freezes the card', () {
        final frozen = physicalCard.copyWith(isFrozen: true);
        expect(frozen.isFrozen, isTrue);
      });

      test('does not mutate the original when freezing', () {
        physicalCard.copyWith(isFrozen: true);
        expect(physicalCard.isFrozen, isFalse);
      });

      test('disables QR payment', () {
        final updated = physicalCard.copyWith(qrPaymentEnabled: false);
        expect(updated.qrPaymentEnabled, isFalse);
      });

      test('enables online shopping', () {
        final updated = physicalCard.copyWith(onlineShoppingEnabled: true);
        expect(updated.onlineShoppingEnabled, isTrue);
      });

      test('disables tap pay', () {
        final updated = physicalCard.copyWith(tapPayEnabled: false);
        expect(updated.tapPayEnabled, isFalse);
      });

      test('preserves immutable fields after update', () {
        final updated = physicalCard.copyWith(isFrozen: true);
        expect(updated.id, physicalCard.id);
        expect(updated.cardNumber, physicalCard.cardNumber);
        expect(updated.cardHolder, physicalCard.cardHolder);
        expect(updated.validDate, physicalCard.validDate);
        expect(updated.cvv, physicalCard.cvv);
        expect(updated.type, physicalCard.type);
      });

      test('can update multiple flags simultaneously', () {
        final updated = physicalCard.copyWith(
          isFrozen: true,
          onlineShoppingEnabled: true,
          tapPayEnabled: false,
        );
        expect(updated.isFrozen, isTrue);
        expect(updated.onlineShoppingEnabled, isTrue);
        expect(updated.tapPayEnabled, isFalse);
        expect(updated.qrPaymentEnabled, isTrue); 
      });

    });

    group('CardType', () {
      test('physical card has CardType.physical', () {
        expect(physicalCard.type, CardType.physical);
      });

      test('virtual card has CardType.virtual', () {
        expect(virtualCard.type, CardType.virtual);
      });

      test('CardType has exactly two values', () {
        expect(CardType.values.length, 2);
      });
    });

  });
}