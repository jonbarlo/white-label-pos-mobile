// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String?,
      partySize: (json['partySize'] as num).toInt(),
      reservationDate: json['reservationDate'] as String,
      reservationTime: json['reservationTime'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'partySize': instance.partySize,
      'reservationDate': instance.reservationDate,
      'reservationTime': instance.reservationTime,
      'notes': instance.notes,
    };

FloorPlan _$FloorPlanFromJson(Map<String, dynamic> json) => FloorPlan(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      backgroundImage: json['backgroundImage'] as String?,
      isActive: json['isActive'] as bool,
      tableCount: (json['tableCount'] as num?)?.toInt(),
      tables: (json['tables'] as List<dynamic>?)
          ?.map((e) => TablePosition.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FloorPlanToJson(FloorPlan instance) => <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'width': instance.width,
      'height': instance.height,
      'backgroundImage': instance.backgroundImage,
      'isActive': instance.isActive,
      'tableCount': instance.tableCount,
      'tables': instance.tables,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

TablePosition _$TablePositionFromJson(Map<String, dynamic> json) =>
    TablePosition(
      id: (json['id'] as num).toInt(),
      tableId: (json['tableId'] as num).toInt(),
      tableNumber: json['tableNumber'] as String,
      tableCapacity: (json['tableCapacity'] as num).toInt(),
      tableStatus: json['tableStatus'] as String,
      tableSection: json['tableSection'] as String,
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      rotation: (json['rotation'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      reservation: json['reservation'] == null
          ? null
          : Reservation.fromJson(json['reservation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TablePositionToJson(TablePosition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableId': instance.tableId,
      'tableNumber': instance.tableNumber,
      'tableCapacity': instance.tableCapacity,
      'tableStatus': instance.tableStatus,
      'tableSection': instance.tableSection,
      'x': instance.x,
      'y': instance.y,
      'rotation': instance.rotation,
      'width': instance.width,
      'height': instance.height,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'reservation': instance.reservation,
    };
