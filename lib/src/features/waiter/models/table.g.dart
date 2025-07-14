// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableImpl _$$TableImplFromJson(Map<String, dynamic> json) => _$TableImpl(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      status: $enumDecode(_$TableStatusEnumMap, json['status']),
      capacity: (json['capacity'] as num).toInt(),
      location: json['location'] as String?,
      currentOrderId: (json['currentOrderId'] as num?)?.toInt(),
      serverId: (json['serverId'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
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
      'name': instance.name,
      'status': _$TableStatusEnumMap[instance.status]!,
      'capacity': instance.capacity,
      'location': instance.location,
      'currentOrderId': instance.currentOrderId,
      'serverId': instance.serverId,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
