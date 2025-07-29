import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pdf_menu_repository.dart';
import 'models/custom_menu_template.dart';

class PdfMenuNotifier extends StateNotifier<AsyncValue<List<Map<String, String>>>> {
  final PdfMenuRepository _repository;

  PdfMenuNotifier(this._repository) : super(const AsyncValue.loading());

  /// Load available templates
  Future<void> loadTemplates() async {
    state = const AsyncValue.loading();
    try {
      final templates = await _repository.getTemplates();
      state = AsyncValue.data(templates);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Get custom templates for a business
  Future<List<CustomMenuTemplate>> getCustomTemplates(int businessId) async {
    try {
      return await _repository.getCustomTemplates(businessId);
    } catch (error) {
      rethrow;
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
      return await _repository.createCustomTemplate(
        businessId: businessId,
        name: name,
        description: description,
        htmlContent: htmlContent,
        cssContent: cssContent,
        isActive: isActive,
        isDefault: isDefault,
      );
    } catch (error) {
      rethrow;
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
      return await _repository.updateCustomTemplate(
        businessId: businessId,
        templateId: templateId,
        name: name,
        description: description,
        htmlContent: htmlContent,
        cssContent: cssContent,
        isActive: isActive,
        isDefault: isDefault,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Delete a custom template
  Future<void> deleteCustomTemplate({
    required int businessId,
    required int templateId,
  }) async {
    try {
      await _repository.deleteCustomTemplate(
        businessId: businessId,
        templateId: templateId,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Get menu preview for a business
  Future<Map<String, dynamic>> getMenuPreview(int businessId) async {
    try {
      return await _repository.getMenuPreview(businessId);
    } catch (error) {
      rethrow;
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
      return await _repository.generatePdf(
        businessId: businessId,
        template: template,
        includePrices: includePrices,
        includeDescriptions: includeDescriptions,
        includeAllergens: includeAllergens,
        includeCalories: includeCalories,
        includeItemImages: includeItemImages,
        includeBusinessLogo: includeBusinessLogo,
        orientation: orientation,
        fontSize: fontSize,
        colorScheme: colorScheme,
        categoryLayout: categoryLayout,
        categoryBackgroundColor: categoryBackgroundColor,
        maxItemsPerPage: maxItemsPerPage,
      );
    } catch (error) {
      rethrow;
    }
  }
}

// Provider for PDF menu notifier
final pdfMenuProvider = StateNotifierProvider<PdfMenuNotifier, AsyncValue<List<Map<String, String>>>>((ref) {
  final repository = ref.watch(pdfMenuRepositoryProvider);
  return PdfMenuNotifier(repository);
});