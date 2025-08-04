import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/core/localization/app_localizations.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('AppLocalizations should provide Spanish translations by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: const TestLocalizationWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show Spanish by default (es_CR is main locale)
      expect(find.text('¡Bienvenido de Vuelta :)'), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('Correo Electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
    });

    testWidgets('AppLocalizations should provide English translations when locale is set', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en', 'US'),
            home: const TestLocalizationWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show English when locale is set to en_US
      expect(find.text('Welcome Back :)'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('Dashboard should show localized strings', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: const TestDashboardWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show Spanish dashboard strings
      expect(find.text('Panel Principal'), findsOneWidget);
      expect(find.text('Resumen de Ventas'), findsOneWidget);
      expect(find.text('Ventas de Hoy'), findsOneWidget);
      expect(find.text('Transacciones'), findsOneWidget);
      expect(find.text('Pedido Promedio'), findsOneWidget);
    });

    testWidgets('Language Settings should show localized strings', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en', 'US'),
            home: const TestLanguageSettingsWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show English language settings strings
      expect(find.text('Language Settings'), findsOneWidget);
      expect(find.text('Language Status'), findsOneWidget);
      expect(find.text('Current Language'), findsOneWidget);
      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('Information'), findsOneWidget);
    });

    testWidgets('Profile Screen should show localized strings', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: const TestProfileWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show Spanish profile strings
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.text('Información Personal'), findsOneWidget);
      expect(find.text('Información Laboral'), findsOneWidget);
      expect(find.text('Configuración de Cuenta'), findsOneWidget);
      expect(find.text('Soporte y Ayuda'), findsOneWidget);
      expect(find.text('Cerrar Sesión'), findsOneWidget);
    });

    testWidgets('Business Management should show localized strings', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: const TestBusinessManagementWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show Spanish business management strings
      expect(find.text('Gestión de Negocios'), findsOneWidget);
      expect(find.text('No se encontraron negocios'), findsOneWidget);
      expect(find.text('Agrega tu primer negocio para comenzar'), findsOneWidget);
      expect(find.text('Activo'), findsOneWidget);
      expect(find.text('Inactivo'), findsOneWidget);
      expect(find.text('Editar'), findsOneWidget);
      expect(find.text('Eliminar'), findsOneWidget);
    });

    testWidgets('Floor Plan Management should show localized strings', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en', 'US'),
            home: const TestFloorPlanManagementWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show English floor plan management strings
      expect(find.text('Floor Plan Management'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Floor Plans'), findsOneWidget);
      expect(find.text('Tables'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Table Status Overview'), findsOneWidget);
      expect(find.text('Total Tables'), findsOneWidget);
      expect(find.text('Available'), findsOneWidget);
      expect(find.text('Occupied'), findsOneWidget);
      expect(find.text('Reserved'), findsOneWidget);
      expect(find.text('Cleaning'), findsOneWidget);
    });

    testWidgets('POS Screen should show localized strings (Spanish)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: const TestPosScreenWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show Spanish POS strings
      expect(find.text('Carrito'), findsOneWidget);
      expect(find.text('Acciones'), findsOneWidget);
      expect(find.text('Invitado'), findsOneWidget);
      expect(find.text('Menú'), findsOneWidget);
      expect(find.text('Pedidos'), findsOneWidget);
      expect(find.text('Transacciones'), findsOneWidget);
      expect(find.text('Inventario'), findsOneWidget);
      expect(find.text('Más'), findsOneWidget);
      expect(find.text('Cajero'), findsOneWidget);
      expect(find.text('Servicio POS'), findsOneWidget);
    });

    testWidgets('Inventory Screen should show localized strings (English)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en', 'US'),
            home: const TestInventoryScreenWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show English inventory strings
      expect(find.text('Inventory'), findsOneWidget);
      expect(find.text('All Items'), findsOneWidget);
      expect(find.text('Low Stock'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Search Inventory'), findsOneWidget);
      expect(find.text('Filter Options'), findsOneWidget);
      expect(find.text('Add New Item'), findsOneWidget);
      expect(find.text('Edit Item'), findsOneWidget);
      expect(find.text('Update Stock'), findsOneWidget);
      expect(find.text('Delete Item'), findsOneWidget);
    });

    testWidgets('Split Payment Dialog should show localized strings (Spanish)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: const TestSplitPaymentDialogWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show Spanish split payment strings
      expect(find.text('Pago Dividido'), findsOneWidget);
      expect(find.text('Nombre del Cliente'), findsOneWidget);
      expect(find.text('Teléfono del Cliente'), findsOneWidget);
      expect(find.text('Email del Cliente'), findsOneWidget);
      expect(find.text('Notas'), findsOneWidget);
      expect(find.text('Métodos de Pago'), findsOneWidget);
      expect(find.text('Agregar Pago'), findsOneWidget);
      expect(find.text('Monto'), findsOneWidget);
      expect(find.text('Método de Pago'), findsOneWidget);
      expect(find.text('Efectivo'), findsOneWidget);
      expect(find.text('Tarjeta de Crédito'), findsOneWidget);
      expect(find.text('Tarjeta de Débito'), findsOneWidget);
      expect(find.text('Pago Móvil'), findsOneWidget);
      expect(find.text('Cheque'), findsOneWidget);
      expect(find.text('Completar Pago Dividido'), findsOneWidget);
    });

    testWidgets('Customer Selection Dialog should show localized strings (English)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en', 'US'),
            home: const TestCustomerSelectionDialogWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show English customer selection strings
      expect(find.text('Select Customer'), findsOneWidget);
      expect(find.text('New Customer'), findsOneWidget);
      expect(find.text('Guest Checkout'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Search Results'), findsOneWidget);
      expect(find.text('No email'), findsOneWidget);
      expect(find.text('No phone'), findsOneWidget);
      expect(find.text('No customers found'), findsOneWidget);
      expect(find.text('Create Customer'), findsOneWidget);
    });
  });
}

