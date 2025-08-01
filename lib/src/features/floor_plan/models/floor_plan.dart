

class Customer {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? preferences;

  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.preferences,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: (json['id'] as num).toInt(),
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    preferences: json['preferences'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'preferences': preferences,
  };

  String get fullName => '$firstName $lastName';
}

class Reservation {
  final int? id;
  final int? customerId;
  final String customerName;
  final String? customerPhone;
  final String? customerEmail;
  final int partySize;
  final String reservationDate;
  final String reservationTime;
  final String? notes;
  final String? status;
  final Customer? customer;

  const Reservation({
    this.id,
    this.customerId,
    required this.customerName,
    this.customerPhone,
    this.customerEmail,
    required this.partySize,
    required this.reservationDate,
    required this.reservationTime,
    this.notes,
    this.status,
    this.customer,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    // Handle both old and new API structures
    final customerName = json['customerName'] as String? ?? 
                        (json['customer'] != null ? 
                          '${json['customer']['firstName']} ${json['customer']['lastName']}' : 
                          'Unknown Customer');
    
    final customerPhone = json['customerPhone'] as String? ?? 
                         (json['customer'] != null ? json['customer']['phone'] as String? : null);
    
    final customerEmail = json['customerEmail'] as String? ?? 
                         (json['customer'] != null ? json['customer']['email'] as String? : null);

    Customer? customer;
    if (json['customer'] != null && json['customer'] is Map<String, dynamic>) {
      customer = Customer.fromJson(json['customer'] as Map<String, dynamic>);
    }

    return Reservation(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      customerId: json['customerId'] != null ? (json['customerId'] as num).toInt() : null,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      partySize: (json['partySize'] as num).toInt(),
      reservationDate: json['reservationDate'] as String,
      reservationTime: json['reservationTime'] as String,
      notes: json['notes'] as String? ?? json['specialRequests'] as String?,
      status: json['status'] as String?,
      customer: customer,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerEmail': customerEmail,
    'partySize': partySize,
    'reservationDate': reservationDate,
    'reservationTime': reservationTime,
    'notes': notes,
    'status': status,
    'customer': customer?.toJson(),
  };

  // Format date for display (e.g., "Today, Jan 15")
  String get formattedDate {
    try {
      final date = DateTime.parse(reservationDate);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final reservationDay = DateTime(date.year, date.month, date.day);
      
      if (reservationDay == today) {
        return 'Today, ${_formatDate(date)}';
      } else if (reservationDay == today.add(const Duration(days: 1))) {
        return 'Tomorrow, ${_formatDate(date)}';
      } else {
        return _formatDate(date);
      }
    } catch (e) {
      return reservationDate;
    }
  }

  // Format time for display (e.g., "7:00 PM")
  String get formattedTime {
    try {
      final timeParts = reservationTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      
      return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return reservationTime;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class FloorPlan {
  final int id;
  final int businessId;
  final String name;
  final int width;
  final int height;
  final String? backgroundImage;
  final bool isActive;
  final int? tableCount;
  final List<TablePosition>? tables;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FloorPlan({
    required this.id,
    required this.businessId,
    required this.name,
    required this.width,
    required this.height,
    this.backgroundImage,
    required this.isActive,
    this.tableCount,
    this.tables,
    this.createdAt,
    this.updatedAt,
  });

  // Custom fromJson to handle type mismatches and missing fields
  factory FloorPlan.fromJson(Map<String, dynamic> json) {
    // Handle tablePositions field from API response
    List<TablePosition>? tables;
    if (json['tablePositions'] is List) {
      // API returns tablePositions with nested table data
      tables = (json['tablePositions'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) {
        final positionData = e as Map<String, dynamic>;
        final tableData = positionData['table'] as Map<String, dynamic>?;
        
        if (tableData != null) {
          // Combine position data with table data
          return TablePosition.fromJson({
            ...positionData,
            'tableId': tableData['id'],
            'tableNumber': tableData['tableNumber'],
            'tableCapacity': tableData['capacity'],
            'tableStatus': tableData['status'],
            'tableSection': tableData['section'],
          });
        } else {
          // Fallback to direct position data
          return TablePosition.fromJson(positionData);
        }
      }).toList();
    } else if (json['tables'] is List) {
      // Direct tables field (fallback)
      tables = (json['tables'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => TablePosition.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return FloorPlan(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      backgroundImage: json['backgroundImage'] as String?,
      isActive: json['isActive'] as bool,
      tableCount: tables?.length,
      tables: tables,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'businessId': businessId,
    'name': name,
    'width': width,
    'height': height,
    'backgroundImage': backgroundImage,
    'isActive': isActive,
    'tableCount': tableCount,
    'tables': tables?.map((t) => t.toJson()).toList(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class TablePosition {
  final int id;
  final int tableId;
  final String tableNumber;
  final int tableCapacity;
  final String tableStatus;
  final String tableSection;
  final int x;
  final int y;
  final int rotation;
  final int width;
  final int height;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Reservation? reservation;

  const TablePosition({
    required this.id,
    required this.tableId,
    required this.tableNumber,
    required this.tableCapacity,
    required this.tableStatus,
    required this.tableSection,
    required this.x,
    required this.y,
    required this.rotation,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
    this.reservation,
  });

  // Custom fromJson to handle type mismatches and missing fields
  factory TablePosition.fromJson(Map<String, dynamic> json) {
    // Debug logging for table status
    print('🔍 DEBUG: TablePosition.fromJson: Processing table ${json['tableNumber']}');
    print('🔍 DEBUG: TablePosition.fromJson: Raw tableStatus from JSON: ${json['tableStatus']}');
    print('🔍 DEBUG: TablePosition.fromJson: Available fields: ${json.keys.toList()}');
    
    // Handle null tableStatus with safe casting
    final rawTableStatus = json['tableStatus'];
    final tableStatus = rawTableStatus != null ? rawTableStatus.toString() : 'available';
    print('🔍 DEBUG: TablePosition.fromJson: Final tableStatus: $tableStatus');
    
    // Parse reservation data if present
    Reservation? reservation;
    if (json['reservation'] != null && json['reservation'] is Map<String, dynamic>) {
      try {
        reservation = Reservation.fromJson(json['reservation'] as Map<String, dynamic>);
        print('🔍 DEBUG: TablePosition.fromJson: Parsed reservation for table ${json['tableNumber']}: ${reservation.customerName}');
      } catch (e) {
        print('🔍 DEBUG: TablePosition.fromJson: Error parsing reservation for table ${json['tableNumber']}: $e');
      }
    }
    
    // Handle missing fields with defaults
    final tableCapacity = json['tableCapacity'] ?? json['capacity'] ?? 4; // Default to 4 seats
    final tableSection = json['tableSection'] ?? json['section'] ?? 'Main Floor'; // Default section
    
    return TablePosition(
      id: (json['id'] as num).toInt(),
      tableId: (json['tableId'] as num).toInt(),
      tableNumber: json['tableNumber']?.toString() ?? 'Unknown',
      tableCapacity: (tableCapacity is num) ? tableCapacity.toInt() : int.tryParse(tableCapacity.toString()) ?? 4,
      tableStatus: tableStatus,
      tableSection: tableSection.toString(),
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      rotation: (json['rotation'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
      reservation: reservation,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tableId': tableId,
    'tableNumber': tableNumber,
    'tableCapacity': tableCapacity,
    'tableStatus': tableStatus,
    'tableSection': tableSection,
    'x': x,
    'y': y,
    'rotation': rotation,
    'width': width,
    'height': height,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'reservation': reservation?.toJson(),
  };

  String get statusColor {
    switch (tableStatus.toLowerCase()) {
      case 'available':
        return '#4CAF50'; // Green
      case 'occupied':
        return '#F44336'; // Red
      case 'reserved':
        return '#FF9800'; // Orange
      case 'cleaning':
        return '#2196F3'; // Blue
      case 'out_of_service':
        return '#9E9E9E'; // Grey
      default:
        return '#4CAF50'; // Default to green
    }
  }

  TablePosition copyWith({
    int? id,
    int? tableId,
    String? tableNumber,
    int? tableCapacity,
    String? tableStatus,
    String? tableSection,
    int? x,
    int? y,
    int? rotation,
    int? width,
    int? height,
    DateTime? createdAt,
    DateTime? updatedAt,
    Reservation? reservation,
  }) {
    return TablePosition(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      tableCapacity: tableCapacity ?? this.tableCapacity,
      tableStatus: tableStatus ?? this.tableStatus,
      tableSection: tableSection ?? this.tableSection,
      x: x ?? this.x,
      y: y ?? this.y,
      rotation: rotation ?? this.rotation,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reservation: reservation ?? this.reservation,
    );
  }
} 