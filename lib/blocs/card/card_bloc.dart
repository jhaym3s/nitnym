import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/bank_card_model.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardState.initial()) {
    on<CardTypeChanged>(_onTypeChanged);
    on<CardSelected>(_onCardSelected);
    on<CardFreezeToggled>(_onFreezeToggled);
    on<CardQrPaymentToggled>(_onQrPaymentToggled);
    on<CardOnlineShoppingToggled>(_onOnlineShoppingToggled);
    on<CardTapPayToggled>(_onTapPayToggled);
    on<CardRevealToggled>(_onRevealToggled);
  }

  void _onTypeChanged(CardTypeChanged event, Emitter<CardState> emit) {
    if (state.selectedCardType == event.type) return;
    emit(state.copyWith(
      selectedCardType: event.type,
      selectedCardIndex: 0,
      isRevealed: false,
    ));
  }

  void _onCardSelected(CardSelected event, Emitter<CardState> emit) {
    if (state.selectedCardIndex == event.index) return;
    emit(state.copyWith(
      selectedCardIndex: event.index,
      isRevealed: false,
    ));
  }

  void _onFreezeToggled(CardFreezeToggled event, Emitter<CardState> emit) {
    final card = state.selectedCard;
    if (card == null) return;
    final updated = state.cards.map((c) {
      return c.id == card.id ? c.copyWith(isFrozen: !c.isFrozen) : c;
    }).toList();
    emit(state.copyWith(cards: updated));
  }

  void _onQrPaymentToggled(
      CardQrPaymentToggled event, Emitter<CardState> emit) {
    final card = state.selectedCard;
    if (card == null) return;
    final updated = state.cards.map((c) {
      return c.id == card.id
          ? c.copyWith(qrPaymentEnabled: !c.qrPaymentEnabled)
          : c;
    }).toList();
    emit(state.copyWith(cards: updated));
  }

  void _onOnlineShoppingToggled(
      CardOnlineShoppingToggled event, Emitter<CardState> emit) {
    final card = state.selectedCard;
    if (card == null) return;
    final updated = state.cards.map((c) {
      return c.id == card.id
          ? c.copyWith(onlineShoppingEnabled: !c.onlineShoppingEnabled)
          : c;
    }).toList();
    emit(state.copyWith(cards: updated));
  }

  void _onTapPayToggled(CardTapPayToggled event, Emitter<CardState> emit) {
    final card = state.selectedCard;
    if (card == null) return;
    final updated = state.cards.map((c) {
      return c.id == card.id
          ? c.copyWith(tapPayEnabled: !c.tapPayEnabled)
          : c;
    }).toList();
    emit(state.copyWith(cards: updated));
  }

  void _onRevealToggled(CardRevealToggled event, Emitter<CardState> emit) {
    emit(state.copyWith(isRevealed: !state.isRevealed));
  }
}