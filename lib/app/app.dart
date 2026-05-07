import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/banking/banking_bloc.dart';
import '../blocs/card/card_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../screens/home/home_screen.dart';
import 'theme.dart';


class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BankingBloc()..add(const BankingStarted()),
        ),
        BlocProvider(create: (_) => CardBloc()),
        BlocProvider(create: (_) => SettingsBloc()),
      ],
      child: MaterialApp(
        title: 'Banking App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeScreen(),
      ),
    );
  }
}