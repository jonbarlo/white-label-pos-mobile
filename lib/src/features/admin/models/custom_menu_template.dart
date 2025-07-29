import 'package:json_annotation/json_annotation.dart';

part 'custom_menu_template.g.dart';

@JsonSerializable()
class CustomMenuTemplate {
  final int id;
  final int businessId;
  final String name;
  final String description;
  final String htmlContent;
  final String cssContent;
  final bool isActive;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomMenuTemplate({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.htmlContent,
    required this.cssContent,
    required this.isActive,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomMenuTemplate.fromJson(Map<String, dynamic> json) =>
      _$CustomMenuTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$CustomMenuTemplateToJson(this);

  CustomMenuTemplate copyWith({
    int? id,
    int? businessId,
    String? name,
    String? description,
    String? htmlContent,
    String? cssContent,
    bool? isActive,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomMenuTemplate(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      description: description ?? this.description,
      htmlContent: htmlContent ?? this.htmlContent,
      cssContent: cssContent ?? this.cssContent,
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}