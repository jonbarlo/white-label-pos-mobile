import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'floor_plan_provider.dart' as fp;
import 'models/floor_plan.dart';

/// Progressive loading provider that shows data as soon as it's available
class ProgressiveFloorPlanNotifier extends StateNotifier<AsyncValue<List<FloorPlan>>> {
  ProgressiveFloorPlanNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadData();
  }

  final Ref ref;
  Timer? _autoRefreshTimer;
  int _totalFloorPlans = 0;
  int _loadedFloorPlans = 0;

  Future<void> _loadData() async {
    final authState = ref.read(authNotifierProvider);
    
    if (authState.status != AuthStatus.authenticated) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      // Start with loading state
      state = const AsyncValue.loading();
      
      // First, get the list of floor plans (without tables)
      final basicFloorPlansResult = await ref.read(fp.floorPlansProvider.future);
      
      if (!basicFloorPlansResult.isSuccess) {
        state = AsyncValue.error(basicFloorPlansResult.errorMessage ?? 'Failed to load floor plans', StackTrace.current);
        return;
      }

      final basicFloorPlans = basicFloorPlansResult.data;
      _totalFloorPlans = basicFloorPlans.length;
      _loadedFloorPlans = 0;

      if (_totalFloorPlans == 0) {
        state = const AsyncValue.data([]);
        return;
      }

      // Load floor plans progressively with tables
      final loadedFloorPlans = <FloorPlan>[];
      
      for (int i = 0; i < basicFloorPlans.length; i++) {
        try {
          final floorPlan = basicFloorPlans[i];
          
          // Set loading count to current card being loaded (1-based)
          _loadedFloorPlans = i + 1;
          
          // Load this floor plan with tables
          final detailedFloorPlanResult = await ref.read(fp.floorPlanWithTablesProvider(floorPlan.id).future);
          
          if (detailedFloorPlanResult.isSuccess) {
            loadedFloorPlans.add(detailedFloorPlanResult.data);
          } else {
            // If detailed loading fails, add the basic floor plan
            loadedFloorPlans.add(floorPlan);
          }
          
          // Update state with current progress
          state = AsyncValue.data(loadedFloorPlans);
          
          // Small delay to make the progressive loading visible
          await Future.delayed(const Duration(milliseconds: 200));
          
        } catch (e) {
          // If individual floor plan fails, add the basic one and continue
          loadedFloorPlans.add(basicFloorPlans[i]);
          state = AsyncValue.data(loadedFloorPlans);
        }
      }
      
      // Start auto-refresh
      _startAutoRefresh();
      
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        refresh();
      }
    });
  }

  Future<void> refresh() async {
    await _loadData();
  }

  /// Get current loading progress
  int get totalFloorPlans => _totalFloorPlans;
  int get loadedFloorPlans => _loadedFloorPlans;
  bool get isFullyLoaded => _loadedFloorPlans >= _totalFloorPlans;

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}

final progressiveFloorPlanNotifierProvider = StateNotifierProvider<ProgressiveFloorPlanNotifier, AsyncValue<List<FloorPlan>>>(
  (ref) => ProgressiveFloorPlanNotifier(ref),
); 