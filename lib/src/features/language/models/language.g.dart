// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageImpl _$$LanguageImplFromJson(Map<String, dynamic> json) =>
    _$LanguageImpl(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$$LanguageImplToJson(_$LanguageImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'nativeName': instance.nativeName,
      'isDefault': instance.isDefault,
    };

_$LanguageResponseImpl _$$LanguageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguageResponseImpl(
      currentLanguage: json['currentLanguage'] as String,
      supportedLanguages: (json['supportedLanguages'] as List<dynamic>)
          .map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LanguageResponseImplToJson(
        _$LanguageResponseImpl instance) =>
    <String, dynamic>{
      'currentLanguage': instance.currentLanguage,
      'supportedLanguages': instance.supportedLanguages,
    };

_$LanguagePreferenceResponseImpl _$$LanguagePreferenceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguagePreferenceResponseImpl(
      language: json['language'] as String,
      supportedLanguages: (json['supportedLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$LanguagePreferenceResponseImplToJson(
        _$LanguagePreferenceResponseImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'supportedLanguages': instance.supportedLanguages,
    };

_$LanguageUpdateRequestImpl _$$LanguageUpdateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguageUpdateRequestImpl(
      language: json['language'] as String,
    );

Map<String, dynamic> _$$LanguageUpdateRequestImplToJson(
        _$LanguageUpdateRequestImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
    };
