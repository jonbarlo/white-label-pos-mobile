import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  const AppLocalizations(this._locale);

  final Locale _locale;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  // Static properties for MaterialApp configuration
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('es', 'CR'),
    Locale('en', 'US'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? const AppLocalizations(Locale('es', 'CR'));
  }

  // Translation getters with locale support
  String get appTitle => _locale.languageCode == 'en' ? 'Mobile POS' : 'POS Móvil';
  String get login => _locale.languageCode == 'en' ? 'Login' : 'Iniciar Sesión';
  String get loginFailed => _locale.languageCode == 'en' ? 'Login Failed' : 'Error al Iniciar Sesión';
  String get loginError => _locale.languageCode == 'en' ? 'Login Error' : 'Error al Iniciar Sesión';
  String get welcomeBack => _locale.languageCode == 'en' ? 'Welcome Back :)' : '¡Bienvenido de Vuelta :)';
  String get loginSubtitle => _locale.languageCode == 'en' 
    ? 'To keep connected with us please login with your personal information'
    : 'Para mantenerte conectado con nosotros, por favor inicia sesión con tu información personal';
  String get enterBusinessSlug => _locale.languageCode == 'en' ? 'Enter your business slug' : 'Ingresa el slug de tu negocio';
  String get enterEmail => _locale.languageCode == 'en' ? 'Enter your email' : 'Ingresa tu correo';
  String get enterPassword => _locale.languageCode == 'en' ? 'Enter your password' : 'Ingresa tu contraseña';
  String get quickLogin => _locale.languageCode == 'en' ? 'Quick Login (Test User)' : 'Inicio Rápido (Usuario de Prueba)';
  String get loginNow => _locale.languageCode == 'en' ? 'Login Now' : 'Iniciar Sesión Ahora';
  String get email => _locale.languageCode == 'en' ? 'Email' : 'Correo Electrónico';
  String get password => _locale.languageCode == 'en' ? 'Password' : 'Contraseña';
  String get businessSlug => _locale.languageCode == 'en' ? 'Business Slug' : 'Slug del Negocio';
  String get dashboard => _locale.languageCode == 'en' ? 'Dashboard' : 'Panel Principal';
  String get settings => _locale.languageCode == 'en' ? 'Settings' : 'Configuración';
  String get logout => _locale.languageCode == 'en' ? 'Logout' : 'Cerrar Sesión';
  String get cancel => _locale.languageCode == 'en' ? 'Cancel' : 'Cancelar';
  String get confirm => _locale.languageCode == 'en' ? 'Confirm' : 'Confirmar';
  String get save => _locale.languageCode == 'en' ? 'Save' : 'Guardar';
  String get delete => _locale.languageCode == 'en' ? 'Delete' : 'Eliminar';
  String get back => _locale.languageCode == 'en' ? 'Back' : 'Atrás';
  String get next => _locale.languageCode == 'en' ? 'Next' : 'Siguiente';
  String get previous => _locale.languageCode == 'en' ? 'Previous' : 'Anterior';
  String get search => _locale.languageCode == 'en' ? 'Search' : 'Buscar';
  String get ok => 'OK';
  String get loading => _locale.languageCode == 'en' ? 'Loading...' : 'Cargando...';
  String get pointOfSaleSystem => _locale.languageCode == 'en' ? 'Point of Sale System' : 'Sistema de Punto de Venta';
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
} 