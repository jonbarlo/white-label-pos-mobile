import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int id;
  final int businessId;
  final String name;
  final String? description;
  final int displayOrder;
  final bool isActive;
  final String? imageUrl;
  final String? colorCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.businessId,
    required this.name,
    this.description,
    required this.displayOrder,
    required this.isActive,
    this.imageUrl,
    this.colorCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
} 