import 'package:freezed_annotation/freezed_annotation.dart';

part 'kitchen_order.freezed.dart';
part 'kitchen_order.g.dart';

@freezed
class KitchenOrderItem with _$KitchenOrderItem {
  const factory KitchenOrderItem({
    required int id,
    required String itemName,
    required int quantity,
    String? status,
    String? specialInstructions,
    List<String>? modifications,
    List<String>? allergens,
    int? preparationTime,
    String? startTime,
    String? readyTime,
    String? servedTime,
    String? assignedTo,
    String? assignedToName,
    String? station,
    String? notes,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
  }) = _KitchenOrderItem;

  factory KitchenOrderItem.fromJson(Map<String, dynamic> json) => _$KitchenOrderItemFromJson(json);
}

@freezed
class KitchenOrder with _$KitchenOrder {
  const factory KitchenOrder({
    required int id,
    required int businessId,
    required int orderId,
    required String orderNumber,
    String? tableNumber,
    String? customerName,
    String? orderType,
    String? priority,
    String? status,
    int? estimatedPrepTime,
    int? actualPrepTime,
    String? startTime,
    String? readyTime,
    String? servedTime,
    String? specialInstructions,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
    required List<KitchenOrderItem> items,
    int? totalItems,
    int? completedItems,
    int? assignedTo,
    String? assignedToName,
    String? station,
    String? notes,
    int? chefId,
    String? createdAt,
    String? updatedAt,
  }) = _KitchenOrder;

  factory KitchenOrder.fromJson(Map<String, dynamic> json) => _$KitchenOrderFromJson(json);
} 