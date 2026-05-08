import 'package:flutter/material.dart';
import 'package:mintyn/blocs/banking/banking_bloc.dart';
import 'package:mintyn/core/dimensions.dart';
import 'package:mintyn/core/constants.dart';

class FilterTabs extends StatelessWidget {
  final TransactionFilter selected;
  final ValueChanged<TransactionFilter> onChanged;
  const FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _Tab(
          label: 'Weekly',
          isSelected: selected == TransactionFilter.weekly,
          onTap: () => onChanged(TransactionFilter.weekly)),
      SizedBox(width: 14.dx),
      _Tab(
          label: 'Monthly',
          isSelected: selected == TransactionFilter.monthly,
          onTap: () => onChanged(TransactionFilter.monthly)),
      SizedBox(width: 14.dx),
      _Tab(
          label: 'Today',
          isSelected: selected == TransactionFilter.today,
          onTap: () => onChanged(TransactionFilter.today)),
    ]);
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _Tab(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: EdgeInsets.symmetric(horizontal: 20.dx, vertical: 6.dy),
        decoration: BoxDecoration(
          color:  Color(0xFF232325),
          borderRadius: BorderRadius.circular(AppSizes.radiusX),
        ),
        child: Text(
          label,
          style:AppTextStyles.bodyS
        ),
      ),
    );
  }
}
