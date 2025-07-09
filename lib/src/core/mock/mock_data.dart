import '../../features/inventory/models/inventory_item.dart';
import '../../features/business/models/business.dart';
import '../../features/auth/models/user.dart';

/// Mock data for development and testing
class MockData {
  /// Mock inventory items
  static List<InventoryItem> get mockInventoryItems => [
    InventoryItem(
      id: '1',
      name: 'Coffee',
      sku: 'COF001',
      price: 3.50,
      cost: 1.20,
      stockQuantity: 50,
      category: 'Beverages',
      minStockLevel: 10,
      maxStockLevel: 100,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItem(
      id: '2',
      name: 'Sandwich',
      sku: 'SND001',
      price: 8.99,
      cost: 3.50,
      stockQuantity: 25,
      category: 'Food',
      minStockLevel: 5,
      maxStockLevel: 50,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItem(
      id: '3',
      name: 'Cake Slice',
      sku: 'CAK001',
      price: 4.99,
      cost: 2.00,
      stockQuantity: 15,
      category: 'Desserts',
      minStockLevel: 5,
      maxStockLevel: 30,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    InventoryItem(
      id: '4',
      name: 'Tea',
      sku: 'TEA001',
      price: 2.99,
      cost: 0.80,
      stockQuantity: 8,
      category: 'Beverages',
      minStockLevel: 10,
      maxStockLevel: 80,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  /// Mock businesses
  static List<Business> get mockBusinesses => [
    Business(
      id: 1,
      name: 'Downtown Coffee Shop',
      slug: 'downtown-coffee-shop',
      type: BusinessType.restaurant,
      description: 'A cozy coffee shop in the heart of downtown',
      address: '123 Main St, Downtown',
      phone: '+1-555-0123',
      email: 'info@downtowncoffee.com',
      website: 'https://downtowncoffee.com',
      taxRate: 8.5,
      currency: 'USD',
      timezone: 'America/New_York',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Business(
      id: 2,
      name: 'Uptown Bakery',
      slug: 'uptown-bakery',
      type: BusinessType.restaurant,
      description: 'Fresh baked goods and pastries',
      address: '456 Oak Ave, Uptown',
      phone: '+1-555-0456',
      email: 'hello@uptownbakery.com',
      website: 'https://uptownbakery.com',
      taxRate: 8.5,
      currency: 'USD',
      timezone: 'America/New_York',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  /// Mock user
  static User get mockUser => User(
    id: 1,
    businessId: 1,
    name: 'Demo User',
    email: 'demo@example.com',
    role: UserRole.admin,
    isActive: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  /// Mock categories
  static List<String> get mockCategories => [
    'Beverages',
    'Food',
    'Desserts',
    'Snacks',
    'Supplies',
  ];
} 