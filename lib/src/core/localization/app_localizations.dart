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
  String get analytics => _locale.languageCode == 'en' ? 'Analytics' : 'Análisis';
  String get features => _locale.languageCode == 'en' ? 'Features' : 'Características';
  String get salesOverview => _locale.languageCode == 'en' ? 'Sales Overview' : 'Resumen de Ventas';
  String get todaysSales => _locale.languageCode == 'en' ? 'Today\'s Sales' : 'Ventas de Hoy';
  String get transactions => _locale.languageCode == 'en' ? 'Transactions' : 'Transacciones';
  String get avgOrder => _locale.languageCode == 'en' ? 'Avg Order' : 'Pedido Promedio';
  String get newFeaturesAvailable => _locale.languageCode == 'en' ? 'New Features Available' : 'Nuevas Características Disponibles';
  String get exploreFeaturesDescription => _locale.languageCode == 'en' ? 'Explore our new Recipe & Promotion System with mobile notifications.' : 'Explora nuestro nuevo Sistema de Recetas y Promociones con notificaciones móviles.';
  String get exploreFeatures => _locale.languageCode == 'en' ? 'Explore Features' : 'Explorar Características';
  String get viewAnalytics => _locale.languageCode == 'en' ? 'View Analytics' : 'Ver Análisis';
  String get recentActivity => _locale.languageCode == 'en' ? 'Recent Activity' : 'Actividad Reciente';
  String get languageSettings => _locale.languageCode == 'en' ? 'Language Settings' : 'Configuración de Idioma';
  String get languageStatus => _locale.languageCode == 'en' ? 'Language Status' : 'Estado del Idioma';
  String get currentLanguage => _locale.languageCode == 'en' ? 'Current Language' : 'Idioma Actual';
  String get nativeName => _locale.languageCode == 'en' ? 'Native Name' : 'Nombre Nativo';
  String get selectLanguage => _locale.languageCode == 'en' ? 'Select Language' : 'Seleccionar Idioma';
  String get languageChangesSaved => _locale.languageCode == 'en' ? 'Language changes saved' : 'Cambios de idioma guardados';
  String get information => _locale.languageCode == 'en' ? 'Information' : 'Información';
  String get languageInfo => _locale.languageCode == 'en' ? 'Mobile POS supports Spanish and English. Default language is Spanish (Costa Rica).' : 'POS Móvil soporta Español e Inglés. El idioma predeterminado es Español (Costa Rica).';
  String get languageChangesApplied => _locale.languageCode == 'en' ? 'Language changes will be saved and applied immediately.' : 'Los cambios de idioma se guardarán y aplicarán inmediatamente.';
  String get profile => _locale.languageCode == 'en' ? 'Profile' : 'Perfil';
  String get confirmLogout => _locale.languageCode == 'en' ? 'Confirm Logout' : 'Confirmar Cierre de Sesión';
  String get logoutConfirmation => _locale.languageCode == 'en' ? 'Are you sure you want to logout?' : '¿Estás seguro de que quieres cerrar sesión?';
  String get saving => _locale.languageCode == 'en' ? 'Saving...' : 'Guardando...';
  String get loadingProfile => _locale.languageCode == 'en' ? 'Loading profile...' : 'Cargando perfil...';
  String get profileUpdatedSuccessfully => _locale.languageCode == 'en' ? 'Profile updated successfully!' : '¡Perfil actualizado exitosamente!';
  String get failedToLoadProfile => _locale.languageCode == 'en' ? 'Failed to load profile' : 'Error al cargar el perfil';
  String get retry => _locale.languageCode == 'en' ? 'Retry' : 'Reintentar';
  String get pleaseLoginToViewProfile => _locale.languageCode == 'en' ? 'Please log in to view your profile' : 'Por favor inicia sesión para ver tu perfil';
  String get initializing => _locale.languageCode == 'en' ? 'Initializing...' : 'Inicializando...';
  String get userDataNotAvailable => _locale.languageCode == 'en' ? 'User data not available' : 'Datos de usuario no disponibles';
  String get personalInformation => _locale.languageCode == 'en' ? 'Personal Information' : 'Información Personal';
  String get workInformation => _locale.languageCode == 'en' ? 'Work Information' : 'Información Laboral';
  String get accountSettings => _locale.languageCode == 'en' ? 'Account Settings' : 'Configuración de Cuenta';
  String get supportAndHelp => _locale.languageCode == 'en' ? 'Support & Help' : 'Soporte y Ayuda';
  String get editProfile => _locale.languageCode == 'en' ? 'Edit Profile' : 'Editar Perfil';
  String get changePhoto => _locale.languageCode == 'en' ? 'Change Photo' : 'Cambiar Foto';
  String get photoUploadComingSoon => _locale.languageCode == 'en' ? 'Photo upload coming soon!' : '¡Subida de fotos próximamente!';
  String get fullName => _locale.languageCode == 'en' ? 'Full Name' : 'Nombre Completo';
  String get enterYourName => _locale.languageCode == 'en' ? 'Enter your name' : 'Ingresa tu nombre';
  String get phoneNumber => _locale.languageCode == 'en' ? 'Phone Number' : 'Número de Teléfono';
  String get saveChanges => _locale.languageCode == 'en' ? 'Save Changes' : 'Guardar Cambios';
  String get name => _locale.languageCode == 'en' ? 'Name' : 'Nombre';
  String get phone => _locale.languageCode == 'en' ? 'Phone' : 'Teléfono';
  String get role => _locale.languageCode == 'en' ? 'Role' : 'Rol';
  String get employeeId => _locale.languageCode == 'en' ? 'Employee ID' : 'ID de Empleado';
  String get department => _locale.languageCode == 'en' ? 'Department' : 'Departamento';
  String get hireDate => _locale.languageCode == 'en' ? 'Hire Date' : 'Fecha de Contratación';
  String get status => _locale.languageCode == 'en' ? 'Status' : 'Estado';
  String get quickStats => _locale.languageCode == 'en' ? 'Quick Stats' : 'Estadísticas Rápidas';
  String get orders => _locale.languageCode == 'en' ? 'Orders' : 'Pedidos';
  String get thisMonth => _locale.languageCode == 'en' ? 'This Month' : 'Este Mes';
  String get tables => _locale.languageCode == 'en' ? 'Tables' : 'Mesas';
  String get thisWeek => _locale.languageCode == 'en' ? 'This Week' : 'Esta Semana';
  String get tips => _locale.languageCode == 'en' ? 'Tips' : 'Propinas';
  String get changePassword => _locale.languageCode == 'en' ? 'Change Password' : 'Cambiar Contraseña';
  String get passwordChangeComingSoon => _locale.languageCode == 'en' ? 'Password change coming soon!' : '¡Cambio de contraseña próximamente!';
  String get notificationSettings => _locale.languageCode == 'en' ? 'Notification Settings' : 'Configuración de Notificaciones';
  String get notificationSettingsComingSoon => _locale.languageCode == 'en' ? 'Notification settings coming soon!' : '¡Configuración de notificaciones próximamente!';
  String get themeSettings => _locale.languageCode == 'en' ? 'Theme Settings' : 'Configuración de Tema';
  String get themeSettingsComingSoon => _locale.languageCode == 'en' ? 'Theme settings coming soon!' : '¡Configuración de tema próximamente!';
  String get privacyAndSecurity => _locale.languageCode == 'en' ? 'Privacy & Security' : 'Privacidad y Seguridad';
  String get privacySettingsComingSoon => _locale.languageCode == 'en' ? 'Privacy settings coming soon!' : '¡Configuración de privacidad próximamente!';
  String get helpCenter => _locale.languageCode == 'en' ? 'Help Center' : 'Centro de Ayuda';
  String get helpCenterComingSoon => _locale.languageCode == 'en' ? 'Help center coming soon!' : '¡Centro de ayuda próximamente!';
  String get contactSupport => _locale.languageCode == 'en' ? 'Contact Support' : 'Contactar Soporte';
  String get contactSupportComingSoon => _locale.languageCode == 'en' ? 'Contact support coming soon!' : '¡Contactar soporte próximamente!';
  String get trainingMaterials => _locale.languageCode == 'en' ? 'Training Materials' : 'Materiales de Entrenamiento';
  String get trainingMaterialsComingSoon => _locale.languageCode == 'en' ? 'Training materials coming soon!' : '¡Materiales de entrenamiento próximamente!';
  String get clearAllData => _locale.languageCode == 'en' ? 'Clear All Data' : 'Borrar Todos los Datos';
  String get clearDataConfirmation => _locale.languageCode == 'en' ? 'This will clear all stored data and log you out. This action cannot be undone.' : 'Esto borrará todos los datos almacenados y te cerrará sesión. Esta acción no se puede deshacer.';
  String get clearStoredDataDebug => _locale.languageCode == 'en' ? 'Clear Stored Data (Debug)' : 'Borrar Datos Almacenados (Debug)';
  String get floorPlan => _locale.languageCode == 'en' ? 'Floor Plan' : 'Plano del Piso';
  String get messages => _locale.languageCode == 'en' ? 'Messages' : 'Mensajes';
  String get businessManagement => _locale.languageCode == 'en' ? 'Business Management' : 'Gestión de Negocios';
  String get addBusiness => _locale.languageCode == 'en' ? 'Add Business' : 'Agregar Negocio';
  String get errorLoadingBusinesses => _locale.languageCode == 'en' ? 'Error loading businesses' : 'Error al cargar negocios';
  String get noBusinessesFound => _locale.languageCode == 'en' ? 'No businesses found' : 'No se encontraron negocios';
  String get addFirstBusinessToGetStarted => _locale.languageCode == 'en' ? 'Add your first business to get started' : 'Agrega tu primer negocio para comenzar';
  String get active => _locale.languageCode == 'en' ? 'Active' : 'Activo';
  String get inactive => _locale.languageCode == 'en' ? 'Inactive' : 'Inactivo';
  String get edit => _locale.languageCode == 'en' ? 'Edit' : 'Editar';
  String get deleteBusiness => _locale.languageCode == 'en' ? 'Delete Business' : 'Eliminar Negocio';
  String get deleteBusinessConfirmation => _locale.languageCode == 'en' ? 'Are you sure you want to delete' : '¿Estás seguro de que quieres eliminar';
  String get thisActionCannotBeUndone => _locale.languageCode == 'en' ? 'This action cannot be undone.' : 'Esta acción no se puede deshacer.';
  String get floorPlanManagement => _locale.languageCode == 'en' ? 'Floor Plan Management' : 'Gestión de Planos del Piso';
  String get refresh => _locale.languageCode == 'en' ? 'Refresh' : 'Actualizar';
  String get overview => _locale.languageCode == 'en' ? 'Overview' : 'Resumen';
  String get floorPlans => _locale.languageCode == 'en' ? 'Floor Plans' : 'Planos del Piso';
  String get tableStatusOverview => _locale.languageCode == 'en' ? 'Table Status Overview' : 'Resumen del Estado de Mesas';
  String get realTimeRestaurantMetrics => _locale.languageCode == 'en' ? 'Real-time restaurant floor plan metrics' : 'Métricas en tiempo real del plano del restaurante';
  String get totalTables => _locale.languageCode == 'en' ? 'Total Tables' : 'Total de Mesas';
  String get available => _locale.languageCode == 'en' ? 'Available' : 'Disponible';
  String get occupied => _locale.languageCode == 'en' ? 'Occupied' : 'Ocupada';
  String get reserved => _locale.languageCode == 'en' ? 'Reserved' : 'Reservada';
  String get cleaning => _locale.languageCode == 'en' ? 'Cleaning' : 'Limpieza';
  
  // POS Operations
  String get cart => _locale.languageCode == 'en' ? 'Cart' : 'Carrito';
  String get cartIsEmpty => _locale.languageCode == 'en' ? 'Cart is empty' : 'El carrito está vacío';
  String get itemNotFoundForBarcode => _locale.languageCode == 'en' ? 'Item not found for this barcode' : 'Artículo no encontrado para este código de barras';
  String get promotion => _locale.languageCode == 'en' ? 'Promotion' : 'Promoción';
  String get cashier => _locale.languageCode == 'en' ? 'Cashier' : 'Cajero';
  String get menu => _locale.languageCode == 'en' ? 'Menu' : 'Menú';
  String get inventory => _locale.languageCode == 'en' ? 'Inventory' : 'Inventario';
  String get discounts => _locale.languageCode == 'en' ? 'Discounts' : 'Descuentos';
  String get promotions => _locale.languageCode == 'en' ? 'Promotions' : 'Promociones';
  String get scan => _locale.languageCode == 'en' ? 'Scan' : 'Escanear';
  String get errorLoadingCategories => _locale.languageCode == 'en' ? 'Error loading categories' : 'Error al cargar categorías';
  String get errorLoadingItems => _locale.languageCode == 'en' ? 'Error loading items' : 'Error al cargar artículos';
  String get searchResult => _locale.languageCode == 'en' ? 'Search Result' : 'Resultado de Búsqueda';
  String get noItemsFound => _locale.languageCode == 'en' ? 'No items found' : 'No se encontraron artículos';
  String get tryAdjustingSearchTerms => _locale.languageCode == 'en' ? 'Try adjusting your search terms' : 'Intenta ajustar tus términos de búsqueda';
  String get noItemsAvailableInCategory => _locale.languageCode == 'en' ? 'No items available in this category' : 'No hay artículos disponibles en esta categoría';
  String get actions => _locale.languageCode == 'en' ? 'Actions' : 'Acciones';
  String get guest => _locale.languageCode == 'en' ? 'Guest' : 'Invitado';
  String get yourCartIsEmpty => _locale.languageCode == 'en' ? 'Your cart is empty' : 'Tu carrito está vacío';
  String get addItemsToGetStarted => _locale.languageCode == 'en' ? 'Add items to get started' : 'Agrega artículos para comenzar';
  String get chargeTableOrder => _locale.languageCode == 'en' ? 'Charge Table Order' : 'Cobrar Pedido de Mesa';
  String get holdOrder => _locale.languageCode == 'en' ? 'Hold Order' : 'Mantener Pedido';
  String get orderHeld => _locale.languageCode == 'en' ? 'Order held' : 'Pedido mantenido';
  String get voidOrder => _locale.languageCode == 'en' ? 'Void Order' : 'Anular Pedido';
  String get orderVoided => _locale.languageCode == 'en' ? 'Order voided' : 'Pedido anulado';
  String get printReceipt => _locale.languageCode == 'en' ? 'Print Receipt' : 'Imprimir Recibo';
  String get receiptPrinted => _locale.languageCode == 'en' ? 'Receipt printed' : 'Recibo impreso';
  String get emailReceipt => _locale.languageCode == 'en' ? 'Email Receipt' : 'Enviar Recibo por Email';
  String get receiptEmailed => _locale.languageCode == 'en' ? 'Receipt emailed' : 'Recibo enviado por email';
  String get setGuestCount => _locale.languageCode == 'en' ? 'Set Guest Count' : 'Establecer Número de Invitados';
  String get customerInfo => _locale.languageCode == 'en' ? 'Customer Info' : 'Información del Cliente';
  String get customerInfoDialog => _locale.languageCode == 'en' ? 'Customer info dialog' : 'Diálogo de información del cliente';
  String get specialRequests => _locale.languageCode == 'en' ? 'Special Requests' : 'Solicitudes Especiales';
  String get specialRequestsDialog => _locale.languageCode == 'en' ? 'Special requests dialog' : 'Diálogo de solicitudes especiales';
  String get total => _locale.languageCode == 'en' ? 'Total' : 'Total';
  String get more => _locale.languageCode == 'en' ? 'More' : 'Más';
  String get posService => _locale.languageCode == 'en' ? 'POS Service' : 'Servicio POS';
  String get noRecentSales => _locale.languageCode == 'en' ? 'No recent sales' : 'No hay ventas recientes';
  String get salesWillAppearHere => _locale.languageCode == 'en' ? 'Sales will appear here after transactions' : 'Las ventas aparecerán aquí después de las transacciones';
  String get currentOrders => _locale.languageCode == 'en' ? 'Current Orders' : 'Pedidos Actuales';
  String get manageRestaurantOrders => _locale.languageCode == 'en' ? 'Manage restaurant orders' : 'Gestionar pedidos del restaurante';
  String get noActiveOrders => _locale.languageCode == 'en' ? 'No Active Orders' : 'No Hay Pedidos Activos';
  String get newOrdersWillAppearHere => _locale.languageCode == 'en' ? 'New orders will appear here' : 'Los nuevos pedidos aparecerán aquí';
  String get failedToLoadOrders => _locale.languageCode == 'en' ? 'Failed to load orders' : 'Error al cargar pedidos';
  String get dailyTransactions => _locale.languageCode == 'en' ? 'Daily Transactions' : 'Transacciones Diarias';
  String get viewCompletedSales => _locale.languageCode == 'en' ? 'View completed sales' : 'Ver ventas completadas';
  String get noTransactionsToday => _locale.languageCode == 'en' ? 'No Transactions Today' : 'No Hay Transacciones Hoy';
  String get completedSalesWillAppearHere => _locale.languageCode == 'en' ? 'Completed sales will appear here' : 'Las ventas completadas aparecerán aquí';
  String get failedToLoadTransactions => _locale.languageCode == 'en' ? 'Failed to load transactions' : 'Error al cargar transacciones';
  String get inventoryStatus => _locale.languageCode == 'en' ? 'Inventory Status' : 'Estado del Inventario';
  String get monitorStockLevels => _locale.languageCode == 'en' ? 'Monitor stock levels' : 'Monitorear niveles de stock';
  String get noInventoryData => _locale.languageCode == 'en' ? 'No Inventory Data' : 'No Hay Datos de Inventario';
  String get menuItemsWillAppearHere => _locale.languageCode == 'en' ? 'Menu items will appear here with stock info' : 'Los elementos del menú aparecerán aquí con información de stock';
  String get failedToLoadInventory => _locale.languageCode == 'en' ? 'Failed to load inventory' : 'Error al cargar inventario';
  String get unknown => _locale.languageCode == 'en' ? 'Unknown' : 'Desconocido';
  String get pending => _locale.languageCode == 'en' ? 'pending' : 'pendiente';
  
  // Split Payment Dialog
  String get splitPayment => _locale.languageCode == 'en' ? 'Split Payment' : 'Pago Dividido';
  String get customerName => _locale.languageCode == 'en' ? 'Customer Name' : 'Nombre del Cliente';
  String get customerPhone => _locale.languageCode == 'en' ? 'Customer Phone' : 'Teléfono del Cliente';
  String get customerEmail => _locale.languageCode == 'en' ? 'Customer Email' : 'Email del Cliente';
  String get notes => _locale.languageCode == 'en' ? 'Notes' : 'Notas';
  String get paymentMethods => _locale.languageCode == 'en' ? 'Payment Methods' : 'Métodos de Pago';
  String get addPayment => _locale.languageCode == 'en' ? 'Add Payment' : 'Agregar Pago';
  String get amount => _locale.languageCode == 'en' ? 'Amount' : 'Monto';
  String get amountIsRequired => _locale.languageCode == 'en' ? 'Amount is required' : 'El monto es requerido';
  String get paymentMethod => _locale.languageCode == 'en' ? 'Payment Method' : 'Método de Pago';
  String get cash => _locale.languageCode == 'en' ? 'Cash' : 'Efectivo';
  String get creditCard => _locale.languageCode == 'en' ? 'Credit Card' : 'Tarjeta de Crédito';
  String get debitCard => _locale.languageCode == 'en' ? 'Debit Card' : 'Tarjeta de Débito';
  String get mobilePayment => _locale.languageCode == 'en' ? 'Mobile Payment' : 'Pago Móvil';
  String get check => _locale.languageCode == 'en' ? 'Check' : 'Cheque';
  String get paymentMethodIsRequired => _locale.languageCode == 'en' ? 'Payment method is required' : 'El método de pago es requerido';
  String get completeSplitPayment => _locale.languageCode == 'en' ? 'Complete Split Payment' : 'Completar Pago Dividido';
  
  // Customer Selection Dialog
  String get selectCustomer => _locale.languageCode == 'en' ? 'Select Customer' : 'Seleccionar Cliente';
  String get newCustomer => _locale.languageCode == 'en' ? 'New Customer' : 'Nuevo Cliente';
  String get guestCheckout => _locale.languageCode == 'en' ? 'Guest Checkout' : 'Pago de Invitado';
  String get searchResults => _locale.languageCode == 'en' ? 'Search Results' : 'Resultados de Búsqueda';
  String get noEmail => _locale.languageCode == 'en' ? 'No email' : 'Sin email';
  String get noPhone => _locale.languageCode == 'en' ? 'No phone' : 'Sin teléfono';
  String get noCustomersFound => _locale.languageCode == 'en' ? 'No customers found' : 'No se encontraron clientes';
  String get createCustomer => _locale.languageCode == 'en' ? 'Create Customer' : 'Crear Cliente';
  
  // Split Billing Screen
  String get splitBilling => _locale.languageCode == 'en' ? 'Split Billing' : 'Facturación Dividida';
  String get addSplit => _locale.languageCode == 'en' ? 'Add Split' : 'Agregar División';
  String get removeLastSplit => _locale.languageCode == 'en' ? 'Remove Last Split' : 'Eliminar Última División';
  String get assignItemToSplit => _locale.languageCode == 'en' ? 'Assign item to split' : 'Asignar artículo a división';
  String get newStockQuantity => _locale.languageCode == 'en' ? 'New Stock Quantity' : 'Nueva Cantidad de Stock';
  String get update => _locale.languageCode == 'en' ? 'Update' : 'Actualizar';
  String get card => _locale.languageCode == 'en' ? 'Card' : 'Tarjeta';
  String get mobile => _locale.languageCode == 'en' ? 'Mobile' : 'Móvil';
  String get finalizeSplit => _locale.languageCode == 'en' ? 'Finalize Split' : 'Finalizar División';
  
  // Inventory Screen
  String get allItems => _locale.languageCode == 'en' ? 'All Items' : 'Todos los Artículos';
  String get lowStock => _locale.languageCode == 'en' ? 'Low Stock' : 'Stock Bajo';
  String get categories => _locale.languageCode == 'en' ? 'Categories' : 'Categorías';
  String get errorLoadingInventory => _locale.languageCode == 'en' ? 'Error loading inventory' : 'Error al cargar inventario';
  String get noInventoryItemsFound => _locale.languageCode == 'en' ? 'No inventory items found' : 'No se encontraron artículos de inventario';
  String get addYourFirstItemToGetStarted => _locale.languageCode == 'en' ? 'Add your first item to get started' : 'Agrega tu primer artículo para comenzar';
  String get allItemsAreWellStocked => _locale.languageCode == 'en' ? 'All items are well stocked' : 'Todos los artículos están bien abastecidos';
  String get noLowStockItemsFound => _locale.languageCode == 'en' ? 'No low stock items found' : 'No se encontraron artículos con stock bajo';
  String get noCategoriesFound => _locale.languageCode == 'en' ? 'No categories found' : 'No se encontraron categorías';
  String get categoriesWillAppearHere => _locale.languageCode == 'en' ? 'Categories will appear here' : 'Las categorías aparecerán aquí';
  String get outOfStock => _locale.languageCode == 'en' ? 'Out of Stock' : 'Sin Stock';
  String get searchInventory => _locale.languageCode == 'en' ? 'Search Inventory' : 'Buscar Inventario';
  String get clear => _locale.languageCode == 'en' ? 'Clear' : 'Limpiar';
  String get close => _locale.languageCode == 'en' ? 'Close' : 'Cerrar';
  String get filterOptions => _locale.languageCode == 'en' ? 'Filter Options' : 'Opciones de Filtro';
  String get filterOptionsWillBeImplementedHere => _locale.languageCode == 'en' ? 'Filter options will be implemented here' : 'Las opciones de filtro se implementarán aquí';
  String get addNewItem => _locale.languageCode == 'en' ? 'Add New Item' : 'Agregar Nuevo Artículo';
  String get addItemFormWillBeImplementedHere => _locale.languageCode == 'en' ? 'Add item form will be implemented here' : 'El formulario de agregar artículo se implementará aquí';
  String get add => _locale.languageCode == 'en' ? 'Add' : 'Agregar';
  String get editItem => _locale.languageCode == 'en' ? 'Edit Item' : 'Editar Artículo';
  String get updateStock => _locale.languageCode == 'en' ? 'Update Stock' : 'Actualizar Stock';
  String get deleteItem => _locale.languageCode == 'en' ? 'Delete Item' : 'Eliminar Artículo';
  
  // Reports & Analytics
  String get reportsAndAnalytics => _locale.languageCode == 'en' ? 'Reports & Analytics' : 'Reportes y Análisis';
  String get refreshData => _locale.languageCode == 'en' ? 'Refresh Data' : 'Actualizar Datos';
  String get exportReport => _locale.languageCode == 'en' ? 'Export Report' : 'Exportar Reporte';
  String get recipeAndPromotionFeatures => _locale.languageCode == 'en' ? 'Recipe & Promotion Features' : 'Características de Recetas y Promociones';
  String get revenue => _locale.languageCode == 'en' ? 'Revenue' : 'Ingresos';
  String get dateRange => _locale.languageCode == 'en' ? 'Date Range' : 'Rango de Fechas';
  String get custom => _locale.languageCode == 'en' ? 'Custom' : 'Personalizado';
  String get allStatus => _locale.languageCode == 'en' ? 'All Status' : 'Todos los Estados';
  String get completed => _locale.languageCode == 'en' ? 'Completed' : 'Completado';
  String get cancelled => _locale.languageCode == 'en' ? 'Cancelled' : 'Cancelado';
  String get refunded => _locale.languageCode == 'en' ? 'Refunded' : 'Reembolsado';
  String get payment => _locale.languageCode == 'en' ? 'Payment' : 'Pago';
  String get allMethods => _locale.languageCode == 'en' ? 'All Methods' : 'Todos los Métodos';
  String get pdfReport => _locale.languageCode == 'en' ? 'PDF Report' : 'Reporte PDF';
  String get csvData => _locale.languageCode == 'en' ? 'CSV Data' : 'Datos CSV';
  String get excelSpreadsheet => _locale.languageCode == 'en' ? 'Excel Spreadsheet' : 'Hoja de Cálculo Excel';
  String get exportingReportAs => _locale.languageCode == 'en' ? 'Exporting report as' : 'Exportando reporte como';
  String get loadingOverviewData => _locale.languageCode == 'en' ? 'Loading overview data...' : 'Cargando datos del resumen...';
  String get failedToLoadOverviewData => _locale.languageCode == 'en' ? 'Failed to load overview data' : 'Error al cargar datos del resumen';
  String get totalSales => _locale.languageCode == 'en' ? 'Total Sales' : 'Ventas Totales';
  String get averageOrder => _locale.languageCode == 'en' ? 'Average Order' : 'Pedido Promedio';
  String get perTransaction => _locale.languageCode == 'en' ? 'per transaction' : 'por transacción';
  String get topProduct => _locale.languageCode == 'en' ? 'Top Product' : 'Producto Principal';
  String get mostPopularItem => _locale.languageCode == 'en' ? 'Most popular item' : 'Artículo más popular';
  String get conversionRate => _locale.languageCode == 'en' ? 'Conversion Rate' : 'Tasa de Conversión';
  String get ofVisitors => _locale.languageCode == 'en' ? 'of visitors' : 'de visitantes';
  String get salesTrend => _locale.languageCode == 'en' ? 'Sales Trend' : 'Tendencia de Ventas';
  String get salesTrendChart => _locale.languageCode == 'en' ? 'Sales trend chart' : 'Gráfico de tendencia de ventas';
  String get comingSoonWithRealData => _locale.languageCode == 'en' ? 'Coming soon with real data' : 'Próximamente con datos reales';
  String get topSellingItems => _locale.languageCode == 'en' ? 'Top Selling Items' : 'Artículos Más Vendidos';
  String get viewAll => _locale.languageCode == 'en' ? 'View All' : 'Ver Todo';
  String get popularItem => _locale.languageCode == 'en' ? 'Popular item' : 'Artículo popular';
  String get loadingTransactions => _locale.languageCode == 'en' ? 'Loading transactions...' : 'Cargando transacciones...';
  String get noTransactionsFound => _locale.languageCode == 'en' ? 'No transactions found' : 'No se encontraron transacciones';
  String get tryAdjustingFiltersOrDateRange => _locale.languageCode == 'en' ? 'Try adjusting your filters or date range' : 'Intenta ajustar tus filtros o rango de fechas';
  String get sale => _locale.languageCode == 'en' ? 'Sale' : 'Venta';
  String get saleNumber => _locale.languageCode == 'en' ? 'Sale #' : 'Venta #';
  String get loadingRevenueData => _locale.languageCode == 'en' ? 'Loading revenue data...' : 'Cargando datos de ingresos...';
  String get failedToLoadRevenueData => _locale.languageCode == 'en' ? 'Failed to load revenue data' : 'Error al cargar datos de ingresos';
  String get totalRevenue => _locale.languageCode == 'en' ? 'Total Revenue' : 'Ingresos Totales';
  String get grossIncome => _locale.languageCode == 'en' ? 'Gross income' : 'Ingresos brutos';
  String get grossProfit => _locale.languageCode == 'en' ? 'Gross Profit' : 'Beneficio Bruto';
  String get afterCosts => _locale.languageCode == 'en' ? 'After costs' : 'Después de costos';
  String get profitMargin => _locale.languageCode == 'en' ? 'Profit Margin' : 'Margen de Beneficio';
  String get profitRatio => _locale.languageCode == 'en' ? 'Profit ratio' : 'Ratio de beneficio';
  String get totalCost => _locale.languageCode == 'en' ? 'Total Cost' : 'Costo Total';
  String get operatingCosts => _locale.languageCode == 'en' ? 'Operating costs' : 'Costos operativos';
  String get revenueByDay => _locale.languageCode == 'en' ? 'Revenue by Day' : 'Ingresos por Día';
  String get revenueTrendChart => _locale.languageCode == 'en' ? 'Revenue trend chart' : 'Gráfico de tendencia de ingresos';
  String get transactionDetails => _locale.languageCode == 'en' ? 'Transaction Details' : 'Detalles de Transacción';
  String get items => _locale.languageCode == 'en' ? 'Items' : 'Artículos';
  String get noItemsFoundForThisSale => _locale.languageCode == 'en' ? 'No items found for this sale' : 'No se encontraron artículos para esta venta';
  String get loadingItems => _locale.languageCode == 'en' ? 'Loading items...' : 'Cargando artículos...';
  String get businessAnalytics => _locale.languageCode == 'en' ? 'Business Analytics' : 'Análisis de Negocio';
  String get itemAnalytics => _locale.languageCode == 'en' ? 'Item Analytics' : 'Análisis de Artículos';
  String get staffAnalytics => _locale.languageCode == 'en' ? 'Staff Analytics' : 'Análisis de Personal';
  String get customerAnalytics => _locale.languageCode == 'en' ? 'Customer Analytics' : 'Análisis de Clientes';
  String get inventoryAnalytics => _locale.languageCode == 'en' ? 'Inventory Analytics' : 'Análisis de Inventario';
  String get revenueAnalytics => _locale.languageCode == 'en' ? 'Revenue Analytics' : 'Análisis de Ingresos';
  String get performanceMetrics => _locale.languageCode == 'en' ? 'Performance Metrics' : 'Métricas de Rendimiento';
  String get salesMetrics => _locale.languageCode == 'en' ? 'Sales Metrics' : 'Métricas de Ventas';
  String get customerMetrics => _locale.languageCode == 'en' ? 'Customer Metrics' : 'Métricas de Clientes';
  String get inventoryMetrics => _locale.languageCode == 'en' ? 'Inventory Metrics' : 'Métricas de Inventario';
  String get staffMetrics => _locale.languageCode == 'en' ? 'Staff Metrics' : 'Métricas de Personal';
  String get revenueMetrics => _locale.languageCode == 'en' ? 'Revenue Metrics' : 'Métricas de Ingresos';
  String get dataExport => _locale.languageCode == 'en' ? 'Data Export' : 'Exportar Datos';
  String get reportGeneration => _locale.languageCode == 'en' ? 'Report Generation' : 'Generación de Reportes';
  String get chartVisualization => _locale.languageCode == 'en' ? 'Chart Visualization' : 'Visualización de Gráficos';
  String get trendAnalysis => _locale.languageCode == 'en' ? 'Trend Analysis' : 'Análisis de Tendencias';
  String get comparativeAnalysis => _locale.languageCode == 'en' ? 'Comparative Analysis' : 'Análisis Comparativo';
  String get forecasting => _locale.languageCode == 'en' ? 'Forecasting' : 'Pronósticos';
  String get kpiDashboard => _locale.languageCode == 'en' ? 'KPI Dashboard' : 'Panel de KPI';
  String get realTimeAnalytics => _locale.languageCode == 'en' ? 'Real-time Analytics' : 'Análisis en Tiempo Real';
  String get historicalData => _locale.languageCode == 'en' ? 'Historical Data' : 'Datos Históricos';
  String get dataInsights => _locale.languageCode == 'en' ? 'Data Insights' : 'Insights de Datos';
  String get businessIntelligence => _locale.languageCode == 'en' ? 'Business Intelligence' : 'Inteligencia de Negocios';
  

  
  // Currency Management strings
  String get currencyManagement => _locale.languageCode == 'en' ? 'Currency Management' : 'Gestión de Monedas';
  String get addCurrency => _locale.languageCode == 'en' ? 'Add Currency' : 'Agregar Moneda';
  String get currencyCode => _locale.languageCode == 'en' ? 'Currency Code' : 'Código de Moneda';
  String get currencySymbol => _locale.languageCode == 'en' ? 'Currency Symbol' : 'Símbolo de Moneda';
  String get currencyName => _locale.languageCode == 'en' ? 'Currency Name' : 'Nombre de Moneda';
  String get exchangeRate => _locale.languageCode == 'en' ? 'Exchange Rate' : 'Tasa de Cambio';
  String get isDefault => _locale.languageCode == 'en' ? 'Is Default' : 'Es Predeterminada';
  String get defaultCurrency => _locale.languageCode == 'en' ? 'Default' : 'Predeterminada';
  String get editCurrency => _locale.languageCode == 'en' ? 'Edit Currency' : 'Editar Moneda';
  String get deleteCurrency => _locale.languageCode == 'en' ? 'Delete Currency' : 'Eliminar Moneda';
  String get currencyPreferences => _locale.languageCode == 'en' ? 'Currency Preferences' : 'Preferencias de Moneda';
  
  // Waiter/Staff strings
  String get orderTaking => _locale.languageCode == 'en' ? 'Order Taking' : 'Toma de Pedidos';
  String get tableSelection => _locale.languageCode == 'en' ? 'Table Selection' : 'Selección de Mesa';
  String get waiterDashboard => _locale.languageCode == 'en' ? 'Waiter Dashboard' : 'Panel de Mesero';
  String get waiterScreen => _locale.languageCode == 'en' ? 'Waiter Screen' : 'Pantalla de Mesero';
  String get takeOrder => _locale.languageCode == 'en' ? 'Take Order' : 'Tomar Pedido';
  String get viewOrders => _locale.languageCode == 'en' ? 'View Orders' : 'Ver Pedidos';
  String get tableStatus => _locale.languageCode == 'en' ? 'Table Status' : 'Estado de Mesa';
  String get assignTable => _locale.languageCode == 'en' ? 'Assign Table' : 'Asignar Mesa';
  String get unassignTable => _locale.languageCode == 'en' ? 'Unassign Table' : 'Desasignar Mesa';
  String get waiterOrders => _locale.languageCode == 'en' ? 'Waiter Orders' : 'Pedidos de Mesero';
  
  // Admin strings
  String get adminDashboard => _locale.languageCode == 'en' ? 'Admin Dashboard' : 'Panel de Administrador';
  String get menuManagement => _locale.languageCode == 'en' ? 'Menu Management' : 'Gestión de Menú';
  String get pdfMenuGeneration => _locale.languageCode == 'en' ? 'PDF Menu Generation' : 'Generación de Menú PDF';
  String get customTemplateManagement => _locale.languageCode == 'en' ? 'Custom Template Management' : 'Gestión de Plantillas Personalizadas';
  String get generateMenu => _locale.languageCode == 'en' ? 'Generate Menu' : 'Generar Menú';
  String get templateSettings => _locale.languageCode == 'en' ? 'Template Settings' : 'Configuración de Plantilla';
  
  // Reports strings
  String get reports => _locale.languageCode == 'en' ? 'Reports' : 'Reportes';
  String get salesReport => _locale.languageCode == 'en' ? 'Sales Report' : 'Reporte de Ventas';
  String get inventoryReport => _locale.languageCode == 'en' ? 'Inventory Report' : 'Reporte de Inventario';
  String get staffReport => _locale.languageCode == 'en' ? 'Staff Report' : 'Reporte de Personal';
  
  // Recipe strings
  String get recipes => _locale.languageCode == 'en' ? 'Recipes' : 'Recetas';
  String get smartSuggestions => _locale.languageCode == 'en' ? 'Smart Suggestions' : 'Sugerencias Inteligentes';
  String get inventoryAlerts => _locale.languageCode == 'en' ? 'Inventory Alerts' : 'Alertas de Inventario';
  String get createRecipe => _locale.languageCode == 'en' ? 'Create Recipe' : 'Crear Receta';
  String get editRecipe => _locale.languageCode == 'en' ? 'Edit Recipe' : 'Editar Receta';
  String get recipeIngredients => _locale.languageCode == 'en' ? 'Recipe Ingredients' : 'Ingredientes de Receta';
  String get recipeInstructions => _locale.languageCode == 'en' ? 'Recipe Instructions' : 'Instrucciones de Receta';
  
  // Promotion strings
  String get createPromotion => _locale.languageCode == 'en' ? 'Create Promotion' : 'Crear Promoción';
  String get editPromotion => _locale.languageCode == 'en' ? 'Edit Promotion' : 'Editar Promoción';
  String get promotionType => _locale.languageCode == 'en' ? 'Promotion Type' : 'Tipo de Promoción';
  String get discountPercentage => _locale.languageCode == 'en' ? 'Discount Percentage' : 'Porcentaje de Descuento';
  
  // Onboarding strings
  String get onboarding => _locale.languageCode == 'en' ? 'Onboarding' : 'Integración';
  String get welcomeToPos => _locale.languageCode == 'en' ? 'Welcome to POS' : 'Bienvenido al POS';
  String get getStarted => _locale.languageCode == 'en' ? 'Get Started' : 'Comenzar';
  String get skip => _locale.languageCode == 'en' ? 'Skip' : 'Omitir';
  String get nextStep => _locale.languageCode == 'en' ? 'Next Step' : 'Siguiente Paso';
  
  // Debug strings
  String get debug => _locale.languageCode == 'en' ? 'Debug' : 'Depuración';
  String get environmentDebug => _locale.languageCode == 'en' ? 'Environment Debug' : 'Depuración de Entorno';
  String get debugInfo => _locale.languageCode == 'en' ? 'Debug Info' : 'Información de Depuración';
  
  // Kitchen/Viewer strings
  String get kitchenScreen => _locale.languageCode == 'en' ? 'Kitchen Screen' : 'Pantalla de Cocina';
  String get barScreen => _locale.languageCode == 'en' ? 'Bar Screen' : 'Pantalla de Bar';
  String get orderQueue => _locale.languageCode == 'en' ? 'Order Queue' : 'Cola de Pedidos';
  String get prepareOrder => _locale.languageCode == 'en' ? 'Prepare Order' : 'Preparar Pedido';
  String get orderReady => _locale.languageCode == 'en' ? 'Order Ready' : 'Pedido Listo';
  String get orderCompleted => _locale.languageCode == 'en' ? 'Order Completed' : 'Pedido Completado';
  String get pleaseFillAllRequiredFields => _locale.languageCode == 'en' ? 'Please fill in all required fields' : 'Por favor complete todos los campos requeridos';
  String get currencyCreatedSuccessfully => _locale.languageCode == 'en' ? 'Currency created successfully' : 'Moneda creada exitosamente';
  String get currencyUpdatedSuccessfully => _locale.languageCode == 'en' ? 'Currency updated successfully' : 'Moneda actualizada exitosamente';
  String get currencyDeletedSuccessfully => _locale.languageCode == 'en' ? 'Currency deleted successfully' : 'Moneda eliminada exitosamente';
  String get failedToCreateCurrency => _locale.languageCode == 'en' ? 'Failed to create currency' : 'Error al crear moneda';
  String get failedToUpdateCurrency => _locale.languageCode == 'en' ? 'Failed to update currency' : 'Error al actualizar moneda';
  String get failedToDeleteCurrency => _locale.languageCode == 'en' ? 'Failed to delete currency' : 'Error al eliminar moneda';
  String get create => _locale.languageCode == 'en' ? 'Create' : 'Crear';
  String get activate => _locale.languageCode == 'en' ? 'Activate' : 'Activar';
  String get deactivate => _locale.languageCode == 'en' ? 'Deactivate' : 'Desactivar';
  String get activated => _locale.languageCode == 'en' ? 'activated' : 'activada';
  String get deactivated => _locale.languageCode == 'en' ? 'deactivated' : 'desactivada';
  String get decimalPlaces => _locale.languageCode == 'en' ? 'Decimal Places' : 'Lugares Decimales';
  String get defaultText => _locale.languageCode == 'en' ? 'Default' : 'Predeterminado';
  String get errorLoadingExchangeRates => _locale.languageCode == 'en' ? 'Error loading exchange rates' : 'Error al cargar tasas de cambio';
  String get failedToLoadExchangeRates => _locale.languageCode == 'en' ? 'Failed to load exchange rates' : 'Error al cargar tasas de cambio';
  String get noExchangeRatesAvailable => _locale.languageCode == 'en' ? 'No exchange rates available' : 'No hay tasas de cambio disponibles';
  String get updated => _locale.languageCode == 'en' ? 'Updated' : 'Actualizado';
  String get failedToLoadCurrencies => _locale.languageCode == 'en' ? 'Failed to load currencies' : 'Error al cargar monedas';
  String get selectYourPreferredCurrency => _locale.languageCode == 'en' ? 'Select Your Preferred Currency' : 'Selecciona Tu Moneda Preferida';
  String get currencyPreferenceDescription => _locale.languageCode == 'en' ? 'This will be used for displaying prices and calculations throughout the app.' : 'Esto se usará para mostrar precios y cálculos en toda la aplicación.';
  String get savePreference => _locale.languageCode == 'en' ? 'Save Preference' : 'Guardar Preferencia';
  String get currencyPreferenceUpdatedTo => _locale.languageCode == 'en' ? 'Currency preference updated to' : 'Preferencia de moneda actualizada a';
  String get failedToUpdateCurrencyPreference => _locale.languageCode == 'en' ? 'Failed to update currency preference' : 'Error al actualizar preferencia de moneda';
  String get readyToServeCustomers => _locale.languageCode == 'en' ? 'Ready to serve your customers?' : '¿Listo para servir a tus clientes?';
  String get todaysOrders => _locale.languageCode == 'en' ? 'Today\'s Orders' : 'Pedidos de Hoy';
  String get activeTables => _locale.languageCode == 'en' ? 'Active Tables' : 'Mesas Activas';
  String get tipsEarned => _locale.languageCode == 'en' ? 'Tips Earned' : 'Propinas Ganadas';
  String get quickActions => _locale.languageCode == 'en' ? 'Quick Actions' : 'Acciones Rápidas';
  String get viewTables => _locale.languageCode == 'en' ? 'View Tables' : 'Ver Mesas';
  String get kitchenView => _locale.languageCode == 'en' ? 'Kitchen View' : 'Vista de Cocina';
  String get messagesAndPromotions => _locale.languageCode == 'en' ? 'Messages & Promotions' : 'Mensajes y Promociones';
  String get error => _locale.languageCode == 'en' ? 'Error' : 'Error';
  String get urgent => _locale.languageCode == 'en' ? 'URGENT' : 'URGENTE';
  String get created => _locale.languageCode == 'en' ? 'Created' : 'Creado';
  String get markAsRead => _locale.languageCode == 'en' ? 'Mark as Read' : 'Marcar como Leído';
  String get noMessagesOrPromotions => _locale.languageCode == 'en' ? 'No messages or promotions' : 'No hay mensajes o promociones';
  String get checkBackLaterForUpdates => _locale.languageCode == 'en' ? 'Check back later for updates' : 'Revisa más tarde para actualizaciones';
  String get errorLoadingMessages => _locale.languageCode == 'en' ? 'Error loading messages' : 'Error al cargar mensajes';
  String get todaysPerformance => _locale.languageCode == 'en' ? 'Today\'s Performance' : 'Rendimiento de Hoy';
  String get recentOrders => _locale.languageCode == 'en' ? 'Recent Orders' : 'Pedidos Recientes';
  String get order => _locale.languageCode == 'en' ? 'Order' : 'Pedido';
  String get table => _locale.languageCode == 'en' ? 'Table' : 'Mesa';
  String get refreshTables => _locale.languageCode == 'en' ? 'Refresh Tables' : 'Actualizar Mesas';
  String get floorPlanView => _locale.languageCode == 'en' ? 'Floor Plan View' : 'Vista del Plano';
  String get noFloorPlansAvailable => _locale.languageCode == 'en' ? 'No floor plans available. Please create a floor plan first.' : 'No hay planos disponibles. Por favor crea un plano primero.';
  String get searchTables => _locale.languageCode == 'en' ? 'Search tables...' : 'Buscar mesas...';
  String get all => _locale.languageCode == 'en' ? 'All' : 'Todos';
  String get loadingTables => _locale.languageCode == 'en' ? 'Loading tables...' : 'Cargando mesas...';
  String get errorLoadingTables => _locale.languageCode == 'en' ? 'Error loading tables' : 'Error al cargar mesas';
  String get noTablesFoundMatching => _locale.languageCode == 'en' ? 'No tables found matching' : 'No se encontraron mesas que coincidan con';
  String get noAvailableTables => _locale.languageCode == 'en' ? 'No available tables' : 'No hay mesas disponibles';
  String get noOccupiedTables => _locale.languageCode == 'en' ? 'No occupied tables' : 'No hay mesas ocupadas';
  String get noReservedTables => _locale.languageCode == 'en' ? 'No reserved tables' : 'No hay mesas reservadas';
  String get noTablesBeingCleaned => _locale.languageCode == 'en' ? 'No tables being cleaned' : 'No hay mesas siendo limpiadas';
  String get noTablesFound => _locale.languageCode == 'en' ? 'No tables found' : 'No se encontraron mesas';
  String get checkBackLaterOrTryDifferentFilter => _locale.languageCode == 'en' ? 'Check back later or try a different filter' : 'Revisa más tarde o intenta un filtro diferente';
  String get seats => _locale.languageCode == 'en' ? 'seats' : 'asientos';
  String get selectOpenOrder => _locale.languageCode == 'en' ? 'Select Open Order' : 'Seleccionar Pedido Abierto';
  String get details => _locale.languageCode == 'en' ? 'Details' : 'Detalles';
  String get capacity => _locale.languageCode == 'en' ? 'Capacity' : 'Capacidad';
  String get customer => _locale.languageCode == 'en' ? 'Customer' : 'Cliente';
  String get assignedTo => _locale.languageCode == 'en' ? 'Assigned to' : 'Asignado a';
  String get lastActivity => _locale.languageCode == 'en' ? 'Last Activity' : 'Última Actividad';
  String get reservation => _locale.languageCode == 'en' ? 'Reservation' : 'Reserva';
  String get orderItems => _locale.languageCode == 'en' ? 'Order Items' : 'Artículos del Pedido';
  String get noItems => _locale.languageCode == 'en' ? 'No items' : 'Sin artículos';
  String get reserveTable => _locale.languageCode == 'en' ? 'Reserve Table' : 'Reservar Mesa';
  String get time => _locale.languageCode == 'en' ? 'Time' : 'Hora';
  String get selectTime => _locale.languageCode == 'en' ? 'Select Time' : 'Seleccionar Hora';
  String get reserve => _locale.languageCode == 'en' ? 'Reserve' : 'Reservar';
  String get placeholder => _locale.languageCode == 'en' ? 'placeholder' : 'marcador de posición';
  String get seatCustomerAtTable => _locale.languageCode == 'en' ? 'Seat Customer at Table' : 'Sentar Cliente en Mesa';
  String get partySize => _locale.languageCode == 'en' ? 'Party Size' : 'Tamaño del Grupo';
  String get pleaseEnterValidNameAndPartySize => _locale.languageCode == 'en' ? 'Please enter a valid name and party size.' : 'Por favor ingresa un nombre válido y tamaño del grupo.';
  String get customerSeatedAtTable => _locale.languageCode == 'en' ? 'Customer seated at table' : 'Cliente sentado en mesa';
  String get failedToSeatCustomer => _locale.languageCode == 'en' ? 'Failed to seat customer' : 'Error al sentar cliente';
  String get seat => _locale.languageCode == 'en' ? 'Seat' : 'Sentar';
  String get clearingTable => _locale.languageCode == 'en' ? 'Clearing table' : 'Limpiando mesa';
  String get clearedSuccessfully => _locale.languageCode == 'en' ? 'cleared successfully' : 'limpiada exitosamente';
  String get failedToClearTable => _locale.languageCode == 'en' ? 'Failed to clear table' : 'Error al limpiar mesa';
  String get checkInReservationForTable => _locale.languageCode == 'en' ? 'Check-in Reservation for Table' : 'Check-in de Reserva para Mesa';
  String get reservationCheckedInForTable => _locale.languageCode == 'en' ? 'Reservation checked in for table' : 'Reserva registrada para mesa';
  String get failedToCheckIn => _locale.languageCode == 'en' ? 'Failed to check-in' : 'Error al registrar';
  String get checkIn => _locale.languageCode == 'en' ? 'Check-in' : 'Registrar';
  String get view => _locale.languageCode == 'en' ? 'View' : 'Ver';
  String get ready => _locale.languageCode == 'en' ? 'Ready' : 'Listo';
  String get addItems => _locale.languageCode == 'en' ? 'Add Items' : 'Agregar Artículos';
  String get start => _locale.languageCode == 'en' ? 'Start' : 'Iniciar';
  
  // Order taking screen strings
  String get orderForTable => _locale.languageCode == 'en' ? 'Order - Table' : 'Pedido - Mesa';
  String get refreshOrders => _locale.languageCode == 'en' ? 'Refresh Orders' : 'Actualizar Pedidos';
  String get loadingTableOrders => _locale.languageCode == 'en' ? 'Loading table orders...' : 'Cargando pedidos de mesa...';
  String get errorLoadingOrders => _locale.languageCode == 'en' ? 'Error loading orders' : 'Error al cargar pedidos';
  String get customerDetails => _locale.languageCode == 'en' ? 'Customer Details' : 'Detalles del Cliente';
  String get customerNameLabel => _locale.languageCode == 'en' ? 'Customer Name' : 'Nombre del Cliente';
  String get enterCustomerName => _locale.languageCode == 'en' ? 'Enter customer name' : 'Ingresa el nombre del cliente';
  String get specialInstructions => _locale.languageCode == 'en' ? 'Special Instructions' : 'Instrucciones Especiales';
  String get specialInstructionsHint => _locale.languageCode == 'en' ? 'Allergies, preferences, etc.' : 'Alergias, preferencias, etc.';
  String get menuItems => _locale.languageCode == 'en' ? 'Menu Items' : 'Artículos del Menú';
  String get noMenuItemsAvailable => _locale.languageCode == 'en' ? 'No menu items available' : 'No hay artículos de menú disponibles';
  String get menuItemsTemporarilyUnavailable => _locale.languageCode == 'en' ? 'Menu items temporarily unavailable' : 'Artículos del menú temporalmente no disponibles';
  String get existingOrderItemsWillStillBeShown => _locale.languageCode == 'en' ? 'Existing order items will still be shown' : 'Los artículos del pedido existente seguirán mostrándose';
  String get unavailable => _locale.languageCode == 'en' ? 'Unavailable' : 'No Disponible';
  String get orderItemsCount => _locale.languageCode == 'en' ? 'Order Items' : 'Artículos del Pedido';
  String get noItemsInCart => _locale.languageCode == 'en' ? 'No items in cart' : 'No hay artículos en el carrito';
  String get subtotal => _locale.languageCode == 'en' ? 'Subtotal:' : 'Subtotal:';
  String get tax => _locale.languageCode == 'en' ? 'Tax (8.5%):' : 'Impuesto (8.5%):';
  String get totalWithColon => _locale.languageCode == 'en' ? 'Total:' : 'Total:';
  String get submitOrder => _locale.languageCode == 'en' ? 'Submit Order' : 'Enviar Pedido';
  String get submitting => _locale.languageCode == 'en' ? 'Submitting...' : 'Enviando...';
  String get splitBill => _locale.languageCode == 'en' ? 'Split Bill' : 'Dividir Cuenta';
  String get pleaseAddItemsToOrder => _locale.languageCode == 'en' ? 'Please add items to the order' : 'Por favor agrega artículos al pedido';
  String get orderSubmittedSuccessfully => _locale.languageCode == 'en' ? 'Order submitted successfully!' : '¡Pedido enviado exitosamente!';
  String get failedToSubmitOrder => _locale.languageCode == 'en' ? 'Failed to submit order:' : 'Error al enviar pedido:';
  
  // Waiter dashboard screen strings
  String get pendingOrders => _locale.languageCode == 'en' ? 'Pending Orders' : 'Pedidos Pendientes';
  String get todaysTips => _locale.languageCode == 'en' ? 'Today\'s Tips' : 'Propinas de Hoy';
  String get orderHistory => _locale.languageCode == 'en' ? 'Order History' : 'Historial de Pedidos';
  String get viewPastOrders => _locale.languageCode == 'en' ? 'View past orders' : 'Ver pedidos anteriores';
  String get manageCustomerDetails => _locale.languageCode == 'en' ? 'Manage customer details' : 'Gestionar detalles del cliente';
  String get customerInformation => _locale.languageCode == 'en' ? 'Customer Information' : 'Información del Cliente';
  String get inventoryCheck => _locale.languageCode == 'en' ? 'Inventory Check' : 'Verificación de Inventario';
  String get checkItemAvailability => _locale.languageCode == 'en' ? 'Check item availability' : 'Verificar disponibilidad de artículos';
  String get dailyReport => _locale.languageCode == 'en' ? 'Daily Report' : 'Reporte Diario';
  String get viewDailySummary => _locale.languageCode == 'en' ? 'View daily summary' : 'Ver resumen diario';
  String get tableOrderCompleted => _locale.languageCode == 'en' ? 'Table' : 'Mesa';
  String get orderCompletedLowercase => _locale.languageCode == 'en' ? 'order completed' : 'pedido completado';
  String get newCustomerAtTable => _locale.languageCode == 'en' ? 'New customer at Table' : 'Nuevo cliente en Mesa';
  String get kitchenNotificationTableReady => _locale.languageCode == 'en' ? 'Kitchen notification: Table' : 'Notificación de cocina: Mesa';
  String get readyLowercase => _locale.languageCode == 'en' ? 'ready' : 'lista';
  String get promotionUpdated => _locale.languageCode == 'en' ? 'Promotion updated:' : 'Promoción actualizada:';
  String get happyHourSpecial => _locale.languageCode == 'en' ? 'Happy Hour Special' : 'Especial de Happy Hour';
  String get comingSoon => _locale.languageCode == 'en' ? 'Coming Soon' : 'Próximamente';
  String get waiter => _locale.languageCode == 'en' ? 'Waiter' : 'Mesero';
  
  // Admin dashboard screen strings
  String get accessDenied => _locale.languageCode == 'en' ? 'Access Denied' : 'Acceso Denegado';
  String get accessDeniedDescription => _locale.languageCode == 'en' ? 'This feature is only available to system administrators.' : 'Esta función solo está disponible para administradores del sistema.';
  String get systemAdministration => _locale.languageCode == 'en' ? 'System Administration' : 'Administración del Sistema';
  String get multiTenantPosManagement => _locale.languageCode == 'en' ? 'Multi-tenant POS Management' : 'Gestión Multi-tenant de POS';
  String get multiTenantPosDescription => _locale.languageCode == 'en' ? 'Manage all businesses, menus, inventory, and system settings from one centralized dashboard.' : 'Gestiona todos los negocios, menús, inventario y configuraciones del sistema desde un panel centralizado.';
  String get systemOverview => _locale.languageCode == 'en' ? 'System Overview' : 'Resumen del Sistema';
  String get totalBusinesses => _locale.languageCode == 'en' ? 'Total Businesses' : 'Negocios Totales';
  String get activeUsers => _locale.languageCode == 'en' ? 'Active Users' : 'Usuarios Activos';
  String get manageBusinesses => _locale.languageCode == 'en' ? 'Manage Businesses' : 'Gestionar Negocios';
  String get createEditManageAllBusinesses => _locale.languageCode == 'en' ? 'Create, edit, and manage all businesses' : 'Crear, editar y gestionar todos los negocios';
  String get viewPerformanceMetricsAndReports => _locale.languageCode == 'en' ? 'View performance metrics and reports' : 'Ver métricas de rendimiento y reportes';
  String get businessSettings => _locale.languageCode == 'en' ? 'Business Settings' : 'Configuración de Negocios';
  String get configureBusinessSpecificSettings => _locale.languageCode == 'en' ? 'Configure business-specific settings' : 'Configurar ajustes específicos del negocio';
  String get businessUsers => _locale.languageCode == 'en' ? 'Business Users' : 'Usuarios del Negocio';
  String get manageUsersAcrossAllBusinesses => _locale.languageCode == 'en' ? 'Manage users across all businesses' : 'Gestionar usuarios en todos los negocios';
  String get crudOperationsForAllMenuItems => _locale.languageCode == 'en' ? 'CRUD operations for all menu items' : 'Operaciones CRUD para todos los artículos del menú';
  String get manageMenuCategories => _locale.languageCode == 'en' ? 'Manage menu categories' : 'Gestionar categorías del menú';
  String get generateProfessionalPdfMenus => _locale.languageCode == 'en' ? 'Generate professional PDF menus' : 'Generar menús PDF profesionales';
  String get customTemplates => _locale.languageCode == 'en' ? 'Custom Templates' : 'Plantillas Personalizadas';
  String get manageCustomMenuTemplates => _locale.languageCode == 'en' ? 'Manage custom menu templates' : 'Gestionar plantillas de menú personalizadas';
  String get menuTemplates => _locale.languageCode == 'en' ? 'Menu Templates' : 'Plantillas de Menú';
  String get createAndManageMenuTemplates => _locale.languageCode == 'en' ? 'Create and manage menu templates' : 'Crear y gestionar plantillas de menú';
  String get menuAnalytics => _locale.languageCode == 'en' ? 'Menu Analytics' : 'Análisis de Menús';
  String get menuPerformanceAndInsights => _locale.languageCode == 'en' ? 'Menu performance and insights' : 'Rendimiento e insights del menú';
  String get inventoryManagement => _locale.languageCode == 'en' ? 'Inventory Management' : 'Gestión de Inventario';
  String get inventoryItems => _locale.languageCode == 'en' ? 'Inventory Items' : 'Artículos de Inventario';
  String get manageAllInventoryItems => _locale.languageCode == 'en' ? 'Manage all inventory items' : 'Gestionar todos los artículos del inventario';
  String get stockManagement => _locale.languageCode == 'en' ? 'Stock Management' : 'Gestión de Stock';
  String get trackAndManageStockLevels => _locale.languageCode == 'en' ? 'Track and manage stock levels' : 'Rastrear y gestionar niveles de stock';
  String get suppliers => _locale.languageCode == 'en' ? 'Suppliers' : 'Proveedores';
  String get manageSuppliersAndVendors => _locale.languageCode == 'en' ? 'Manage suppliers and vendors' : 'Gestionar proveedores y vendedores';
  String get inventoryReports => _locale.languageCode == 'en' ? 'Inventory Reports' : 'Reportes de Inventario';
  String get generateInventoryReports => _locale.languageCode == 'en' ? 'Generate inventory reports' : 'Generar reportes de inventario';
  String get userManagement => _locale.languageCode == 'en' ? 'User Management' : 'Gestión de Usuarios';
  String get systemUsers => _locale.languageCode == 'en' ? 'System Users' : 'Usuarios del Sistema';
  String get manageAllSystemUsers => _locale.languageCode == 'en' ? 'Manage all system users' : 'Gestionar todos los usuarios del sistema';
  String get rolesAndPermissions => _locale.languageCode == 'en' ? 'Roles & Permissions' : 'Roles y Permisos';
  String get configureUserRolesAndPermissions => _locale.languageCode == 'en' ? 'Configure user roles and permissions' : 'Configurar roles y permisos de usuario';
  String get userActivity => _locale.languageCode == 'en' ? 'User Activity' : 'Actividad de Usuario';
  String get monitorUserActivityAndLogs => _locale.languageCode == 'en' ? 'Monitor user activity and logs' : 'Monitorear actividad de usuario y logs';
  String get accessControl => _locale.languageCode == 'en' ? 'Access Control' : 'Control de Acceso';
  String get manageAccessAndSecurity => _locale.languageCode == 'en' ? 'Manage access and security' : 'Gestionar acceso y seguridad';
  String get systemSettings => _locale.languageCode == 'en' ? 'System Settings' : 'Configuración del Sistema';
  String get systemConfiguration => _locale.languageCode == 'en' ? 'System Configuration' : 'Configuración del Sistema';
  String get configureSystemWideSettings => _locale.languageCode == 'en' ? 'Configure system-wide settings' : 'Configurar ajustes del sistema';
  String get backupAndRestore => _locale.languageCode == 'en' ? 'Backup & Restore' : 'Respaldo y Restauración';
  String get manageSystemBackups => _locale.languageCode == 'en' ? 'Manage system backups' : 'Gestionar respaldos del sistema';
  String get systemLogs => _locale.languageCode == 'en' ? 'System Logs' : 'Logs del Sistema';
  String get viewSystemLogsAndErrors => _locale.languageCode == 'en' ? 'View system logs and errors' : 'Ver logs y errores del sistema';
  String get apiManagement => _locale.languageCode == 'en' ? 'API Management' : 'Gestión de API';
  String get manageApiKeysAndEndpoints => _locale.languageCode == 'en' ? 'Manage API keys and endpoints' : 'Gestionar claves API y endpoints';
  
  // Admin menu management screen strings
  String get goBack => _locale.languageCode == 'en' ? 'Go Back' : 'Volver';
  String get addMenuItem => _locale.languageCode == 'en' ? 'Add Menu Item' : 'Agregar Artículo del Menú';
  String get selectBusiness => _locale.languageCode == 'en' ? 'Select Business' : 'Seleccionar Negocio';
  String get selectOneBusiness => _locale.languageCode == 'en' ? 'Select One Business' : 'Seleccionar Un Negocio';
  String get searchMenuItems => _locale.languageCode == 'en' ? 'Search menu items...' : 'Buscar artículos del menú...';
  String get allCategories => _locale.languageCode == 'en' ? 'All Categories' : 'Todas las Categorías';
  String get availableOnly => _locale.languageCode == 'en' ? 'Available Only' : 'Solo Disponibles';
  String get clearFilters => _locale.languageCode == 'en' ? 'Clear Filters' : 'Limpiar Filtros';
  String get selectABusiness => _locale.languageCode == 'en' ? 'Select a Business' : 'Seleccionar un Negocio';
  String get pleaseSelectABusinessFromDropdown => _locale.languageCode == 'en' ? 'Please select a business from the dropdown above to view and manage menu items.' : 'Por favor selecciona un negocio del menú desplegable arriba para ver y gestionar artículos del menú.';
  String get errorLoadingMenuItems => _locale.languageCode == 'en' ? 'Error Loading Menu Items' : 'Error al Cargar Artículos del Menú';
  String get noMenuItemsFound => _locale.languageCode == 'en' ? 'No menu items found' : 'No se encontraron artículos del menú';
  String get tryAdjustingFiltersOrAddNewMenuItem => _locale.languageCode == 'en' ? 'Try adjusting your filters or add a new menu item.' : 'Intenta ajustar tus filtros o agregar un nuevo artículo del menú.';
  String get categoryId => _locale.languageCode == 'en' ? 'Category ID:' : 'ID de Categoría:';
  String get makeUnavailable => _locale.languageCode == 'en' ? 'Make Unavailable' : 'Hacer No Disponible';
  String get deleteMenuItem => _locale.languageCode == 'en' ? 'Delete Menu Item' : 'Eliminar Artículo del Menú';
  String get areYouSureYouWantToDelete => _locale.languageCode == 'en' ? 'Are you sure you want to delete' : '¿Estás seguro de que quieres eliminar';
  String get menuItemDeletedSuccessfully => _locale.languageCode == 'en' ? 'Menu item deleted successfully' : 'Artículo del menú eliminado exitosamente';
  String get errorDeletingMenuItem => _locale.languageCode == 'en' ? 'Error deleting menu item:' : 'Error al eliminar artículo del menú:';
  String get menuItemMadeUnavailable => _locale.languageCode == 'en' ? 'made unavailable' : 'hecho no disponible';
  String get menuItemMadeAvailable => _locale.languageCode == 'en' ? 'made available' : 'hecho disponible';
  String get successfully => _locale.languageCode == 'en' ? 'successfully' : 'exitosamente';
  String get errorUpdatingMenuItemAvailability => _locale.languageCode == 'en' ? 'Error updating menu item availability:' : 'Error al actualizar disponibilidad del artículo del menú:';
  String get createMenuItem => _locale.languageCode == 'en' ? 'Create Menu Item' : 'Crear Artículo del Menú';
  String get itemName => _locale.languageCode == 'en' ? 'Item Name' : 'Nombre del Artículo';
  String get pleaseEnterAnItemName => _locale.languageCode == 'en' ? 'Please enter an item name' : 'Por favor ingresa un nombre de artículo';
  String get imageUrlOptional => _locale.languageCode == 'en' ? 'Image URL (Optional)' : 'URL de Imagen (Opcional)';
  String get imageUrlHint => _locale.languageCode == 'en' ? 'https://example.com/image.jpg' : 'https://ejemplo.com/imagen.jpg';
  String get pleaseSelectABusinessFirst => _locale.languageCode == 'en' ? 'Please select a business first' : 'Por favor selecciona un negocio primero';
  String get menuItemCreatedSuccessfully => _locale.languageCode == 'en' ? 'Menu item created successfully' : 'Artículo del menú creado exitosamente';
  String get errorCreatingMenuItem => _locale.languageCode == 'en' ? 'Error creating menu item:' : 'Error al crear artículo del menú:';
  String get editMenuItem => _locale.languageCode == 'en' ? 'Edit Menu Item' : 'Editar Artículo del Menú';
  String get pleaseSelectACategory => _locale.languageCode == 'en' ? 'Please select a category' : 'Por favor selecciona una categoría';
  String get menuItemUpdatedSuccessfully => _locale.languageCode == 'en' ? 'Menu item updated successfully' : 'Artículo del menú actualizado exitosamente';
  String get errorUpdatingMenuItem => _locale.languageCode == 'en' ? 'Error updating menu item:' : 'Error al actualizar artículo del menú:';
  String get category => _locale.languageCode == 'en' ? 'Category' : 'Categoría';
  String get description => _locale.languageCode == 'en' ? 'Description' : 'Descripción';
  String get price => _locale.languageCode == 'en' ? 'Price' : 'Precio';
  String get pleaseEnterAPrice => _locale.languageCode == 'en' ? 'Please enter a price' : 'Por favor ingresa un precio';
  String get pleaseEnterAValidPrice => _locale.languageCode == 'en' ? 'Please enter a valid price' : 'Por favor ingresa un precio válido';
  String get business => _locale.languageCode == 'en' ? 'Business' : 'Negocio';
  String get na => _locale.languageCode == 'en' ? 'N/A' : 'N/A';
  
  // Recipe-related strings
  String get newText => _locale.languageCode == 'en' ? 'New' : 'Nuevo';
  String get refreshRecipes => _locale.languageCode == 'en' ? 'Refresh Recipes' : 'Actualizar Recetas';
  String get easy => _locale.languageCode == 'en' ? 'Easy' : 'Fácil';
  String get medium => _locale.languageCode == 'en' ? 'Medium' : 'Medio';
  String get hard => _locale.languageCode == 'en' ? 'Hard' : 'Difícil';
  String get searchRecipes => _locale.languageCode == 'en' ? 'Search recipes...' : 'Buscar recetas...';
  String get activeOnly => _locale.languageCode == 'en' ? 'Active Only' : 'Solo Activos';
  String get searchingRecipes => _locale.languageCode == 'en' ? 'Searching recipes...' : 'Buscando recetas...';
  String get loadingRecipes => _locale.languageCode == 'en' ? 'Loading recipes...' : 'Cargando recetas...';
  String get unableToLoadRecipes => _locale.languageCode == 'en' ? 'Unable to Load Recipes' : 'No se Pudieron Cargar las Recetas';
  String get checkConnectionAndTryAgain => _locale.languageCode == 'en' ? 'Please check your connection and try again' : 'Por favor verifica tu conexión e intenta de nuevo';
  String get tryAgain => _locale.languageCode == 'en' ? 'Try Again' : 'Intentar de Nuevo';
  String get noRecipesFound => _locale.languageCode == 'en' ? 'No Recipes Found' : 'No se Encontraron Recetas';
  String get noRecipesFoundForQuery => _locale.languageCode == 'en' ? 'No recipes found for' : 'No se encontraron recetas para';
  String get clearSearch => _locale.languageCode == 'en' ? 'Clear Search' : 'Limpiar Búsqueda';
  String get noDifficultyRecipes => _locale.languageCode == 'en' ? 'No' : 'No hay';
  String get tryDifferentDifficultyOrCreateNew => _locale.languageCode == 'en' ? 'Try a different difficulty level or create a new recipe' : 'Intenta un nivel de dificultad diferente o crea una nueva receta';
  String get difficulty => _locale.languageCode == 'en' ? 'Difficulty' : 'Dificultad';
  String get prepTime => _locale.languageCode == 'en' ? 'Prep Time' : 'Tiempo de Preparación';
  String get cookTime => _locale.languageCode == 'en' ? 'Cook Time' : 'Tiempo de Cocción';
  String get minutes => _locale.languageCode == 'en' ? 'minutes' : 'minutos';
  String get servings => _locale.languageCode == 'en' ? 'Servings' : 'Porciones';
  String get ingredients => _locale.languageCode == 'en' ? 'Ingredients:' : 'Ingredientes:';
  String get instructions => _locale.languageCode == 'en' ? 'Instructions:' : 'Instrucciones:';
  String get deleteRecipe => _locale.languageCode == 'en' ? 'Delete Recipe' : 'Eliminar Receta';
  String get deleteRecipeConfirmation => _locale.languageCode == 'en' ? 'Are you sure you want to delete' : '¿Estás seguro de que quieres eliminar';
  String get recipeDeletedSuccessfully => _locale.languageCode == 'en' ? 'Recipe deleted successfully' : 'Receta eliminada exitosamente';
  String get failedToDeleteRecipe => _locale.languageCode == 'en' ? 'Failed to delete recipe:' : 'Error al eliminar receta:';
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