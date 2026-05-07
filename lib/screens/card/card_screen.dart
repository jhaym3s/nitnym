import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintyn/core/images.dart';
import 'package:mintyn/widgets/cards/card_type_tabs.dart';
import '../../blocs/card/card_bloc.dart';
import '../../core/constants.dart';
import '../../core/router.dart';
import '../../widgets/cards/bank_card_widget.dart';
import '../../widgets/common/settings_row.dart';
import 'card_transaction_screen.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.78);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  BlocBuilder<CardBloc, CardState>(
                    builder: (_, state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Card',
                            style: AppTextStyles.headingLg),
                        Text(
                          '${state.physicalCards.length} Physical Card, '
                          '${state.virtualCards.length} Virtual Card',
                          style: AppTextStyles.smallMd,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz_rounded,
                      color: AppColors.textPrimary),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<CardBloc, CardState>(
                builder: (context, state) {
                  final cards = state.visibleCards;
                  final selected = state.selectedCard;
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: CardTypeTabs(
                            selected: state.selectedCardType,
                            onChanged: (type) {
                              context
                                  .read<CardBloc>()
                                  .add(CardTypeChanged(type));
                              _pageController.jumpToPage(0);
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: AppSizes.bankCardHeight + 24,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: cards.length,
                            onPageChanged: (i) => context
                                .read<CardBloc>()
                                .add(CardSelected(i)),
                            itemBuilder: (_, i) {
                              final isSelected =
                                  i == state.selectedCardIndex;
                              return GestureDetector(
                                onTap: () => pushScreen(
                                  context,
                                  const CardTransactionScreen(),
                                ),
                                child: AnimatedPadding(
                                  duration: AppDurations.normal,
                                  padding: EdgeInsets.only(
                                    top: isSelected ? 0 : 16,
                                    bottom: isSelected ? 0 : 16,
                                  ),
                                  child: BankCardWidget(
                                    card: cards[i],
                                    isRevealed:state.isRevealed && isSelected,
                                    isSelected: isSelected,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (cards.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(cards.length, (i) {
                                return AnimatedContainer(
                                  duration: AppDurations.normal,
                                  width: i == state.selectedCardIndex
                                      ? 28
                                      : 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: i == state.selectedCardIndex
                                        ? AppColors.primary
                                        : Color(0xff9C9C9D),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                        const SizedBox(height: 22),
                        if (selected != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                _CardAction(
                                  icon: Icons.ac_unit_rounded,
                                  label: selected.isFrozen
                                      ? 'Unfreeze'
                                      : 'Freeze Card',
                                  isActive: selected.isFrozen,
                                  onTap: () => context
                                      .read<CardBloc>()
                                      .add(const CardFreezeToggled()),
                                ),
                                _CardAction(
                                  icon: state.isRevealed
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  label: 'Reveal',
                                  onTap: () => context
                                      .read<CardBloc>()
                                      .add(const CardRevealToggled()),
                                ),
                                _CardAction(
                                  icon: Icons.ac_unit_rounded,
                                  label: 'Freeze Card',
                                  onTap: () => context
                                      .read<CardBloc>()
                                      .add(const CardFreezeToggled()),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 28),
                        const Divider(color: AppColors.border, height: 1),
                        const SizedBox(height: 24),
                        if (selected != null) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Card Settings',
                                style: AppTextStyles.headingSm),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            child: Column(children: [
                              SettingsRow(
                                icon: ImageAssets.changePin,
                                label: 'Change Pin',
                                toggleValue: true,
                                onToggle: (_) {},
                              ),
                              const SizedBox(height: 10),
                              SettingsRow(
                                icon: ImageAssets.qrPayment,
                                label: 'QR Payment',
                                toggleValue: selected.qrPaymentEnabled,
                                onToggle: (_) => context
                                    .read<CardBloc>()
                                    .add(const CardQrPaymentToggled()),
                              ),
                              const SizedBox(height: 10),
                              SettingsRow(
                                icon: ImageAssets.onlineShopping,
                                label: 'Online Shopping',
                                toggleValue:
                                    selected.onlineShoppingEnabled,
                                onToggle: (_) => context
                                    .read<CardBloc>()
                                    .add(
                                        const CardOnlineShoppingToggled()),
                              ),
                              const SizedBox(height: 10),
                              
                              SettingsRow(
                                icon: ImageAssets.cardTransaction,
                                label: 'Card Transactions',
                                onTap: () => pushScreen(
                                  context,
                                  const CardTransactionScreen(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SettingsRow(
                                icon: ImageAssets.tapPay,
                                label: 'Tap Pay',
                                toggleValue: selected.tapPayEnabled,
                                onToggle: (_) => context
                                    .read<CardBloc>()
                                    .add(const CardTapPayToggled()),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class _CardAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  const _CardAction(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        AnimatedContainer(
          duration: AppDurations.normal,
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            border: Border.all(
                color: isActive
                    ? AppColors.primary.withOpacity(0.5)
                    : Color(0xff272729),
                width: 1),
            color: isActive
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.surfaceElevated,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: isActive ? AppColors.primary : AppColors.textPrimary,
              size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.smallSmMedium),
      ]),
    );
  }
}