import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';

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
    String? orientation,
    String? fontSize,
    String? colorScheme,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      
      if (template != null) requestBody['template'] = template;
      if (includePrices != null) requestBody['includePrices'] = includePrices;
      if (includeDescriptions != null) requestBody['includeDescriptions'] = includeDescriptions;
      if (includeAllergens != null) requestBody['includeAllergens'] = includeAllergens;
      if (includeCalories != null) requestBody['includeCalories'] = includeCalories;
      if (orientation != null) requestBody['orientation'] = orientation;
      if (fontSize != null) requestBody['fontSize'] = fontSize;
      if (colorScheme != null) requestBody['colorScheme'] = colorScheme;

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