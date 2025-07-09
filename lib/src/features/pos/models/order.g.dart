// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      customerId: (json['customerId'] as num?)?.toInt(),
      tableId: (json['tableId'] as num?)?.toInt(),
      orderNumber: json['orderNumber'] as String,
      type: $enumDecode(_$OrderTypeEnumMap, json['type']),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
      estimatedReadyTime: json['estimatedReadyTime'] == null
          ? null
          : DateTime.parse(json['estimatedReadyTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'customerId': instance.customerId,
      'tableId': instance.tableId,
      'orderNumber': instance.orderNumber,
      'type': _$OrderTypeEnumMap[instance.type]!,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'discount': instance.discount,
      'total': instance.total,
      'notes': instance.notes,
      'estimatedReadyTime': instance.estimatedReadyTime?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$OrderTypeEnumMap = {
  OrderType.dine_in: 'dine_in',
  OrderType.takeaway: 'takeaway',
  OrderType.delivery: 'delivery',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.served: 'served',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};
