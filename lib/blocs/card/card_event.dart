part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object?> get props => [];
}


class CardTypeChanged extends CardEvent {
  const CardTypeChanged(this.type);
  final CardType type;

  @override
  List<Object?> get props => [type];
}


class CardSelected extends CardEvent {
  const CardSelected(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}


class CardFreezeToggled extends CardEvent {
  const CardFreezeToggled();
}


class CardQrPaymentToggled extends CardEvent {
  const CardQrPaymentToggled();
}


class CardOnlineShoppingToggled extends CardEvent {
  const CardOnlineShoppingToggled();
}


class CardTapPayToggled extends CardEvent {
  const CardTapPayToggled();
}


class CardRevealToggled extends CardEvent {
  const CardRevealToggled();
}