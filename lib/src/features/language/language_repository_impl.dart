import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'language_repository.dart';
import 'models/language.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final Dio _dio;

  LanguageRepositoryImpl(this._dio);

  @override
  Future<Result<LanguageResponse>> getLanguage() async {
    try {
      print('🌐 Fetching language preferences from backend...');
      final response = await _dio.get('/language/preference');
      
      if (response.statusCode == 200) {
        print('🌐 Language response received: ${response.data}');
        
        // Parse the actual API response format
        final preferenceResponse = LanguagePreferenceResponse.fromJson(response.data);
        
        // Convert to the expected LanguageResponse format
        final languageResponse = LanguageResponse(
          currentLanguage: preferenceResponse.language,
          supportedLanguages: _buildLanguageList(preferenceResponse.supportedLanguages),
        );
        
        print('🌐 Parsed language response: ${languageResponse.currentLanguage}');
        return Result.success(languageResponse);
      } else {
        print('🌐 Language request failed with status: ${response.statusCode}');
        return Result.failure('Failed to get language settings: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('🌐 Language request error: ${e.message}');
      return Result.failure(e.message ?? 'Network error');
    } catch (e) {
      print('🌐 Unexpected language error: $e');
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<void>> updateLanguage(String languageCode) async {
    try {
      print('🌐 Updating language to: $languageCode');
      final response = await _dio.put(
        '/language/preference',
        data: {
          'language': languageCode,
        },
      );
      
      if (response.statusCode == 200) {
        print('🌐 Language updated successfully');
        return Result.success(null);
      } else {
        print('🌐 Language update failed with status: ${response.statusCode}');
        return Result.failure('Failed to update language: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('🌐 Language update error: ${e.message}');
      return Result.failure(e.message ?? 'Network error');
    } catch (e) {
      print('🌐 Unexpected language update error: $e');
      return Result.failure('Unexpected error: $e');
    }
  }

  // Helper method to convert language codes to Language objects
  List<Language> _buildLanguageList(List<String> languageCodes) {
    return languageCodes.map((code) {
      switch (code) {
        case 'en-US':
          return const Language(
            code: 'en-US',
            name: 'English',
            nativeName: 'English',
            isDefault: false,
          );
        case 'es-CR':
          return const Language(
            code: 'es-CR',
            name: 'Spanish',
            nativeName: 'Español',
            isDefault: true,
          );
        default:
          return Language(
            code: code,
            name: code,
            nativeName: code,
            isDefault: false,
          );
      }
    }).toList();
  }

  // Method to test language functionality
  Future<Result<void>> testLanguageSystem() async {
    try {
      print('🌐 Testing language system...');
      
      // Test getting current language
      final getResult = await getLanguage();
      if (getResult.isSuccess) {
        print('✅ Language retrieval test passed');
      } else {
        print('❌ Language retrieval test failed: ${getResult.errorMessage}');
        return Result.failure('Language retrieval test failed');
      }
      
      // Test updating language
      final updateResult = await updateLanguage('es-CR');
      if (updateResult.isSuccess) {
        print('✅ Language update test passed');
      } else {
        print('❌ Language update test failed: ${updateResult.errorMessage}');
        return Result.failure('Language update test failed');
      }
      
      print('✅ All language tests passed');
      return Result.success(null);
    } catch (e) {
      print('❌ Language test error: $e');
      return Result.failure('Language test error: $e');
    }
  }
} 
