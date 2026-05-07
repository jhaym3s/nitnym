import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintyn/core/constants.dart';
import 'package:mintyn/core/images.dart';
import 'package:mintyn/widgets/common/gradient_border.dart';

class HomeBalanceCard extends StatefulWidget {
  final double balance;
  final bool isLoading;
  final VoidCallback onAddCash;
  final VoidCallback onSendMoney;

  const HomeBalanceCard({super.key, 
    required this.balance,
    required this.isLoading,
    required this.onAddCash,
    required this.onSendMoney,
  });

  @override
  State<HomeBalanceCard> createState() => _HomeBalanceCardState();
}

class _HomeBalanceCardState extends State<HomeBalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Stack(
          children: [
            Container(
             decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(ImageAssets.homeDottedCard), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                color: const Color(0xFF1A1A1E),
              ),
              child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 12, 15, 39),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              ImageAssets.mastercard,
                              width: 42,
                              height: 32,
                            )],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Balance',
                                    style: AppTextStyles.headingXs.copyWith(
                                      color: Color(0xffE9E9EA),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: widget.balance),
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.easeOutCubic,
                                    builder: (_, val, _) => Text(
                                      '1200\$',
                                      style: AppTextStyles.headingMd
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xff2E2E2E),
                                shape: BoxShape.circle,
                              ),
                              child: widget.isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary),
                                    )
                                  : const Icon(Icons.qr_code_2_rounded,
                                      color: AppColors.textPrimary, size: 24),
                            ),
                            SizedBox(width: 25)
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BalanceButton(
                              icon: Icons.add,
                              label: 'Add Cash',
                              onTap: widget.onAddCash,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: _BalanceButton(
                                icon: Icons.arrow_outward_rounded,
                                label: 'Send Money',
                                onTap: widget.onSendMoney,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              ),
            ),
          
           Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: GradientBorderPainter(
                    borderRadius: AppSizes.radiusLg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class MastercardLogo extends StatelessWidget {
  const MastercardLogo();

  @override
  Widget build(BuildContext context) {
    const double circle = 22;
    const double overlap = 8;
    const double totalW = circle * 2 - overlap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: totalW,
          height: circle,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: Container(
                  width: circle,
                  height: circle,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEB001B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: circle - overlap,
                child: Container(
                  width: circle,
                  height: circle,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF79E1B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'mastercard',
          style: AppTextStyles.smallSm.copyWith(
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _BalanceButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BalanceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_BalanceButton> createState() => _BalanceButtonState();
}

class _BalanceButtonState extends State<_BalanceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.label,
                  style: AppTextStyles.bodyXX,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
