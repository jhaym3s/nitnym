import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintyn/core/dimensions.dart';
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
              padding: EdgeInsets.fromLTRB(20.dx, 16.dy, 20.dx, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38.dx,
                      height: 38.dx,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary, size: 18.dx),
                    ),
                  ),
                  SizedBox(width: 14.dx),
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
            SizedBox(height: 20.dy),
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
                              EdgeInsets.symmetric(horizontal: 20.dx),
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
                        SizedBox(height: 30.dy),
                        SizedBox(
                          height: AppSizes.bankCardHeight + 24.dy,
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
                                    top: isSelected ? 0 : 16.dy,
                                    bottom: isSelected ? 0 : 16.dy,
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
                            padding: EdgeInsets.only(top: 15.dy),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(cards.length, (i) {
                                return AnimatedContainer(
                                  duration: AppDurations.normal,
                                  width: i == state.selectedCardIndex
                                      ? 28.dx
                                      : 8.dx,
                                  height: 8.dy,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 2.dx),
                                  decoration: BoxDecoration(
                                    color: i == state.selectedCardIndex
                                        ? AppColors.primary
                                        : Color(0xff9C9C9D),
                                    borderRadius: BorderRadius.circular(4.dx),
                                  ),
                                );
                              }),
                            ),
                          ),
                        SizedBox(height: 22.dy),
                        if (selected != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.dx),
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
                        SizedBox(height: 28.dy),
                        const Divider(color: AppColors.border, height: 1),
                        SizedBox(height: 24.dy),
                        if (selected != null) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.dx),
                            child: Text('Card Settings',
                                style: AppTextStyles.heading28),
                          ),
                          SizedBox(height: 14.dy),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.dx),
                            child: Column(children: [
                              SettingsRow(
                                icon: ImageAssets.changePin,
                                label: 'Change Pin',
                                toggleValue: true,
                                onToggle: (_) {},
                              ),
                              SizedBox(height: 17.dy),
                              SettingsRow(
                                icon: ImageAssets.qrPayment,
                                label: 'QR Payment',
                                toggleValue: selected.qrPaymentEnabled,
                                onToggle: (_) => context
                                    .read<CardBloc>()
                                    .add(const CardQrPaymentToggled()),
                              ),
                              SizedBox(height: 17.dy),
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
                              SizedBox(height: 17.dy),
                              
                              SettingsRow(
                                icon: ImageAssets.cardTransaction,
                                label: 'Card Transactions',
                                onTap: () => pushScreen(
                                  context,
                                  const CardTransactionScreen(),
                                ),
                              ),
                              SizedBox(height: 10.dy),
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
                          SizedBox(height: 32.dy),
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
          width: 46.dx,
          height: 46.dx,
          decoration: BoxDecoration(
            border: Border.all(
                color: isActive
                    ? AppColors.primary.withOpacity(0.5)
                    : Color(0xff272729),
                width: 1.dx),
            color: isActive
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.surfaceElevated,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: isActive ? AppColors.primary : AppColors.textPrimary,
              size: 22.dx),
        ),
        SizedBox(height: 8.dy),
        Text(label, style: AppTextStyles.smallSmMedium),
      ]),
    );
  }
}