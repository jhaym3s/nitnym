import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsNotificationsToggled>(_onNotificationsToggled);
  }

  void _onNotificationsToggled(
      SettingsNotificationsToggled event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
        notificationsEnabled: !state.notificationsEnabled));
  }
}