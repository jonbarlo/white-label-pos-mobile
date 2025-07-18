import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_flushbar/flushbar.dart';
import '../models/floor_plan.dart';
import '../../waiter/table_provider.dart' as waiter;

class SeatingDialog extends ConsumerStatefulWidget {
  final TablePosition table;

  const SeatingDialog({
    super.key,
    required this.table,
  });

  @override
  ConsumerState<SeatingDialog> createState() => _SeatingDialogState();
}

class _SeatingDialogState extends ConsumerState<SeatingDialog> {
  late TextEditingController customerNameController;
  late TextEditingController customerNotesController;
  late TextEditingController partySizeController;
  bool isSeatingCustomer = false;

  @override
  void initState() {
    super.initState();
    customerNameController = TextEditingController();
    customerNotesController = TextEditingController();
    partySizeController = TextEditingController();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerNotesController.dispose();
    partySizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text('Seat Customer - Table ${widget.table.tableNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                hintText: 'Enter customer name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: partySizeController,
              decoration: const InputDecoration(
                labelText: 'Party Size',
                hintText: 'Number of guests',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerNotesController,
              decoration: const InputDecoration(
                labelText: 'Special Instructions',
                hintText: 'Any special requests or notes',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isSeatingCustomer ? null : () => _seatCustomer(setDialogState),
            child: isSeatingCustomer 
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Text('Seating...'),
                  ],
                )
              : const Text('Seat Customer'),
          ),
        ],
      ),
    );
  }

  Future<void> _seatCustomer(Function setDialogState) async {
    print('🔍 DEBUG: Seat customer button tapped for table ${widget.table.tableNumber}');
    
    final customerName = customerNameController.text.trim();
    final partySize = int.tryParse(partySizeController.text.trim());
    final customerNotes = customerNotesController.text.trim();
    
    if (customerName.isEmpty) {
      Flushbar(
        message: 'Please enter a customer name',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
      return;
    }

    if (partySize == null || partySize < 1) {
      Flushbar(
        message: 'Please enter a valid party size',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
      return;
    }

    // Set loading state
    setDialogState(() {
      isSeatingCustomer = true;
    });
    
    try {
      // Seat the customer using the provider
      await ref.read(waiter.seatCustomerProvider((
        widget.table.tableId,
        customerName,
        partySize,
        customerNotes,
      )).future);
      
      print('🔍 DEBUG: Customer seated successfully for table ${widget.table.tableNumber}');

      // Close dialog
      Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Flushbar(
              message: 'Customer seated successfully at Table ${widget.table.tableNumber}!',
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check_circle, color: Colors.white),
            ).show(context);
          }
        });
      }
      
    } catch (e) {
      print('🔍 DEBUG: Seating failed for table ${widget.table.tableNumber}: $e');
      
      // Reset loading state
      setDialogState(() {
        isSeatingCustomer = false;
      });
      
      // Show error message
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Flushbar(
              message: 'Failed to seat customer: ${e.toString()}',
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.red,
              icon: const Icon(Icons.error, color: Colors.white),
            ).show(context);
          }
        });
      }
    }
  }
}

// Helper function to show the seating dialog
void showSeatingDialog(BuildContext context, TablePosition table) {
  showDialog(
    context: context,
    builder: (context) => SeatingDialog(table: table),
  );
} 