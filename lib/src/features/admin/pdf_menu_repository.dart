import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import 'models/custom_menu_template.dart';

class PdfMenuRepository {
  final Dio _dio;

  PdfMenuRepository(this._dio);

  /// Get available PDF templates
  Future<List<Map<String, String>>> getTemplates() async {
    try {
      final response = await _dio.get('/menu/pdf/templates');
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((template) => {
          'id': template['id'] as String,
          'name': template['name'] as String,
          'description': template['description'] as String,
        }).toList();
      } else {
        throw Exception('Failed to load templates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load templates: $e');
    }
  }

  /// Get custom templates for a business
  Future<List<CustomMenuTemplate>> getCustomTemplates(int businessId) async {
    try {
      final response = await _dio.get('/menu/templates/$businessId/custom');
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((template) => CustomMenuTemplate.fromJson(template)).toList();
      } else {
        throw Exception('Failed to load custom templates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load custom templates: $e');
    }
  }

  /// Create a custom template
  Future<CustomMenuTemplate> createCustomTemplate({
    required int businessId,
    required String name,
    required String description,
    required String htmlContent,
    required String cssContent,
    bool isActive = true,
    bool isDefault = false,
  }) async {
    try {
      final response = await _dio.post(
        '/menu/templates/$businessId/custom',
        data: {
          'name': name,
          'description': description,
          'htmlContent': htmlContent,
          'cssContent': cssContent,
          'isActive': isActive,
          'isDefault': isDefault,
        },
      );
      
      if (response.statusCode == 201) {
        return CustomMenuTemplate.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create custom template: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create custom template: $e');
    }
  }

  /// Update a custom template
  Future<CustomMenuTemplate> updateCustomTemplate({
    required int businessId,
    required int templateId,
    String? name,
    String? description,
    String? htmlContent,
    String? cssContent,
    bool? isActive,
    bool? isDefault,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (htmlContent != null) data['htmlContent'] = htmlContent;
      if (cssContent != null) data['cssContent'] = cssContent;
      if (isActive != null) data['isActive'] = isActive;
      if (isDefault != null) data['isDefault'] = isDefault;

      final response = await _dio.put(
        '/menu/templates/$businessId/custom/$templateId',
        data: data,
      );
      
      if (response.statusCode == 200) {
        return CustomMenuTemplate.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update custom template: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update custom template: $e');
    }
  }

  /// Delete a custom template
  Future<void> deleteCustomTemplate({
    required int businessId,
    required int templateId,
  }) async {
    try {
      final response = await _dio.delete('/menu/templates/$businessId/custom/$templateId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete custom template: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete custom template: $e');
    }
  }

  /// Get menu preview data for a business
  Future<Map<String, dynamic>> getMenuPreview(int businessId) async {
    try {
      final response = await _dio.get('/menu/pdf/$businessId/preview');
      
      if (response.statusCode == 200) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load menu preview: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load menu preview: $e');
    }
  }

  /// Generate PDF menu
  Future<Uint8List> generatePdf({
    required int businessId,
    String? template,
    bool? includePrices,
    bool? includeDescriptions,
    bool? includeAllergens,
    bool? includeCalories,
    bool? includeItemImages, // New parameter for menu item images
    bool? includeBusinessLogo, // New parameter for business logo
    String? orientation,
    String? fontSize,
    String? colorScheme,
    // New category layout parameters
    String? categoryLayout,
    String? categoryBackgroundColor,
    int? maxItemsPerPage,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      
      if (template != null) requestBody['template'] = template;
      if (includePrices != null) requestBody['includePrices'] = includePrices;
      if (includeDescriptions != null) requestBody['includeDescriptions'] = includeDescriptions;
      if (includeAllergens != null) requestBody['includeAllergens'] = includeAllergens;
      if (includeCalories != null) requestBody['includeCalories'] = includeCalories;
      if (includeItemImages != null) requestBody['includeItemImages'] = includeItemImages;
      if (includeBusinessLogo != null) requestBody['includeBusinessLogo'] = includeBusinessLogo;
      if (orientation != null) requestBody['orientation'] = orientation;
      if (fontSize != null) requestBody['fontSize'] = fontSize;
      if (colorScheme != null) requestBody['colorScheme'] = colorScheme;
      // New category layout parameters
      if (categoryLayout != null) requestBody['categoryLayout'] = categoryLayout;
      if (categoryBackgroundColor != null) requestBody['categoryBackgroundColor'] = categoryBackgroundColor;
      if (maxItemsPerPage != null) requestBody['maxItemsPerPage'] = maxItemsPerPage;

      final response = await _dio.post(
        '/menu/pdf/$businessId/pdf',
        data: requestBody.isNotEmpty ? requestBody : null,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Accept': 'application/pdf',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('Failed to generate PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }
}

// Provider for PDF menu repository
final pdfMenuRepositoryProvider = Provider<PdfMenuRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PdfMenuRepository(dio);
});