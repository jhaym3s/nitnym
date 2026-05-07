import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintyn/core/images.dart';
import '../../blocs/banking/banking_bloc.dart';
import '../../core/constants.dart';
import '../../widgets/charts/spending_chart.dart';
import '../../widgets/common/transaction_item.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _activeTabIndex = 0;

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
                  const Text('My Activity', style: AppTextStyles.headingLg),
                  const Spacer(),
                  const Icon(Icons.more_horiz_rounded,
                      color: AppColors.textPrimary),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChartCard(),
                    const SizedBox(height: 20),
                    _buildRecentTransfers(),
                    const SizedBox(height: 24),
                    Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 16),
                    _buildTransactionHistory(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return BlocBuilder<BankingBloc, BankingState>(
      buildWhen: (p, c) =>
          p.user.totalBalance != c.user.totalBalance ||
          p.monthlySpending != c.monthlySpending,
      builder: (_, state) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color:Color(0xFF272729), width: 1.5),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.fromLTRB(14, 22, 14, 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color(0xFF272729), width: 1.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text('Total Spending',
                      style: AppTextStyles.body22.copyWith(
                        color: Color(0xFFE9E9EA)
                      )),
                  const SizedBox(height: 4),
                  TweenAnimationBuilder<double>(
                    tween:
                        Tween(begin: 0, end: state.user.totalBalance),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (_, val, __) => Text(
                      '${val.toStringAsFixed(0)}\$',
                      style: AppTextStyles.headingLg,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ActivityFilterTabs(
                    selected: _activeTabIndex,
                    onChanged: (i) =>
                        setState(() => _activeTabIndex = i),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: SpendingChart(
                data: state.monthlySpending,
                labels: const [
                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'
                ],
                height: 391,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransfers() {
    final colors = [
      Color(0xFFFFCD66),
      Color(0xFFCEF2E7),
      Color(0xFFA5A7FF),
      Color(0xFFFF5722),
    ];
    final images = [
      ImageAssets.avatar,
      ImageAssets.avatar1,
      ImageAssets.avatar2,
      ImageAssets.avatar3,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: Color(0xff232325),
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Transfer',
                      style: AppTextStyles.body22),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(4, (i) {
                          return Transform.translate(
                            offset: Offset(i * -8.0, 0),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                image:  DecorationImage(
                                  image: AssetImage(images[i % images.length]),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.textPrimary, width: 2),
                              ),
                           
                            ),
                          );
                        }),
                      ),
                      Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded,
                  color: Color(0xFF96C0FF), size: 20),
            ),
                    ],
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return BlocBuilder<BankingBloc, BankingState>(
      buildWhen: (p, c) => p.transactions != c.transactions,
      builder: (_, state) {
        final txs = state.transactions;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Transaction History',
                      style: AppTextStyles.headingXs),
                   Text('See All',
                      style: AppTextStyles.bodySm.copyWith(color: Color(0xFF6BA6FF))),
                ],
              ),
              const SizedBox(height: 8),
              ...txs.asMap().entries.map(
                    (e) => TransactionItem(
                      transaction: e.value,
                      animationDelay: e.key * 60,
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityFilterTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  static const _labels = ['Weekly', 'Monthly', 'Today', 'Year'];

  const _ActivityFilterTabs(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_labels.length, (i) {
        final isSel = i == selected;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xff272729),
              borderRadius: BorderRadius.circular(20),
              border: isSel
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
            ),
            child: Text(
              _labels[i],
              style: isSel
                  ? AppTextStyles.smallSm
                      .copyWith(color: Colors.white)
                  : AppTextStyles.smallSm.copyWith(color:Color(0xFF9C9C9D)),
            ),
          ),
        );
      }),
    );
  }
}