/// Generic API response wrapper
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: 200,
    );
  }

  factory ApiResponse.failure(String message, {
    Map<String, dynamic>? errors,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] as Map<String, dynamic>?,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': toJsonT(data as T),
      if (errors != null) 'errors': errors,
      if (statusCode != null) 'statusCode': statusCode,
    };
  }

  /// Check if the response is successful
  bool get isSuccess => success;

  /// Check if the response has errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  /// Get the first error message
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    return errors!.values.first.toString();
  }

  /// Get all error messages
  List<String> get allErrors {
    if (errors == null || errors!.isEmpty) return [];
    return errors!.values.map((e) => e.toString()).toList();
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data, errors: $errors)';
  }
} 