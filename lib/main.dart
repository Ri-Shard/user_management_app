import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user_management_app/core/injection/injection.dart';
import 'package:user_management_app/presentation/blocs/app_bloc_provider.dart';
import 'package:user_management_app/presentation/pages/home_screen.dart';
import 'package:user_management_app/presentation/theme/app_theme.dart';

void main() {
  configureDependencies();
  runApp(const UserManagementApp());
}

class UserManagementApp extends StatelessWidget {
  const UserManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      child: MaterialApp(
        title: 'Gestión de Usuarios',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
        locale: const Locale('es', 'ES'),
      ),
    );
  }
}
