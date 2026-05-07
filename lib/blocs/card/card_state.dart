part of 'card_bloc.dart';

/// Immutable card management state.
class CardState extends Equatable {
  const CardState({
    required this.cards,
    this.selectedCardType = CardType.physical,
    this.selectedCardIndex = 0,
    this.isRevealed = false,
  });

  final List<BankCardModel> cards;
  final CardType selectedCardType;
  final int selectedCardIndex;
  final bool isRevealed;


  List<BankCardModel> get physicalCards =>
      cards.where((c) => c.type == CardType.physical).toList();

  List<BankCardModel> get virtualCards =>
      cards.where((c) => c.type == CardType.virtual).toList();

  List<BankCardModel> get visibleCards =>
      selectedCardType == CardType.physical ? physicalCards : virtualCards;

  BankCardModel? get selectedCard {
    final visible = visibleCards;
    if (visible.isEmpty || selectedCardIndex >= visible.length) return null;
    return visible[selectedCardIndex];
  }


  CardState copyWith({
    List<BankCardModel>? cards,
    CardType? selectedCardType,
    int? selectedCardIndex,
    bool? isRevealed,
  }) {
    return CardState(
      cards: cards ?? this.cards,
      selectedCardType: selectedCardType ?? this.selectedCardType,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  @override
  List<Object?> get props => [
        cards,
        selectedCardType,
        selectedCardIndex,
        isRevealed,
      ];

  factory CardState.initial() =>
      CardState(cards: BankCardModel.mockCards);
}