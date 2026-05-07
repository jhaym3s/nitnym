import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants.dart';

class AppToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppToggle({super.key, required this.value, this.onChanged});

  @override
  State<AppToggle> createState() => _AppToggleState();
}

class _AppToggleState extends State<AppToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _thumbPos;
  late Animation<Color?> _trackColor;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
      value: widget.value ? 1.0 : 0.0,
    );
    _thumbPos = _ctrl;
    _trackColor = ColorTween(
      begin: AppColors.surfaceElevated,
      end: AppColors.primary,
    ).animate(_ctrl);
  }

  @override
  void didUpdateWidget(AppToggle old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      widget.value ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double w = 44, h = 26, thumb = 20, padding = 3;
    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: _trackColor.value,
            borderRadius: BorderRadius.circular(h / 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Stack(
              children: [
                Positioned(
                  left: _thumbPos.value * (w - thumb - padding * 2),
                  top: 0,
                  child: Container(
                    width: thumb,
                    height: thumb,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  final String icon;
  final String label;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.toggleValue,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          (toggleValue != null ? () => onToggle?.call(!toggleValue!) : null),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xff232325),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF272729),
              child: SvgPicture.asset(icon, width: 24, height: 24),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: AppTextStyles.body17),
            ),
            if (toggleValue != null)
              AppToggle(value: toggleValue!, onChanged: onToggle)
            else
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}