import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for monitoring and optimizing app performance
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, DateTime> _startTimes = {};
  final Map<String, List<Duration>> _measurements = {};

  /// Start timing an operation
  void startTimer(String operationName) {
    _startTimes[operationName] = DateTime.now();
  }

  /// End timing an operation and record the duration
  void endTimer(String operationName) {
    final startTime = _startTimes[operationName];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _measurements.putIfAbsent(operationName, () => []).add(duration);
      _startTimes.remove(operationName);
    }
  }

  /// Get average duration for an operation
  Duration getAverageDuration(String operationName) {
    final measurements = _measurements[operationName];
    if (measurements == null || measurements.isEmpty) {
      return Duration.zero;
    }
    
    final totalMicroseconds = measurements
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b);
    
    return Duration(microseconds: totalMicroseconds ~/ measurements.length);
  }

  /// Get all performance measurements
  Map<String, List<Duration>> getAllMeasurements() {
    return Map.unmodifiable(_measurements);
  }

  /// Clear all measurements
  void clearMeasurements() {
    _measurements.clear();
    _startTimes.clear();
  }

  /// Monitor widget build performance
  void monitorWidgetBuild(String widgetName, VoidCallback buildCallback) {
    startTimer('widget_build_$widgetName');
    buildCallback();
    endTimer('widget_build_$widgetName');
  }

  /// Monitor async operation performance
  Future<T> monitorAsyncOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    startTimer(operationName);
    try {
      final result = await operation();
      return result;
    } finally {
      endTimer(operationName);
    }
  }

  /// Check if performance is within acceptable limits
  bool isPerformanceAcceptable(String operationName, Duration threshold) {
    final average = getAverageDuration(operationName);
    return average <= threshold;
  }

  /// Get performance report
  Map<String, dynamic> getPerformanceReport() {
    final report = <String, dynamic>{};
    
    for (final entry in _measurements.entries) {
      final operationName = entry.key;
      final measurements = entry.value;
      
      if (measurements.isNotEmpty) {
        final totalMicroseconds = measurements
            .map((d) => d.inMicroseconds)
            .reduce((a, b) => a + b);
        
        final average = totalMicroseconds ~/ measurements.length;
        final min = measurements
            .map((d) => d.inMicroseconds)
            .reduce((a, b) => a < b ? a : b);
        final max = measurements
            .map((d) => d.inMicroseconds)
            .reduce((a, b) => a > b ? a : b);
        
        report[operationName] = {
          'count': measurements.length,
          'average_ms': average / 1000,
          'min_ms': min / 1000,
          'max_ms': max / 1000,
          'total_ms': totalMicroseconds / 1000,
        };
      }
    }
    
    return report;
  }

  /// Monitor memory usage
  Map<String, dynamic> getMemoryUsage() {
    // This would integrate with actual memory monitoring
    // For now, return placeholder data
    return {
      'heap_size': 'Unknown',
      'heap_used': 'Unknown',
      'heap_free': 'Unknown',
    };
  }

  /// Monitor frame rate
  void monitorFrameRate(VoidCallback callback) {
    startTimer('frame_rate');
    callback();
    endTimer('frame_rate');
  }

  /// Check for memory leaks
  bool checkForMemoryLeaks() {
    // This would implement actual memory leak detection
    // For now, return false (no leaks detected)
    return false;
  }

  /// Optimize performance based on current measurements
  void optimizePerformance() {
    // This would implement performance optimization strategies
    // For now, just keep all measurements
    for (final entry in _measurements.entries) {
      // Keep all measurements for now
      // In the future, we could implement cleanup logic here
    }
  }

  /// Get performance recommendations
  List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    final report = getPerformanceReport();
    
    for (final entry in report.entries) {
      final operationName = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final averageMs = data['average_ms'] as double;
      
      if (averageMs > 100) {
        recommendations.add(
          'Consider optimizing $operationName (${averageMs.toStringAsFixed(2)}ms average)',
        );
      }
    }
    
    return recommendations;
  }
}

/// Provider for PerformanceService
final performanceServiceProvider = Provider<PerformanceService>((ref) {
  return PerformanceService();
});

/// Provider for performance measurements
final performanceMeasurementsProvider = Provider<Map<String, List<Duration>>>((ref) {
  final service = ref.watch(performanceServiceProvider);
  return service.getAllMeasurements();
});

/// Provider for performance report
final performanceReportProvider = Provider<Map<String, dynamic>>((ref) {
  final service = ref.watch(performanceServiceProvider);
  return service.getPerformanceReport();
});

/// Provider for performance recommendations
final performanceRecommendationsProvider = Provider<List<String>>((ref) {
  final service = ref.watch(performanceServiceProvider);
  return service.getPerformanceRecommendations();
}); 