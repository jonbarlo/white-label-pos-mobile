# Floor Plan Implementation Plan

## Overview
This document outlines the implementation of the floor plan management feature for the POS mobile app, including access control, integration with existing systems, and future considerations.

## Access Control & Permissions

### Who Can Access Floor Plans
- **Admin** - Full access to create, edit, delete floor plans
- **Owner** - Full access to create, edit, delete floor plans  
- **Manager** - Full access to create, edit, delete floor plans
- **Cashier** - No access
- **Waitstaff** - Read-only access to view floor plan for table selection during ordering
- **Kitchen Staff** - No access
- **Viewer** - No access

### Permission Implementation
```dart
bool get canAccessFloorPlans => this == UserRole.admin || 
                               this == UserRole.owner || 
                               this == UserRole.manager;

bool get canViewFloorPlans => this == UserRole.admin || 
                             this == UserRole.owner || 
                             this == UserRole.manager ||
                             this == UserRole.waitstaff;
```

## Current Table System for Waitstaff

### Existing Implementation
The waitstaff currently use a separate table management system located in:
- `lib/src/features/waiter/table_selection_screen.dart` - Grid view of tables
- `lib/src/features/waiter/order_taking_screen.dart` - Order management per table
- `lib/src/features/waiter/models/table.dart` - Table data models
- `lib/src/features/waiter/table_repository.dart` - Table API integration

### Current Features
- ✅ Grid-based table selection
- ✅ Table status management (available, occupied, reserved, cleaning, out of service)
- ✅ Order taking and management
- ✅ Table assignment to waiters
- ✅ Customer seating management
- ✅ **NEW**: Floor plan view option for visual table selection

### Integration Decision
**The floor plan feature serves both management and operational purposes**:

1. **Admin/Owner/Manager**: Use floor plans for visual layout management and editing
2. **Waitstaff**: Use floor plans for visual table selection during ordering workflow
3. **Dual Interface**: Waitstaff can toggle between grid view and floor plan view
4. **Enhanced UX**: Visual floor plan helps waitstaff understand table layout and select tables more intuitively

## Implementation Details

### Files Created
```
lib/src/features/floor_plan/
├── models/
│   ├── floor_plan.dart          # Floor plan data models
│   └── table_position.dart      # Table position models
├── floor_plan_repository.dart   # Repository interface
├── floor_plan_repository_impl.dart # API implementation
├── floor_plan_provider.dart     # Riverpod providers
├── floor_plan_screen.dart       # Main management screen
├── floor_plan_editor_screen.dart # Visual editor
└── floor_plan_viewer_screen.dart # Read-only viewer for waitstaff
```

### API Endpoints Used
- `GET /floor-plans` - List all floor plans
- `GET /floor-plans/{id}` - Get floor plan details
- `POST /floor-plans` - Create floor plan
- `PUT /floor-plans/{id}` - Update floor plan
- `DELETE /floor-plans/{id}` - Delete floor plan
- `GET /floor-plans/{id}/table-positions` - Get table positions
- `POST /floor-plans/{id}/table-positions` - Add table position
- `PUT /floor-plans/{id}/table-positions/{positionId}` - Update table position
- `DELETE /floor-plans/{id}/table-positions/{positionId}` - Remove table position

### Navigation Integration
- Added `floorPlanRoute = '/floor-plans'` to app router
- Floor Plans tab appears in bottom navigation for authorized users
- Integrated with existing role-based access control system

## Features Implemented

### Floor Plan Management Screen
- ✅ List all floor plans with search functionality
- ✅ Create new floor plans (name, dimensions, background image)
- ✅ Edit existing floor plans
- ✅ Delete floor plans with confirmation
- ✅ View floor plan statistics and details

### Floor Plan Editor
- ✅ Visual canvas with background image support
- ✅ Add tables with positioning (x, y coordinates)
- ✅ Color-coded table status display
- ✅ Remove tables from floor plans
- ✅ Real-time updates and error handling

### State Management
- ✅ Riverpod providers for reactive state management
- ✅ Proper loading states and error handling
- ✅ Automatic cache invalidation on updates

## Future Considerations

### Waitstaff Floor Plan Integration

**IMPLEMENTED**: Waitstaff now have access to visual floor plan view for table selection:

1. **Dual View Options**
   - Toggle between grid view and floor plan view
   - Floor plan shows tables with real-time status colors
   - Click tables on floor plan to open order taking screen

2. **Enhanced Table Selection**
   - Visual representation of restaurant layout
   - Intuitive table selection based on physical location
   - Real-time status updates (available, occupied, reserved, etc.)

3. **Seamless Integration**
   - Same order taking workflow regardless of view
   - Floor plan view enhances spatial awareness
   - Maintains existing table management functionality

### Technical Considerations
- **Performance**: Floor plans with many tables may need optimization
- **Offline Support**: Consider caching floor plan data for offline use
- **Real-time Updates**: WebSocket integration for live table status updates
- **Mobile Optimization**: Touch-friendly table positioning and editing

### API Enhancements
- **Bulk Operations**: Add/remove multiple tables at once
- **Table Templates**: Predefined table layouts
- **Floor Plan Templates**: Standard restaurant layouts
- **Export/Import**: Floor plan sharing between locations

## Testing Strategy

### Unit Tests
- Repository methods
- Provider state management
- Model serialization/deserialization

### Widget Tests
- Floor plan management screen
- Floor plan editor interactions
- Navigation and access control

### Integration Tests
- API endpoint integration
- End-to-end floor plan creation flow
- Role-based access verification

## Deployment Notes

### Dependencies
- No additional external dependencies required
- Uses existing Dio client for API calls
- Uses existing Riverpod for state management

### Migration
- No database migration required (uses existing table system)
- Backward compatible with current table management
- Gradual rollout possible with role-based access

### Monitoring
- Track floor plan creation/usage metrics
- Monitor API performance for floor plan endpoints
- User feedback on floor plan management experience

## Conclusion

The floor plan feature provides a powerful visual management tool for restaurant administrators while enhancing the operational experience for waitstaff. The implementation follows established patterns and integrates seamlessly with the existing codebase.

**Key Benefits:**
- **Management**: Visual layout management for admin/owner/manager roles
- **Waitstaff**: Enhanced table selection with visual floor plan view
- **Unified System**: Single floor plan data source serves both management and operational needs
- **Improved UX**: Waitstaff can better understand table layout and make intuitive table selections

The dual-interface approach (grid + floor plan) ensures optimal user experience for different use cases while maintaining system simplicity and performance. 