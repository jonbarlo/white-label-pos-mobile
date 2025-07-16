# POS System Permissions & Roles Documentation

## Quick Reference

### Role Access Summary
| Role | Dashboard | Analytics | POS | Inventory | Reports | Business Mgmt | Waiter | Kitchen/Bar |
|------|-----------|-----------|-----|-----------|---------|---------------|--------|-------------|
| **Admin** | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Owner** | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Manager** | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Cashier** | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Waiter** | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Kitchen** | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Viewer** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅* |

*Viewer role requires specific assignments (`kitchen_read`, `bar_read`, etc.)

### Key Permissions
- **Analytics**: Admin, Owner, Manager only
- **POS**: Cashier, Waiter, Kitchen Staff only
- **Business Management**: Admin only
- **Reports**: Admin, Owner, Manager, Cashier
- **Inventory**: Admin, Owner, Manager, Cashier

---

## Overview
This document outlines the complete permission system, user roles, and screen access controls for the White Label POS Mobile application.

## User Roles

### Role Hierarchy (Most to Least Privileged)
1. **Admin** - Full system access
2. **Owner** - Business owner with full operational access
3. **Manager** - Operational management with limited admin access
4. **Cashier** - Sales processing and basic reporting
5. **Waiter/Waitstaff** - Order management and table service
6. **Kitchen Staff** - Kitchen operations
7. **Viewer** - Read-only access to assigned areas

### Role Definitions

#### Admin (`admin`)
- **Purpose**: System administrator with full access
- **Responsibilities**: User management, system configuration, business management
- **Access Level**: Full system access

#### Owner (`owner`)
- **Purpose**: Business owner with full operational control
- **Responsibilities**: Business oversight, analytics, financial management
- **Access Level**: Full operational access, limited admin functions

#### Manager (`manager`)
- **Purpose**: Operational management and oversight
- **Responsibilities**: Staff management, inventory control, reporting
- **Access Level**: High operational access, limited admin functions

#### Cashier (`cashier`)
- **Purpose**: Point of sale operations and basic reporting
- **Responsibilities**: Sales processing, customer service, basic reporting
- **Access Level**: Sales operations, basic reporting

#### Waiter (`waiter`) / Waitstaff (`waitstaff`)
- **Purpose**: Table service and order management
- **Responsibilities**: Table management, order taking, customer service
- **Access Level**: Table operations, order management

#### Kitchen Staff (`kitchen_staff`)
- **Purpose**: Kitchen operations and food preparation
- **Responsibilities**: Order preparation, kitchen management
- **Access Level**: Kitchen operations

#### Viewer (`viewer`)
- **Purpose**: Read-only access to assigned areas
- **Responsibilities**: Viewing data and reports
- **Access Level**: Read-only access based on assignment

## Permission System

### Core Permissions

| Permission | Description | Admin | Owner | Manager | Cashier | Waiter | Kitchen | Viewer |
|------------|-------------|-------|-------|---------|---------|--------|---------|--------|
| `canAccessBusinessManagement` | Manage business settings | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `canAccessPOS` | Access point of sale system | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| `canAccessKitchen` | Access kitchen operations | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅* |
| `canAccessWaiterDashboard` | Access waiter dashboard | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `canAccessReports` | Access basic reports | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `canAccessAnalytics` | Access full analytics dashboard | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `canAccessBasicAnalytics` | Access limited analytics | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `canManageUsers` | Manage user accounts | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `canViewOnly` | Read-only access mode | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

*Viewer role requires specific kitchen assignment (`kitchen_read`, `kitchen_write`, etc.)

## Screen Access Matrix

### Authentication & Onboarding
| Screen | Admin | Owner | Manager | Cashier | Waiter | Kitchen | Viewer |
|--------|-------|-------|---------|---------|--------|---------|--------|
| Login Screen | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Onboarding Screen | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Profile Screen | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### Main Application Screens
| Screen | Admin | Owner | Manager | Cashier | Waiter | Kitchen | Viewer |
|--------|-------|-------|---------|---------|--------|---------|--------|
| Dashboard | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Analytics Dashboard | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| POS Screen | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| Inventory Screen | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Reports Screen | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Business Management | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Waiter-Specific Screens
| Screen | Admin | Owner | Manager | Cashier | Waiter | Kitchen | Viewer |
|--------|-------|-------|---------|---------|--------|---------|--------|
| Waiter Dashboard | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Table Selection | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Order Taking | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Split Billing | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |

### Kitchen/Bar Screens
| Screen | Admin | Owner | Manager | Cashier | Waiter | Kitchen | Viewer |
|--------|-------|-------|---------|---------|--------|---------|--------|
| Kitchen Screen | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅* |
| Bar Screen | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅* |

*Viewer role with specific assignments (`kitchen_read`, `bar_read`, etc.)

## Navigation Access

### Bottom Navigation Bar Items
| Navigation Item | Admin | Owner | Manager | Cashier | Waiter | Kitchen | Viewer |
|-----------------|-------|-------|---------|---------|--------|---------|--------|
| Dashboard | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Analytics | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| POS | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| Inventory | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Reports | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Profile | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### Default Landing Pages
| Role | Default Route | Description |
|------|---------------|-------------|
| Admin | `/dashboard` | Main dashboard with full access |
| Owner | `/dashboard` | Business overview dashboard |
| Manager | `/dashboard` | Operational dashboard |
| Cashier | `/dashboard` | Sales-focused dashboard |
| Waiter | `/waiter` | Waiter-specific dashboard |
| Kitchen Staff | `/dashboard` | General dashboard |
| Viewer | `/kitchen` or `/bar` | Role-specific view based on assignment |

