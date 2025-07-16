# Floor Plan & Table Management Implementation Plan

## Overview
Implement a comprehensive floor plan and table management system that allows restaurant staff to visualize table layouts, manage reservations, track table status, and optimize seating arrangements for better operational efficiency.

## Core Features

### 1. Floor Plan Visualization
- Interactive table layout display
- Drag-and-drop table positioning
- Multiple floor/area support
- Real-time table status indicators
- Responsive design for mobile and desktop

### 2. Table Management
- Table status tracking (available, occupied, reserved, cleaning)
- Table capacity management
- Table grouping and sectioning
- Table notes and special instructions
- Table history and analytics

### 3. Reservation System
- Real-time reservation display
- Reservation conflict detection
- Waitlist management
- Reservation time slots
- Customer information integration

### 4. Operational Features
- Quick table status updates
- Order-to-table assignment
- Server assignment to tables
- Table transfer capabilities
- Performance analytics

## Implementation Tasks

### Phase 1: Data Models & Repository Layer

#### 1.1 Create Data Models
- **Floor Model**
  - `id`, `name`, `description`
  - `width`, `height` (dimensions)
  - `background_image_url`
  - `is_active`

- **Table Model**
  - `id`, `name`, `number`
  - `floor_id`, `position_x`, `position_y`
  - `capacity`, `shape` (round, square, rectangle)
  - `status` (available, occupied, reserved, cleaning)
  - `current_order_id`, `assigned_server_id`
  - `notes`, `special_instructions`

- **Reservation Model**
  - `id`, `customer_name`, `phone`, `email`
  - `table_id`, `party_size`
  - `reservation_time`, `duration`
  - `status` (confirmed, pending, cancelled)
  - `special_requests`, `notes`

- **TableStatus Model**
  - `id`, `table_id`, `status`
  - `timestamp`, `updated_by`
  - `notes`, `duration`

#### 1.2 Implement Repository Layer
- **FloorRepository**
  - `getFloors()` - Get all active floors
  - `getFloorById(id)` - Get specific floor with tables
  - `createFloor(floor)` - Create new floor
  - `updateFloor(floor)` - Update floor details
  - `deleteFloor(id)` - Deactivate floor

- **TableRepository**
  - `getTablesByFloor(floorId)` - Get all tables for a floor
  - `getTableById(id)` - Get specific table details
  - `createTable(table)` - Add new table
  - `updateTable(table)` - Update table details
  - `updateTableStatus(tableId, status)` - Update table status
  - `deleteTable(id)` - Remove table

- **ReservationRepository**
  - `getReservationsByDate(date)` - Get reservations for specific date
  - `getReservationsByTable(tableId)` - Get table reservations
  - `createReservation(reservation)` - Create new reservation
  - `updateReservation(reservation)` - Update reservation
  - `cancelReservation(id)` - Cancel reservation
  - `checkConflicts(tableId, time, duration)` - Check for booking conflicts

### Phase 2: State Management & Providers

#### 2.1 Create Riverpod Providers
- **FloorProvider**
  - Floor list state management
  - Current floor selection
  - Floor CRUD operations

- **TableProvider**
  - Table state management
  - Table status updates
  - Table positioning and layout

- **ReservationProvider**
  - Reservation state management
  - Conflict detection
  - Waitlist management

- **FloorPlanProvider**
  - Combined floor plan state
  - Real-time updates
  - Performance optimization

#### 2.2 API Integration
- Implement API endpoints for all CRUD operations
- Real-time updates using WebSocket or polling
- Error handling and retry logic
- Data synchronization

### Phase 3: UI Components

#### 3.1 Core UI Components
- **FloorPlanCanvas**
  - Interactive canvas for table layout
  - Drag-and-drop functionality
  - Zoom and pan controls
  - Grid snapping

- **TableWidget**
  - Individual table display
  - Status indicators
  - Capacity display
  - Quick action menu

- **ReservationWidget**
  - Reservation display
  - Time slot visualization
  - Conflict warnings
  - Quick edit capabilities

#### 3.2 Management Screens
- **FloorPlanScreen**
  - Main floor plan view
  - Table management interface
  - Real-time status updates

- **TableManagementScreen**
  - Table CRUD operations
  - Bulk operations
  - Import/export functionality

- **ReservationScreen**
  - Reservation management
  - Calendar view
  - Waitlist management

### Phase 4: Advanced Features

#### 4.1 Interactive Features
- Drag-and-drop table positioning
- Real-time collaboration
- Undo/redo functionality
- Auto-save capabilities

#### 4.2 Analytics & Reporting
- Table utilization analytics
- Peak hour analysis
- Server performance tracking
- Revenue per table

#### 4.3 Integration Features
- POS system integration
- Customer management integration
- Staff scheduling integration
- Kitchen display system integration

## Technical Requirements

### Dependencies
- `flutter_svg` for scalable graphics
- `provider` or `riverpod` for state management
- `intl` for date/time formatting
- `shared_preferences` for local storage
- `web_socket_channel` for real-time updates

### File Structure
```
lib/src/features/floor_plan/
├── models/
│   ├── floor.dart
│   ├── table.dart
│   ├── reservation.dart
│   └── table_status.dart
├── providers/
│   ├── floor_provider.dart
│   ├── table_provider.dart
│   ├── reservation_provider.dart
│   └── floor_plan_provider.dart
├── repositories/
│   ├── floor_repository.dart
│   ├── table_repository.dart
│   └── reservation_repository.dart
├── screens/
│   ├── floor_plan_screen.dart
│   ├── table_management_screen.dart
│   └── reservation_screen.dart
└── widgets/
    ├── floor_plan_canvas.dart
    ├── table_widget.dart
    ├── reservation_widget.dart
    └── status_indicator.dart
```

### API Endpoints (Proposed)
- `GET /api/floors` - Get all floors
- `GET /api/floors/{id}` - Get floor with tables
- `POST /api/floors` - Create floor
- `PUT /api/floors/{id}` - Update floor
- `DELETE /api/floors/{id}` - Delete floor

- `GET /api/tables` - Get all tables
- `GET /api/tables/{id}` - Get table details
- `POST /api/tables` - Create table
- `PUT /api/tables/{id}` - Update table
- `PUT /api/tables/{id}/status` - Update table status
- `DELETE /api/tables/{id}` - Delete table

- `GET /api/reservations` - Get reservations
- `GET /api/reservations/{id}` - Get reservation details
- `POST /api/reservations` - Create reservation
- `PUT /api/reservations/{id}` - Update reservation
- `DELETE /api/reservations/{id}` - Cancel reservation

## Access Control
- **Admin**: Full access to all floor plan features
- **Manager**: Full access to floor plan and table management
- **Server**: View floor plan, update table status, manage reservations
- **Cashier**: View floor plan, basic table status

## Success Criteria
1. Interactive floor plan with drag-and-drop functionality
2. Real-time table status updates
3. Comprehensive reservation management
4. Responsive design for all screen sizes
5. Integration with existing POS system
6. Performance optimized for real-time updates

## Future Enhancements
1. 3D floor plan visualization
2. AI-powered table optimization
3. Customer preference tracking
4. Advanced analytics and reporting
5. Mobile app for servers
6. Integration with external reservation systems

## Notes
- Ensure all components follow Flutter best practices
- Implement proper error handling and loading states
- Use consistent theming with the rest of the app
- Consider offline capabilities for basic functionality
- Implement proper data validation and sanitization
- Follow existing code conventions and patterns 