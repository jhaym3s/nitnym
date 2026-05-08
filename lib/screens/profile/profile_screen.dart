import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintyn/core/dimensions.dart';
import 'package:mintyn/core/images.dart';
import '../../blocs/banking/banking_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../core/constants.dart';
import '../../widgets/common/settings_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 18.dx,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.dx),
                  const Text('Profile', style: AppTextStyles.headingLg),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<BankingBloc, BankingState>(
                      buildWhen: (p, c) => p.user != c.user,
                      builder: (_, state) => Container(
                        color: AppColors.surface,
                        padding: EdgeInsets.fromLTRB(20.dx, 20.dy, 20.dx, 24.dy),
                        child: Row(
                          children: [
                              _AvatarWidget(name: state.user.name),
                            SizedBox(width: 11.dx),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        state.user.name,
                                        style: AppTextStyles.bodyMd,
                                      ),
                                      SizedBox(width: 11.dx),
                                      Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7.dx,
                                      vertical: 2.dy,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff272729),
                                      borderRadius: BorderRadius.circular(24.dx),
                                    ),
                                    child: Text(
                                      state.user.role,
                                      style: AppTextStyles.smallXxs.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                    ],
                                  ),
                                  SizedBox(height: 4.dy),
                                  Text(
                                    state.user.email,
                                    style: AppTextStyles.smallSmMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // const SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.dx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile Settings',
                            style: AppTextStyles.headingX,
                          ),
                          SizedBox(height: 17.dy),
                          SettingsRow(
                            icon: ImageAssets.doc,
                            label: 'E-Statement',
                            onTap: () {},
                          ),
                          SizedBox(height: 17.dy),
                          SettingsRow(
                            icon: ImageAssets.card,
                            label: 'Credit Card',
                            onTap: () {},
                          ),
                          SizedBox(height: 17.dy),
                          SettingsRow(
                            icon: ImageAssets.setting,
                            label: 'Settings',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 36.dy),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.dx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notification',
                            style: AppTextStyles.headingX,
                          ),
                          SizedBox(height: 17.dy),
                          BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, settings) => SettingsRow(
                              icon: ImageAssets.notification,
                              label: 'App Notification',
                              toggleValue: settings.notificationsEnabled,
                              onToggle: (_) => context.read<SettingsBloc>().add(
                                const SettingsNotificationsToggled(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 36.dy),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.dx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('More', style: AppTextStyles.headingX),
                          SizedBox(height: 17.dy),
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
                    SizedBox(height: 36.dy),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.dx),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.dx,
                          vertical: 9.dy,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD4D4),
                          borderRadius: BorderRadius.circular(2.dx),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Logout',
                              style: AppTextStyles.bodyLgMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF5A0000),
                              ),
                            ),
                            SizedBox(width: 8.dx),
                            SvgPicture.asset(
                              ImageAssets.logout,
                              width: 16.dx,
                              height: 16.dx,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.dy),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: const Text('Logout', style: AppTextStyles.headingXs),
        content: const Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Logout', style: AppTextStyles.bodyMdMedium),
          ),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  final String name;
  const _AvatarWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(ImageAssets.avatar),
          fit: BoxFit.cover,
        ),
        color: AppColors.primary.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.textPrimary),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD4D4),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Logout',
                style: AppTextStyles.bodyLgMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5A0000),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.logout_rounded,
                color: Color(0xFF5A0000),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
