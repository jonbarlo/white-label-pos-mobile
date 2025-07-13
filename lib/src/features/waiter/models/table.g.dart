// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableImpl _$$TableImplFromJson(Map<String, dynamic> json) => _$TableImpl(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      tableNumber: json['tableNumber'] as String,
      status: $enumDecode(_$TableStatusEnumMap, json['status']),
      capacity: (json['capacity'] as num).toInt(),
      currentOrderId: json['currentOrderId'] as String?,
      currentOrderNumber: json['currentOrderNumber'] as String?,
      currentOrderTotal: (json['currentOrderTotal'] as num?)?.toDouble(),
      currentOrderItemCount: (json['currentOrderItemCount'] as num?)?.toInt(),
      customerName: json['customerName'] as String?,
      notes: json['notes'] as String?,
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
      reservationTime: json['reservationTime'] == null
          ? null
          : DateTime.parse(json['reservationTime'] as String),
      assignedWaiter: json['assignedWaiter'] as String?,
      assignedWaiterId: (json['assignedWaiterId'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TableImplToJson(_$TableImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'tableNumber': instance.tableNumber,
      'status': _$TableStatusEnumMap[instance.status]!,
      'capacity': instance.capacity,
      'currentOrderId': instance.currentOrderId,
      'currentOrderNumber': instance.currentOrderNumber,
      'currentOrderTotal': instance.currentOrderTotal,
      'currentOrderItemCount': instance.currentOrderItemCount,
      'customerName': instance.customerName,
      'notes': instance.notes,
      'lastActivity': instance.lastActivity?.toIso8601String(),
      'reservationTime': instance.reservationTime?.toIso8601String(),
      'assignedWaiter': instance.assignedWaiter,
      'assignedWaiterId': instance.assignedWaiterId,
      'metadata': instance.metadata,
    };

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupied: 'occupied',
  TableStatus.reserved: 'reserved',
  TableStatus.cleaning: 'cleaning',
  TableStatus.outOfService: 'out_of_service',
};
