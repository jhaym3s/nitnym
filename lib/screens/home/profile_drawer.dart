import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintyn/core/images.dart';
import '../../blocs/banking/banking_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../core/constants.dart';
import '../../widgets/common/settings_row.dart';

class ProfileDrawer extends StatelessWidget {
  final VoidCallback onNavigateCard;
  final VoidCallback onNavigateProfile;

  const ProfileDrawer({
    super.key,
    required this.onNavigateCard,
    required this.onNavigateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<BankingBloc, BankingState>(
                buildWhen: (p, c) => p.user != c.user,
                builder: (_, state) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DrawerAvatar(),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome', style: AppTextStyles.body12),
                          Text(state.user.name, style: AppTextStyles.heading13),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Profile Settings', style: AppTextStyles.headingX),
              ),
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SettingsRow(
                      icon: ImageAssets.doc,
                      label: 'E-Statement',
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 17),
                    SettingsRow(
                      icon: ImageAssets.card,
                      label: 'Credit Card',
                      onTap: onNavigateCard,
                    ),
                    const SizedBox(height: 17),
                    SettingsRow(
                      icon: ImageAssets.setting,
                      label: 'Settings',
                      onTap: onNavigateProfile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Notification', style: AppTextStyles.headingX),
              ),
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settings) => SettingsRow(
                    icon: ImageAssets.notification,
                    label: 'App Notification',
                    toggleValue: settings.notificationsEnabled,
                    onToggle: (_) => context.read<SettingsBloc>().add(
                      const SettingsNotificationsToggled(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 34),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('More', style: AppTextStyles.headingX),
              ),
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SettingsRow(
                      icon: ImageAssets.language,
                      label: 'Language',
                      onTap: () {},
                    ),
                    const SizedBox(height: 17),
                    SettingsRow(
                      icon: ImageAssets.country,
                      label: 'Country',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _LogoutButton(onTap: () {}),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerAvatar extends StatelessWidget {
  const _DrawerAvatar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 59,
              height: 59,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(ImageAssets.avatar),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffE6F0FF),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  ImageAssets.edit,
                  width: 7,
                  height: 7,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LogoutButton extends StatefulWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.94,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD4D4),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Logout',
                style: AppTextStyles.body17.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5A0000),
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                ImageAssets.logout,
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
