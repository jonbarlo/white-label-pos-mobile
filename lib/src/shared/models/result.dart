/// A Result type that can represent either success or failure
class Result<T> {
  final T? _data;
  final String? _error;
  final dynamic _errorObject;
  final bool _isSuccess;

  const Result._({
    required T? data,
    required String? error,
    required dynamic errorObject,
    required bool isSuccess,
  })  : _data = data,
        _error = error,
        _errorObject = errorObject,
        _isSuccess = isSuccess;

  /// Create a success result
  factory Result.success(T data) {
    return Result._(
      data: data,
      error: null,
      errorObject: null,
      isSuccess: true,
    );
  }

  /// Create a failure result
  factory Result.failure(String message, [dynamic error]) {
    return Result._(
      data: null,
      error: message,
      errorObject: error,
      isSuccess: false,
    );
  }

  /// Check if the result is successful
  bool get isSuccess => _isSuccess;

  /// Check if the result is a failure
  bool get isFailure => !_isSuccess;

  /// Get the data if successful, otherwise throw
  T get data {
    if (!isSuccess) {
      throw Exception(_error ?? 'No data available');
    }
    return _data as T;
  }

  /// Get the error message if failed, otherwise return null
  String? get errorMessage => _error;

  /// Get the error object if failed, otherwise return null
  dynamic get errorObject => _errorObject;

  /// Transform the data if successful
  Result<R> map<R>(R Function(T) transform) {
    if (isSuccess) {
      try {
        return Result.success(transform(data));
      } catch (e) {
        return Result.failure(e.toString(), e);
      }
    } else {
      return Result.failure(_error!, _errorObject);
    }
  }

  /// Transform the data if successful (async)
  Future<Result<R>> mapAsync<R>(Future<R> Function(T) transform) async {
    if (isSuccess) {
      try {
        final result = await transform(data);
        return Result.success(result);
      } catch (e) {
        return Result.failure(e.toString(), e);
      }
    } else {
      return Result.failure(_error!, _errorObject);
    }
  }

  /// Execute a function if successful
  Result<T> onSuccess(void Function(T) action) {
    if (isSuccess) {
      action(data);
    }
    return this;
  }

  /// Execute a function if failed
  Result<T> onFailure(void Function(String, dynamic) action) {
    if (isFailure) {
      action(_error!, _errorObject);
    }
    return this;
  }

  /// Get data or return a default value
  T getOrElse(T defaultValue) {
    return isSuccess ? data : defaultValue;
  }

  /// Get data or throw with custom message
  T getOrThrow([String? message]) {
    if (isSuccess) return data;
    throw Exception(message ?? _error ?? 'No data available');
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'Result.success(${_data.toString()})';
    } else {
      return 'Result.failure($_error)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Result<T> &&
        other._isSuccess == _isSuccess &&
        other._data == _data &&
        other._error == _error;
  }

  @override
  int get hashCode {
    return Object.hash(_isSuccess, _data, _error);
  }
} 