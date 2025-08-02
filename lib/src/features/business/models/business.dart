import 'package:json_annotation/json_annotation.dart';

part 'business.g.dart';

enum BusinessType {
  @JsonValue('restaurant')
  restaurant,
  @JsonValue('retail')
  retail,
  @JsonValue('service')
  service,
}

@JsonSerializable()
class Business {
  final int id;
  final String name;
  final String slug;
  final BusinessType? type;
  final String? description;
  final String? logo;
  final String? primaryColor;
  final String? secondaryColor;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;
  final double taxRate;
  final int currencyId;
  final String timezone;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Business({
    required this.id,
    required this.name,
    required this.slug,
    this.type,
    this.description,
    this.logo,
    this.primaryColor,
    this.secondaryColor,
    this.address,
    this.phone,
    this.email,
    this.website,
    required this.taxRate,
    required this.currencyId,
    required this.timezone,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Business copyWith({
    int? id,
    String? name,
    String? slug,
    BusinessType? type,
    String? description,
    String? logo,
    String? primaryColor,
    String? secondaryColor,
    String? address,
    String? phone,
    String? email,
    String? website,
    double? taxRate,
    int? currencyId,
    String? timezone,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      type: type ?? this.type,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      taxRate: taxRate ?? this.taxRate,
      currencyId: currencyId ?? this.currencyId,
      timezone: timezone ?? this.timezone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Business.fromJson(Map<String, dynamic> json) => _$BusinessFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Business &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          slug == other.slug;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ slug.hashCode;

  @override
  String toString() {
    return 'Business(id: $id, name: $name, slug: $slug, type: $type)';
  }
}

extension BusinessTypeExtension on BusinessType {
  String get displayName {
    switch (this) {
      case BusinessType.restaurant:
        return 'Restaurant';
      case BusinessType.retail:
        return 'Retail';
      case BusinessType.service:
        return 'Service';
    }
  }

  String get icon {
    switch (this) {
      case BusinessType.restaurant:
        return '🍽️';
      case BusinessType.retail:
        return '🛍️';
      case BusinessType.service:
        return '🔧';
    }
  }
} 