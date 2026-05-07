import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/banking/banking_bloc.dart';
import '../../blocs/card/card_bloc.dart';
import '../../core/constants.dart';
import '../../core/router.dart';
import '../../screens/activity/activity_screen.dart';
import '../../widgets/cards/bank_card_widget.dart';
import '../../widgets/charts/spending_chart.dart';
import '../../widgets/common/transaction_item.dart';

class CardTransactionScreen extends StatefulWidget {
  const CardTransactionScreen({super.key});

  @override
  State<CardTransactionScreen> createState() =>
      _CardTransactionScreenState();
}

class _CardTransactionScreenState extends State<CardTransactionScreen> {
  int _selectedPeriodIndex = 0;
  static const _periods = ['Weekly', 'Monthly', 'Yearly'];

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
                      child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text('Card Transaction',
                      style: AppTextStyles.headingLg),
                  const Spacer(),
                  const Icon(Icons.more_horiz_rounded,
                      color: AppColors.textPrimary),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: BlocBuilder<CardBloc, CardState>(
                  builder: (context, cardState) {
                    final card = cardState.selectedCard;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(child: BankCardWidget(card: card!, width: 314, height: 190,)),
                        const SizedBox(height: 24),
                        BlocBuilder<BankingBloc, BankingState>(
                          buildWhen: (p, c) =>
                              p.monthlySpending != c.monthlySpending ||
                              p.totalSpend != c.totalSpend,
                          builder: (_, bankState) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20),
                            
                            decoration: BoxDecoration(
                              color: Color(0xff232325),
                              border: Border.all(color: Color(0xff272729),width: 2),
                              borderRadius: BorderRadius.circular(
                                  AppSizes.radiusLg),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(children: [
                                    Text('Total Spend  ',
                                        style: AppTextStyles.small22.copyWith(
                                          color: Color(0xffE9E9EA)
                                        )),
                                    Text(
                                      '${bankState.totalSpend.toStringAsFixed(0)}\$',
                                      style: AppTextStyles.headind22,
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => setState(
                                        () => _selectedPeriodIndex =
                                            (_selectedPeriodIndex + 1) %
                                                _periods.length,
                                      ),
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xff0047B3),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(children: [
                                          const Icon(
                                            Icons
                                                .keyboard_arrow_down_rounded,
                                            color: AppColors.textPrimary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _periods[_selectedPeriodIndex],
                                            style: AppTextStyles.smallMd
                                                .copyWith(
                                                    color:
                                                        AppColors.textPrimary),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ]),
                                ),
                                Divider(color: Color(0xff272729),),
                                const SizedBox(height: 16),
                                SpendingChart(
                                  data: bankState.monthlySpending,
                                  labels: const [
                                    'Jan', 'Feb', 'Mar',
                                    'Apr', 'May', 'Jun',
                                  ],
                                  height: 285,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                          Divider(color: Color(0xff272729),),
                        BlocBuilder<BankingBloc, BankingState>(
                          buildWhen: (p, c) =>
                              p.transactions != c.transactions,
                          builder: (_, bankState) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Transaction History',
                                        style: AppTextStyles.body22),
                                    GestureDetector(
                                      onTap: () => pushScreen(
                                        context,
                                        const ActivityScreen(),
                                      ),
                                      child: Text(
                                        'See all',
                                        style: AppTextStyles.bodySmMedium
                                            .copyWith(
                                                color: Color(0xff6BA6FF)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                ...bankState.transactions
                                    .take(4)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) => TransactionItem(
                                          transaction: e.value,
                                          animationDelay: e.key * 70,
                                        )),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}