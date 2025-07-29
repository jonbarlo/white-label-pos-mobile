import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pdf_menu_repository.dart';

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
    String? orientation,
    String? fontSize,
    String? colorScheme,
  }) async {
    try {
      return await _repository.generatePdf(
        businessId: businessId,
        template: template,
        includePrices: includePrices,
        includeDescriptions: includeDescriptions,
        includeAllergens: includeAllergens,
        includeCalories: includeCalories,
        orientation: orientation,
        fontSize: fontSize,
        colorScheme: colorScheme,
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