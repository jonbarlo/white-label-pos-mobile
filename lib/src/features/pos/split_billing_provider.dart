import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/cart_item.dart';
import 'models/split_payment.dart';

class Split {
  final int id;
  final List<CartItem> items;
  final double subtotal;
  final double paid;
  final List<SplitPayment> payments;

  Split({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.paid,
    required this.payments,
  });

  Split copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? paid,
    List<SplitPayment>? payments,
  }) {
    return Split(
      id: id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      paid: paid ?? this.paid,
      payments: payments ?? this.payments,
    );
  }
}

class SplitBillingState {
  final List<Split> splits;
  final List<CartItem> unassignedItems;

  const SplitBillingState({
    this.splits = const [],
    this.unassignedItems = const [],
  });

  SplitBillingState copyWith({
    List<Split>? splits,
    List<CartItem>? unassignedItems,
  }) {
    return SplitBillingState(
      splits: splits ?? this.splits,
      unassignedItems: unassignedItems ?? this.unassignedItems,
    );
  }
}

class SplitBillingNotifier extends StateNotifier<SplitBillingState> {
  SplitBillingNotifier(List<CartItem> initialItems)
      : super(SplitBillingState(unassignedItems: initialItems));

  void addSplit() {
    final newId = (state.splits.isEmpty ? 1 : state.splits.last.id + 1);
    state = state.copyWith(
      splits: [...state.splits, Split(id: newId, items: [], subtotal: 0, paid: 0, payments: [])],
    );
  }

  void removeSplit(int splitId) {
    state = state.copyWith(
      splits: state.splits.where((s) => s.id != splitId).toList(),
    );
  }

  void assignItemToSplit(CartItem item, int splitId) {
    final splits = state.splits.map((split) {
      if (split.id == splitId) {
        return split.copyWith(items: [...split.items, item], subtotal: split.subtotal + item.total);
      }
      return split;
    }).toList();
    final unassigned = state.unassignedItems.where((i) => i.id != item.id).toList();
    state = state.copyWith(splits: splits, unassignedItems: unassigned);
  }

  void unassignItemFromSplit(CartItem item, int splitId) {
    final splits = state.splits.map((split) {
      if (split.id == splitId) {
        return split.copyWith(
          items: split.items.where((i) => i.id != item.id).toList(),
          subtotal: split.subtotal - item.total,
        );
      }
      return split;
    }).toList();
    state = state.copyWith(
      splits: splits,
      unassignedItems: [...state.unassignedItems, item],
    );
  }

  void updatePayment(int splitId, SplitPayment payment) {
    final splits = state.splits.map((split) {
      if (split.id == splitId) {
        final newPaid = split.paid + payment.amount;
        return split.copyWith(
          payments: [...split.payments, payment],
          paid: newPaid,
        );
      }
      return split;
    }).toList();
    state = state.copyWith(splits: splits);
  }
}

final splitBillingProvider = StateNotifierProvider.autoDispose.family<SplitBillingNotifier, SplitBillingState, List<CartItem>>(
  (ref, initialItems) => SplitBillingNotifier(initialItems),
); 