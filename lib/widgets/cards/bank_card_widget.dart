import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintyn/core/dimensions.dart';
import 'package:mintyn/core/images.dart';
import 'package:mintyn/widgets/common/gradient_border.dart';
import '../../core/constants.dart';
import '../../models/bank_card_model.dart';

class BankCardWidget extends StatefulWidget {
  final BankCardModel card;
  final bool isRevealed;
  final bool isSelected;
  final double scale;
  final double? width;
  final double? height;

  const BankCardWidget({
    super.key,
    required this.card,
    this.isRevealed = false,
    this.isSelected = true,
    this.scale = 1.0,
    this.width,
    this.height,

  });

  @override
  State<BankCardWidget> createState() => _BankCardWidgetState();
}

class _BankCardWidgetState extends State<BankCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
        vsync: this, duration: AppDurations.slow);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.isSelected ? 1.0 : 0.85,
      duration: AppDurations.normal,
      child: Container(
        width: widget.width?? AppSizes.bankCardWidth,
        height: widget.height ?? AppSizes.bankCardHeight,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImageAssets.dottedCard), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          color: const Color(0xFF1A1A1E),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: _NoiseTexture(),
            ),
            Padding(
              padding: EdgeInsets.all(20.dx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        _ChipIcon(),
                        SizedBox(width: 16.dx),
                        SvgPicture.asset(ImageAssets.tapPay, width: 18.dx, height: 18.dy,),
                      ]),
                      SvgPicture.asset(ImageAssets.mastercard, width: 28.dx, height: 21.dy),
                    ],
                  ),
                  SizedBox(height: 14.dy),
                  Text(
                    _buildCardNumber(),
                    style: AppTextStyles.body11.copyWith(
                      fontSize: 14.5,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: _CardField(
                          label: 'Card Holder',
                          value: widget.card.cardHolder,
                        ),
                      ),
                      _CardField(
                          label: 'Valid', value: widget.card.validDate),
                      SizedBox(width: 16.dx),
                      _CardField(
                        label: 'CVV',
                        value: widget.isRevealed ? widget.card.cvv : '•••',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.card.isFrozen)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.ac_unit_rounded,
                            color: Colors.lightBlueAccent, size: 36.dx),
                        SizedBox(height: 8.dy),
                        Text('Card Frozen',
                            style: AppTextStyles.bodyMdMedium),
                      ],
                    ),
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

  String _buildCardNumber() {
    final num = widget.card.cardNumber;
    final last4 = num.substring(num.length - 4);
    return widget.isRevealed
        ? '${num.substring(0, 4)} ${num.substring(4, 8)} '
            '${num.substring(8, 12)} ${num.substring(12)}'
        : '•••• •••• •••• $last4';
  }
}

class _CardField extends StatelessWidget {
  final String label;
  final String value;
  const _CardField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: AppTextStyles.smallXs
                .copyWith(color: Color(0xffBCBCBD))),
         SizedBox(height: 2.dy),
        Text(value,
            style: AppTextStyles.smallSmMedium
                .copyWith(color: Colors.white,)),
      ],
    );
  }
}

class _ChipIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.dx,
      height: 22.dy,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AA70),
        borderRadius: BorderRadius.circular(4.dx),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC690), Color(0xFFFFCFA3),Color(0xFFFFCEA1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
     child: SvgPicture.asset(ImageAssets.chip, width: 30.dx, height: 22.dy, )
    );
  }
}





class _NoiseTexture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(AppSizes.bankCardWidth, AppSizes.bankCardHeight),
      painter: _NoisePainter(),
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.015);
    final rng = DateTime.now().microsecondsSinceEpoch;
    for (int i = 0; i < 300; i++) {
      final x =
          ((rng * (i + 1) * 1234567) % size.width.toInt()).toDouble();
      final y =
          ((rng * (i + 2) * 7654321) % size.height.toInt()).toDouble();
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(_NoisePainter _) => false;
}