## Feature Access Details

### Analytics Dashboard Access
**Full Access (Admin, Owner, Manager):**
- Revenue Performance
- Menu Optimization
- Staff Performance
- Customer Insights
- Inventory Management
- Date range filtering
- All metrics and trends

**No Access (Cashier, Waiter, Kitchen, Viewer):**
- Analytics tab not visible in navigation
- Cannot access analytics routes

### POS System Access
**Full Access (Cashier, Waiter, Kitchen Staff):**
- Sales processing
- Item search and selection
- Payment processing
- Split billing
- Customer management

**No Access (Admin, Owner, Manager, Viewer):**
- POS tab not visible in navigation
- Cannot access POS routes

### Inventory Management
**Full Access (Admin, Owner, Manager, Cashier):**
- View inventory levels
- Stock management
- Item details
- Inventory reports

**No Access (Waiter, Kitchen Staff, Viewer):**
- Inventory tab not visible in navigation
- Cannot access inventory routes

### Reports Access
**Full Access (Admin, Owner, Manager, Cashier):**
- Sales reports
- Basic analytics
- Operational reports

**No Access (Waiter, Kitchen Staff, Viewer):**
- Reports tab not visible in navigation
- Cannot access report routes

### Business Management
**Full Access (Admin only):**
- Business settings
- User management
- System configuration

**No Access (All other roles):**
- Business management not visible
- Cannot access business management routes

## Assignment-Based Access (Viewer Role)

### Kitchen Assignments
- `kitchen_read` - Read-only kitchen access
- `kitchen_write` - Kitchen operations with write access
- `kitchen_manager` - Kitchen management access

### Bar Assignments
- `bar_read` - Read-only bar access
- `bar_write` - Bar operations with write access
- `bar_manager` - Bar management access

### Default Assignment
- `none` - No specific assignment (default)

## Security Considerations

### Authentication Requirements
- All protected routes require valid JWT token
- Token expiration triggers automatic logout
- Unauthorized access attempts redirect to login

### Route Protection
- All main application routes are protected
- Role-based access control at route level
- Assignment-based access for viewer role

### Data Isolation
- Business-scoped data isolation
- Users can only access data from their assigned business
- Cross-business data access prevented

## Implementation Details

### Permission Checking
Permissions are implemented using extension methods on `UserRole`:

```dart
extension UserRoleExtension on UserRole {
  bool get canAccessBusinessManagement => this == UserRole.admin;
  bool get canAccessPOS => this != UserRole.admin && this != UserRole.viewer;
  bool get canAccessKitchen => this == UserRole.viewer;
  bool get canAccessWaiterDashboard => this == UserRole.waiter || this == UserRole.waitstaff;
  bool get canAccessReports => this == UserRole.admin || this == UserRole.owner || this == UserRole.manager;
  bool get canAccessAnalytics => this == UserRole.admin || this == UserRole.owner || this == UserRole.manager;
  bool get canAccessBasicAnalytics => this == UserRole.admin || this == UserRole.owner || this == UserRole.manager || this == UserRole.cashier;
  bool get canManageUsers => this == UserRole.admin;
  bool get canViewOnly => this == UserRole.viewer;
}
```

### AuthState Integration
Permissions are exposed through `AuthState`:

```dart
class AuthState {
  // ... other properties
  
  UserRole? get userRole => user?.role;
  bool get canAccessAnalytics => userRole?.canAccessAnalytics ?? false;
  bool get canAccessPOS => userRole?.canAccessPOS ?? false;
  // ... other permission getters
}
```

### Navigation Control
Navigation items are conditionally rendered based on permissions:

```dart
if (authState.canAccessAnalytics) {
  navigationItems.add(const BottomNavigationBarItem(
    icon: Icon(Icons.analytics),
    label: 'Analytics',
  ));
}
```

## Best Practices

### Role Design Principles
1. **Principle of Least Privilege**: Users get minimum access needed
2. **Separation of Concerns**: Different roles handle different aspects
3. **Scalability**: Easy to add new roles and permissions
4. **Security**: Clear access boundaries and controls

### Permission Management
1. **Centralized**: All permissions defined in one place
2. **Consistent**: Same permission checking across the app
3. **Maintainable**: Easy to modify and extend
4. **Documented**: Clear documentation of all permissions

### Security Guidelines
1. **Always verify permissions** before showing sensitive data
2. **Use role-based routing** to prevent unauthorized access
3. **Implement proper error handling** for permission failures
4. **Log access attempts** for security monitoring
5. **Regular permission audits** to ensure compliance

## Future Enhancements

### Potential New Roles
- **Supervisor**: Mid-level management with limited admin access
- **Accountant**: Financial reporting and analysis access
- **Maintenance**: System maintenance and technical access

### Enhanced Permissions
- **Time-based access**: Permissions that change based on time
- **Location-based access**: Permissions based on physical location
- **Context-aware permissions**: Dynamic permissions based on situation

### Advanced Features
- **Permission delegation**: Temporary permission granting
- **Audit trails**: Detailed logging of permission usage
- **Permission analytics**: Analysis of permission usage patterns 