class TestLocalizationWidget extends StatelessWidget {
  const TestLocalizationWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          Text(l10n.welcomeBack),
          Text(l10n.login),
          Text(l10n.email),
          Text(l10n.password),
        ],
      ),
    );
  }
}

class TestDashboardWidget extends StatelessWidget {
  const TestDashboardWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
      ),
      body: Column(
        children: [
          Text(l10n.salesOverview),
          Text(l10n.todaysSales),
          Text(l10n.transactions),
          Text(l10n.avgOrder),
        ],
      ),
    );
  }
}

class TestLanguageSettingsWidget extends StatelessWidget {
  const TestLanguageSettingsWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
      ),
      body: Column(
        children: [
          Text(l10n.languageStatus),
          Text(l10n.currentLanguage),
          Text(l10n.selectLanguage),
          Text(l10n.information),
        ],
      ),
    );
  }
}

class TestProfileWidget extends StatelessWidget {
  const TestProfileWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: Column(
        children: [
          Text(l10n.personalInformation),
          Text(l10n.workInformation),
          Text(l10n.accountSettings),
          Text(l10n.supportAndHelp),
          Text(l10n.logout),
        ],
      ),
    );
  }
}

class TestBusinessManagementWidget extends StatelessWidget {
  const TestBusinessManagementWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.businessManagement),
      ),
      body: Column(
        children: [
          Text(l10n.noBusinessesFound),
          Text(l10n.addFirstBusinessToGetStarted),
          Text(l10n.active),
          Text(l10n.inactive),
          Text(l10n.edit),
          Text(l10n.delete),
        ],
      ),
    );
  }
}

class TestFloorPlanManagementWidget extends StatelessWidget {
  const TestFloorPlanManagementWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.floorPlanManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Text(l10n.overview),
          Text(l10n.floorPlans),
          Text(l10n.tables),
          Text(l10n.settings),
          Text(l10n.tableStatusOverview),
          Text(l10n.totalTables),
          Text(l10n.available),
          Text(l10n.occupied),
          Text(l10n.reserved),
          Text(l10n.cleaning),
        ],
      ),
    );
  }
}

class TestPosScreenWidget extends StatelessWidget {
  const TestPosScreenWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart),
      ),
      body: Column(
        children: [
          Text(l10n.actions),
          Text(l10n.guest),
          Text(l10n.menu),
          Text(l10n.orders),
          Text(l10n.transactions),
          Text(l10n.inventory),
          Text(l10n.more),
          Text(l10n.cashier),
          Text(l10n.posService),
        ],
      ),
    );
  }
}

class TestInventoryScreenWidget extends StatelessWidget {
  const TestInventoryScreenWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventory),
      ),
      body: Column(
        children: [
          Text(l10n.allItems),
          Text(l10n.lowStock),
          Text(l10n.categories),
          Text(l10n.searchInventory),
          Text(l10n.filterOptions),
          Text(l10n.addNewItem),
          Text(l10n.editItem),
          Text(l10n.updateStock),
          Text(l10n.deleteItem),
        ],
      ),
    );
  }
}

class TestSplitPaymentDialogWidget extends StatelessWidget {
  const TestSplitPaymentDialogWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.splitPayment),
      ),
      body: Column(
        children: [
          Text(l10n.customerName),
          Text(l10n.customerPhone),
          Text(l10n.customerEmail),
          Text(l10n.notes),
          Text(l10n.paymentMethods),
          Text(l10n.addPayment),
          Text(l10n.amount),
          Text(l10n.paymentMethod),
          Text(l10n.cash),
          Text(l10n.creditCard),
          Text(l10n.debitCard),
          Text(l10n.mobilePayment),
          Text(l10n.check),
          Text(l10n.completeSplitPayment),
        ],
      ),
    );
  }
}

class TestCustomerSelectionDialogWidget extends StatelessWidget {
  const TestCustomerSelectionDialogWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectCustomer),
      ),
      body: Column(
        children: [
          Text(l10n.newCustomer),
          Text(l10n.guestCheckout),
          Text(l10n.email),
          Text(l10n.phone),
          Text(l10n.searchResults),
          Text(l10n.noEmail),
          Text(l10n.noPhone),
          Text(l10n.noCustomersFound),
          Text(l10n.createCustomer),
        ],
      ),
    );
  }
} 