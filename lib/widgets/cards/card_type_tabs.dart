import 'package:flutter/material.dart';
import 'package:mintyn/core/constants.dart';
import 'package:mintyn/models/bank_card_model.dart';

class CardTypeTabs extends StatelessWidget {
  final CardType selected;
  final ValueChanged<CardType> onChanged;
  const CardTypeTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff232323),
            borderRadius: BorderRadius.circular(22),
          ),
          child: _TypeTab(
              label: 'Physical Card',
              isSelected: selected == CardType.physical,
              onTap: () => onChanged(CardType.physical)),
        ),
        const SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff232323),
            borderRadius: BorderRadius.circular(22),
          ),
          child: _TypeTab(
              label: 'Virtual Card',
              isSelected: selected == CardType.virtual,
              onTap: () => onChanged(CardType.virtual)),
        ),
      ],
    );
  }
}


class _TypeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _TypeTab(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTextStyles.bodySmMedium
              : AppTextStyles.bodySm
                  .copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}