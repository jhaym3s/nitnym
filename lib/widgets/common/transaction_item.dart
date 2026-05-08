import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mintyn/core/dimensions.dart';
import '../../core/constants.dart';
import '../../models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final bool animate;
  final int animationDelay;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.animate = true,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedListItem(
      delay: animationDelay,
      animate: animate,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.dy),
            child: Row(
              children: [
                GradientBorderCircleButton(icon: transaction.icon,),
                SizedBox(width: 14.dx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.title,
                          style: AppTextStyles.body17),
                      SizedBox(height: 6.dy),
                      Text(_formatDateTime(transaction.dateTime),
                          style: AppTextStyles.small13),
                    ],
                  ),
                ),
                Text(
                  transaction.formattedAmount,
                  style: AppTextStyles.headingX.copyWith(
                    color: transaction.isIncome
                        ? AppColors.primary
                        : AppColors.expense,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final time = DateFormat('hh:mm a').format(dt);
    final date = DateFormat('MM-dd-yyyy').format(dt);
    return '$time · $date';
  }
}

class _AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool animate;

  const _AnimatedListItem({
    required this.child,
    required this.delay,
    required this.animate,
  });

  @override
  State<_AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<_AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    if (widget.animate) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.value = 1;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return widget.child;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide,
      child: widget.child),
    );
  }
}

class GradientBorderCircleButton extends StatelessWidget {
  const GradientBorderCircleButton({super.key, required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.dx),
      child: Container(
        width: 52.dx,
        height: 52.dx,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,   
            end: Alignment.bottomRight,
            colors: [
              Color(0xB3DCDCDC),           
              Color(0x07000000),           
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(1.5.dx), 
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF272729),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24.dx,
                height: 24.dx,
               
            ),
          ),
        ),
      ),
    ),
        );
  }
}
