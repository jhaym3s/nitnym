import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintyn/core/images.dart';
import 'package:mintyn/widgets/common/home_balance_card.dart';
import 'package:mintyn/widgets/common/home_filter_tab.dart';
import '../../blocs/banking/banking_bloc.dart';
import '../../core/constants.dart';
import '../../core/router.dart';
import '../../screens/card/card_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../widgets/common/transaction_item.dart';
import '../../widgets/common/quick_action_button.dart';
import 'profile_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _headerFade =
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _headerCtrl, curve: Curves.easeOutCubic));
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffold,
      drawer: ProfileDrawer(
        onNavigateCard: () {
          Navigator.pop(context);
          pushScreen(context, const CardScreen());
        },
        onNavigateProfile: () {
          Navigator.pop(context);
          pushScreen(context, const ProfileScreen());
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildBalanceCard(),
                    const SizedBox(height: 32),
                    _buildQuickActions(),
                    const SizedBox(height: 32),
                    _buildTransactionSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return FadeTransition(
      opacity: _headerFade,
      child: SlideTransition(
        position: _headerSlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: const Icon(Icons.menu_rounded,
                      color: AppColors.textPrimary, size: 20),
                ),
              ),
              const Spacer(),
              BlocBuilder<BankingBloc, BankingState>(
                buildWhen: (p, c) => p.user.name != c.user.name,
                builder: (_, state) => RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyMd,
                    children: [
                      const TextSpan(text: 'Welcome  '),
                      TextSpan(
                          text: state.user.name,
                          style: AppTextStyles.bodyLg),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.surfaceElevated,
                child: SvgPicture.asset(ImageAssets.notification, width: 18, height: 18, color: AppColors.textPrimary,),
              ),
              
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<BankingBloc, BankingState>(
        buildWhen: (p, c) =>
            p.user.totalBalance != c.user.totalBalance ||
            p.isLoading != c.isLoading,
        builder: (context, state) => HomeBalanceCard(
          balance: state.user.totalBalance,
          isLoading: state.isLoading,
          onAddCash: () {},
          onSendMoney: () {},
        ),
      ),
    );
  }


  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          QuickActionButton(
              icon: SvgPicture.asset(
                          ImageAssets.billPay,
                          width: 20,
                          height: 20,
                        ),
              label: 'Bill Pay',
              onTap: () {}),
          _VerticalDivider(),
          QuickActionButton(
              icon: SvgPicture.asset(
                          ImageAssets.donations,
                          width: 22,
                          height: 21,
                        ),
              label: 'Donations',
              onTap: () {}),
          _VerticalDivider(),
          QuickActionButton(
              icon: SvgPicture.asset(
                          ImageAssets.deposit,
                          width: 19,
                          height: 19,
                        ),
              label: 'Deposit',
              onTap: () {}),
          _VerticalDivider(),
          QuickActionButton(
              icon: SvgPicture.asset(
                          ImageAssets.more,
                          width: 18,
                          height: 18,
                        ),
              label: 'More',
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildTransactionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Transaction History',
                  style: AppTextStyles.headingX),
              Text('See all',
                  style: AppTextStyles.bodySm
                      .copyWith(color: Color(0xff6BA6FF))),
            ],
          ),
          const SizedBox(height: 11),
          BlocBuilder<BankingBloc, BankingState>(
            buildWhen: (p, c) => p.filter != c.filter,
            builder: (context, state) => FilterTabs(
              selected: state.filter,
              onChanged: (f) =>
                  context.read<BankingBloc>().add(BankingFilterChanged(f)),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<BankingBloc, BankingState>(
            buildWhen: (p, c) =>
                p.transactions != c.transactions ||
                p.filter != c.filter,
            builder: (_, state) {
              final txs = state.allTransactions;
              if (txs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No transactions',
                        style: AppTextStyles.smallMd),
                  ),
                );
              }
              return Column(
                children: txs
                    .asMap()
                    .entries
                    .map((e) => TransactionItem(
                          transaction: e.value,
                          animationDelay: e.key * 60,
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

}



class _VerticalDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: AppColors.border);
}



