import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintyn/core/dimensions.dart';
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
                  const Text('My Activity', style: AppTextStyles.headingLg),
                  const Spacer(),
                  const Icon(Icons.more_horiz_rounded,
                      color: AppColors.textPrimary),
                ],
              ),
            ),
            SizedBox(height: 30.dy),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChartCard(),
                    SizedBox(height: 20.dy),
                    _buildRecentTransfers(),
                    SizedBox(height: 24.dy),
                    Divider(color: AppColors.border, height: 1),
                    SizedBox(height: 16.dy),
                    _buildTransactionHistory(),
                    SizedBox(height: 32.dy),
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
        margin: EdgeInsets.symmetric(horizontal: 20.dx),
        decoration: BoxDecoration(
          border: Border.all(color:Color(0xFF272729), width: 1.5.dx),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.fromLTRB(14.dx, 22.dy, 14.dx, 20.dy),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color(0xFF272729), width: 1.5.dx),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text('Total Spending',
                      style: AppTextStyles.body22.copyWith(
                        color: Color(0xFFE9E9EA)
                      )),
                  SizedBox(height: 4.dy),
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
                  SizedBox(height: 12.dy),
                  _ActivityFilterTabs(
                    selected: _activeTabIndex,
                    onChanged: (i) =>
                        setState(() => _activeTabIndex = i),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16.dy, 0, 0),
              child: SpendingChart(
                data: state.monthlySpending,
                labels: const [
                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'
                ],
                height: 391.dy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransfers() {
    final images = [
      ImageAssets.avatar,
      ImageAssets.avatar1,
      ImageAssets.avatar2,
      ImageAssets.avatar3,
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.dx),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.dy, horizontal: 18.dx),
        decoration: BoxDecoration(
          color: Color(0xff232325),
          border: Border.all(color: AppColors.border, width: 1.dx),
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
                  SizedBox(height: 12.dy),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(4, (i) {
                          return Transform.translate(
                            offset: Offset(i * -8.0.dx, 0),
                            child: Container(
                              width: 42.dx,
                              height: 42.dx,
                              decoration: BoxDecoration(
                                image:  DecorationImage(
                                  image: AssetImage(images[i % images.length]),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.textPrimary, width: 2.dx),
                              ),
                           
                            ),
                          );
                        }),
                      ),
                      Container(
              width: 36.dx,
              height: 36.dx,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_rounded,
                  color: Color(0xFF96C0FF), size: 20.dx),
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
          padding: EdgeInsets.symmetric(horizontal: 20.dx),
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
              SizedBox(height: 8.dy),
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
            padding: EdgeInsets.symmetric(
                horizontal: 14.dx, vertical: 6.dy),
            decoration: BoxDecoration(
              color: Color(0xff272729),
              borderRadius: BorderRadius.circular(20.dx),
              border: isSel
                  ? Border.all(color: AppColors.primary, width: 1.5.dx)
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