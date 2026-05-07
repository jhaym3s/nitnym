part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({this.notificationsEnabled = true});

  final bool notificationsEnabled;

  SettingsState copyWith({bool? notificationsEnabled}) {
    return SettingsState(
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [notificationsEnabled];
}