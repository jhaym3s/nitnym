import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintyn/core/images.dart';
import '../../blocs/banking/banking_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../core/constants.dart';
import '../../core/dimensions.dart';
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
                  padding: EdgeInsets.fromLTRB(20.dx, 24.dy, 20.dx, 8.dy),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onNavigateProfile,
                        child: _DrawerAvatar()),
                      SizedBox(height: 8.dy),
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
               Divider(color: AppColors.border, height: 1.dy),
              SizedBox(height: 8.dy),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.dx),
                child: Text('Profile Settings', style: AppTextStyles.headingX),
              ),
              SizedBox(height: 17.dy),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.dx),
                child: Column(
                  children: [
                    SettingsRow(
                      icon: ImageAssets.doc,
                      label: 'E-Statement',
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(height: 17.dy),
                    SettingsRow(
                      icon: ImageAssets.card,
                      label: 'Credit Card',
                      onTap: onNavigateCard,
                    ),
                    SizedBox(height: 17.dy),
                    SettingsRow(
                      icon: ImageAssets.setting,
                      label: 'Settings',
                      onTap: onNavigateProfile,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 34.dy),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.dx),
                child: Text('Notification', style: AppTextStyles.headingX),
              ),
              SizedBox(height: 17.dy),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.dx),
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
              SizedBox(height: 34.dy),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.dx),
                child: Text('More', style: AppTextStyles.headingX),
              ),
              SizedBox(height: 17.dy),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.dx),
                child: Column(
                  children: [
                    SettingsRow(
                      icon: ImageAssets.language,
                      label: 'Language',
                      onTap: () {},
                    ),
                    SizedBox(height: 17.dy),
                    SettingsRow(
                      icon: ImageAssets.country,
                      label: 'Country',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26.dy),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.dx),
                child: _LogoutButton(onTap: () {}),
              ),
              SizedBox(height: 40.dy),
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
              width: 59.dx,
              height: 59.dy,
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
                width: 16.dx,
                height: 16.dy,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffE6F0FF),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  ImageAssets.edit,
                  width: 7.dx,
                  height: 7.dy,
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
          padding: EdgeInsets.symmetric(horizontal: 20.dx, vertical: 13.dy),
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
              SizedBox(width: 8.dx),
              SvgPicture.asset(
                ImageAssets.logout,
                width: 16.dx,
                height: 16.dy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
