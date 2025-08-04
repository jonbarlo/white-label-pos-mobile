import 'package:freezed_annotation/freezed_annotation.dart';

part 'language.freezed.dart';
part 'language.g.dart';

@freezed
class Language with _$Language {
  const factory Language({
    required String code,
    required String name,
    required String nativeName,
    required bool isDefault,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
}

@freezed
class LanguageResponse with _$LanguageResponse {
  const factory LanguageResponse({
    required String currentLanguage,
    required List<Language> supportedLanguages,
  }) = _LanguageResponse;

  factory LanguageResponse.fromJson(Map<String, dynamic> json) => _$LanguageResponseFromJson(json);
}

// New model for the actual API response format
@freezed
class LanguagePreferenceResponse with _$LanguagePreferenceResponse {
  const factory LanguagePreferenceResponse({
    required String language,
    required List<String> supportedLanguages,
  }) = _LanguagePreferenceResponse;

  factory LanguagePreferenceResponse.fromJson(Map<String, dynamic> json) => _$LanguagePreferenceResponseFromJson(json);
}

@freezed
class LanguageUpdateRequest with _$LanguageUpdateRequest {
  const factory LanguageUpdateRequest({
    required String language,
  }) = _LanguageUpdateRequest;

  factory LanguageUpdateRequest.fromJson(Map<String, dynamic> json) => _$LanguageUpdateRequestFromJson(json);
} 
