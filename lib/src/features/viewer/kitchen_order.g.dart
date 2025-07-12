// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KitchenOrderItemImpl _$$KitchenOrderItemImplFromJson(
        Map<String, dynamic> json) =>
    _$KitchenOrderItemImpl(
      id: (json['id'] as num).toInt(),
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      status: json['status'] as String?,
      specialInstructions: json['specialInstructions'] as String?,
      modifications: (json['modifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preparationTime: (json['preparationTime'] as num?)?.toInt(),
      startTime: json['startTime'] as String?,
      readyTime: json['readyTime'] as String?,
      servedTime: json['servedTime'] as String?,
      assignedTo: json['assignedTo'] as String?,
      assignedToName: json['assignedToName'] as String?,
      station: json['station'] as String?,
      notes: json['notes'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$KitchenOrderItemImplToJson(
        _$KitchenOrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemName': instance.itemName,
      'quantity': instance.quantity,
      'status': instance.status,
      'specialInstructions': instance.specialInstructions,
      'modifications': instance.modifications,
      'allergens': instance.allergens,
      'preparationTime': instance.preparationTime,
      'startTime': instance.startTime,
      'readyTime': instance.readyTime,
      'servedTime': instance.servedTime,
      'assignedTo': instance.assignedTo,
      'assignedToName': instance.assignedToName,
      'station': instance.station,
      'notes': instance.notes,
      'allergies': instance.allergies,
      'dietaryRestrictions': instance.dietaryRestrictions,
    };

_$KitchenOrderImpl _$$KitchenOrderImplFromJson(Map<String, dynamic> json) =>
    _$KitchenOrderImpl(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      orderId: (json['orderId'] as num).toInt(),
      orderNumber: json['orderNumber'] as String,
      tableNumber: json['tableNumber'] as String?,
      customerName: json['customerName'] as String?,
      orderType: json['orderType'] as String?,
      priority: json['priority'] as String?,
      status: json['status'] as String?,
      estimatedPrepTime: (json['estimatedPrepTime'] as num?)?.toInt(),
      actualPrepTime: (json['actualPrepTime'] as num?)?.toInt(),
      startTime: json['startTime'] as String?,
      readyTime: json['readyTime'] as String?,
      servedTime: json['servedTime'] as String?,
      specialInstructions: json['specialInstructions'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map((e) => KitchenOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
      completedItems: (json['completedItems'] as num?)?.toInt(),
      assignedTo: (json['assignedTo'] as num?)?.toInt(),
      assignedToName: json['assignedToName'] as String?,
      station: json['station'] as String?,
      notes: json['notes'] as String?,
      chefId: (json['chefId'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$KitchenOrderImplToJson(_$KitchenOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'orderId': instance.orderId,
      'orderNumber': instance.orderNumber,
      'tableNumber': instance.tableNumber,
      'customerName': instance.customerName,
      'orderType': instance.orderType,
      'priority': instance.priority,
      'status': instance.status,
      'estimatedPrepTime': instance.estimatedPrepTime,
      'actualPrepTime': instance.actualPrepTime,
      'startTime': instance.startTime,
      'readyTime': instance.readyTime,
      'servedTime': instance.servedTime,
      'specialInstructions': instance.specialInstructions,
      'allergies': instance.allergies,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'items': instance.items,
      'totalItems': instance.totalItems,
      'completedItems': instance.completedItems,
      'assignedTo': instance.assignedTo,
      'assignedToName': instance.assignedToName,
      'station': instance.station,
      'notes': instance.notes,
      'chefId': instance.chefId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
