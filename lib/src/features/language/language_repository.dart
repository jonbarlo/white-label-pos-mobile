import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'models/language.dart';

abstract class LanguageRepository {
  /// Get user's current language and supported languages
  Future<Result<LanguageResponse>> getLanguage();
  
  /// Update user's language preference
  Future<Result<void>> updateLanguage(String languageCode);
} 
