import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_flushbar/flushbar.dart';
import '../models/floor_plan.dart';
import '../../waiter/table_provider.dart' as waiter;

class ReservationDialog extends ConsumerStatefulWidget {
  final TablePosition table;

  const ReservationDialog({
    super.key,
    required this.table,
  });

  @override
  ConsumerState<ReservationDialog> createState() => _ReservationDialogState();
}

class _ReservationDialogState extends ConsumerState<ReservationDialog> {
  late TextEditingController customerNameController;
  late TextEditingController customerPhoneController;
  late TextEditingController partySizeController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController notesController;
  bool isCreatingReservation = false;

  @override
  void initState() {
    super.initState();
    customerNameController = TextEditingController();
    customerPhoneController = TextEditingController();
    partySizeController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerPhoneController.dispose();
    partySizeController.dispose();
    dateController.dispose();
    timeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text('Make Reservation - Table ${widget.table.tableNumber}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  hintText: 'Full name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: customerPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Contact number',
                ),
                keyboardType: TextInputType.phone,
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
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          // Format for display (MM/DD/YYYY)
                          dateController.text = '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
                          setDialogState(() {}); // Trigger UI refresh
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 20, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              dateController.text.isEmpty ? 'Select Date' : dateController.text,
                              style: TextStyle(
                                color: dateController.text.isEmpty ? Colors.grey.shade500 : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          // Format for display (HH:MM)
                          timeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                          setDialogState(() {}); // Trigger UI refresh
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 20, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Text(
                              timeController.text.isEmpty ? 'Select Time' : timeController.text,
                              style: TextStyle(
                                color: timeController.text.isEmpty ? Colors.grey.shade500 : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Special requests, etc.',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isCreatingReservation ? null : () => _createReservation(setDialogState),
            child: isCreatingReservation 
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Text('Creating...'),
                  ],
                )
              : const Text('Make Reservation'),
          ),
        ],
      ),
    );
  }

  Future<void> _createReservation(Function setDialogState) async {
    print('🔍 DEBUG: Make reservation button tapped for table ${widget.table.tableNumber}');
    
    // Validate inputs
    final customerName = customerNameController.text.trim();
    final customerPhone = customerPhoneController.text.trim();
    final partySize = int.tryParse(partySizeController.text.trim());
    final date = dateController.text.trim();
    final time = timeController.text.trim();
    
    // Convert display format to API format
    final apiDate = _convertDateToApiFormat(date);
    final apiTime = _convertTimeToApiFormat(time);
    
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

    if (date.isEmpty) {
      Flushbar(
        message: 'Please select a date',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
      return;
    }

    if (time.isEmpty) {
      Flushbar(
        message: 'Please select a time',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
      return;
    }

    // Set loading state
    setDialogState(() {
      isCreatingReservation = true;
    });
    
    try {
      // Create the reservation using the provider
      await ref.read(waiter.createReservationProvider((
        widget.table.tableId,
        customerName,
        customerPhone,
        partySize,
        apiDate,
        apiTime,
        notesController.text.trim(),
      )).future);
      
      print('🔍 DEBUG: Reservation successful for table ${widget.table.tableNumber}');

      // Close dialog
      Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Flushbar(
              message: 'Reservation made successfully for Table ${widget.table.tableNumber}!',
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check_circle, color: Colors.white),
            ).show(context);
          }
        });
      }
      
    } catch (e) {
      print('🔍 DEBUG: Reservation failed for table ${widget.table.tableNumber}: $e');
      
      // Reset loading state
      setDialogState(() {
        isCreatingReservation = false;
      });
      
      // Show error message
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Flushbar(
              message: 'Failed to make reservation: ${e.toString()}',
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.red,
              icon: const Icon(Icons.error, color: Colors.white),
            ).show(context);
          }
        });
      }
    }
  }
  
  // Convert MM/DD/YYYY to YYYY-MM-DD for API
  String _convertDateToApiFormat(String displayDate) {
    if (displayDate.isEmpty) return '';
    
    final parts = displayDate.split('/');
    if (parts.length == 3) {
      final month = parts[0];
      final day = parts[1];
      final year = parts[2];
      return '$year-$month-$day';
    }
    return displayDate;
  }
  
  // Convert HH:MM to HH:MM for API
  String _convertTimeToApiFormat(String displayTime) {
    if (displayTime.isEmpty) return '';
    
    // Ensure format is HH:MM
    final parts = displayTime.split(':');
    if (parts.length == 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return '$hour:$minute';
    }
    return displayTime;
  }
}

// Helper function to show the reservation dialog
void showReservationDialog(BuildContext context, TablePosition table) {
  showDialog(
    context: context,
    builder: (context) => ReservationDialog(table: table),
  );
} 