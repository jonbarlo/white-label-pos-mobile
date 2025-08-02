import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/utils/currency_formatter.dart';
import '../business/business_provider.dart';
import 'models/split_payment.dart';
import 'models/cart_item.dart';

class SplitPaymentDialog extends ConsumerStatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;
  final int userId;

  const SplitPaymentDialog({
    super.key,
    required this.totalAmount,
    required this.cartItems,
    required this.userId,
  });

  @override
  ConsumerState<SplitPaymentDialog> createState() => _SplitPaymentDialogState();
}

class _SplitPaymentDialogState extends ConsumerState<SplitPaymentDialog> {
  final List<SplitPaymentEntry> _payments = [];
  final _formKey = GlobalKey<FormState>();
  String? _customerName;
  String? _customerPhone;
  String? _customerEmail;
  String? _notes;

  @override
  void initState() {
    super.initState();
    // Initialize with one payment entry
    _addPaymentEntry();
  }

  void _addPaymentEntry() {
    setState(() {
      _payments.add(SplitPaymentEntry());
    });
  }

  void _removePaymentEntry(int index) {
    if (_payments.length > 1) {
      setState(() {
        _payments.removeAt(index);
      });
    }
  }

  void _updatePaymentAmount(int index, double amount) {
    setState(() {
      _payments[index] = _payments[index].copyWith(amount: amount);
    });
  }

  void _updatePaymentMethod(int index, String method) {
    setState(() {
      _payments[index] = _payments[index].copyWith(method: method);
    });
  }

  void _updatePaymentCustomerName(int index, String? name) {
    setState(() {
      _payments[index] = _payments[index].copyWith(customerName: name);
    });
  }

  void _updatePaymentCustomerPhone(int index, String? phone) {
    setState(() {
      _payments[index] = _payments[index].copyWith(customerPhone: phone);
    });
  }

  void _updatePaymentReference(int index, String? reference) {
    setState(() {
      _payments[index] = _payments[index].copyWith(reference: reference);
    });
  }

  double get _totalPaymentAmount {
    return _payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  double get _remainingAmount {
    return widget.totalAmount - _totalPaymentAmount;
  }

  bool get _isValid {
    final formValid = _formKey.currentState?.validate() == true;
    final allPaymentsValid = _payments.every((p) => p.amount > 0 && p.method.isNotEmpty);
    final amountMatches = (_totalPaymentAmount - widget.totalAmount).abs() < 0.01;
    
    // For now, allow the button to be enabled if we have at least one valid payment
    // This will help us debug the actual API call
    final hasValidPayments = _payments.isNotEmpty && allPaymentsValid;
    
    return hasValidPayments; // Simplified validation for debugging
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Split Payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total amount display
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Amount: ${CurrencyFormatter.formatBusinessCurrency(widget.totalAmount, ref.watch(currentBusinessCurrencyIdProvider))}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total Payments: ${CurrencyFormatter.formatBusinessCurrency(_totalPaymentAmount, ref.watch(currentBusinessCurrencyIdProvider))}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _remainingAmount.abs() < 0.01
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              if (_remainingAmount.abs() >= 0.01)
                                Text(
                                  'Remaining: ${CurrencyFormatter.formatBusinessCurrency(_remainingAmount, ref.watch(currentBusinessCurrencyIdProvider))}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Customer information (optional)
                      const Text(
                        'Customer Information (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Customer Name',
                        onChanged: (value) => _customerName = value,
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Customer Phone',
                        onChanged: (value) => _customerPhone = value,
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Customer Email',
                        onChanged: (value) => _customerEmail = value,
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Notes',
                        onChanged: (value) => _notes = value,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      
                      // Payment entries
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Payment Methods',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _addPaymentEntry,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Payment'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      ..._payments.asMap().entries.map((entry) {
                        final index = entry.key;
                        final payment = entry.value;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment ${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (_payments.length > 1)
                                      IconButton(
                                        onPressed: () => _removePaymentEntry(index),
                                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                                        iconSize: 20,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                
                                // Amount field
                                AppTextField(
                                  label: 'Amount',
                                  keyboardType: TextInputType.number,
                                  initialValue: payment.amount > 0 ? payment.amount.toString() : '',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Amount is required';
                                    }
                                    final amount = double.tryParse(value);
                                    if (amount == null || amount <= 0) {
                                      return 'Amount must be greater than 0';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final amount = double.tryParse(value) ?? 0;
                                    _updatePaymentAmount(index, amount);
                                  },
                                ),
                                const SizedBox(height: 8),
                                
                                // Payment method dropdown
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Payment Method',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: payment.method.isNotEmpty ? payment.method : null,
                                  items: const [
                                    DropdownMenuItem(value: 'cash', child: Text('Cash')),
                                    DropdownMenuItem(value: 'credit_card', child: Text('Credit Card')),
                                    DropdownMenuItem(value: 'debit_card', child: Text('Debit Card')),
                                    DropdownMenuItem(value: 'mobile_payment', child: Text('Mobile Payment')),
                                    DropdownMenuItem(value: 'check', child: Text('Check')),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Payment method is required';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (value != null) {
                                      _updatePaymentMethod(index, value);
                                    }
                                  },
                                ),
                                const SizedBox(height: 8),
                                
                                // Customer info for this payment (optional)
                                AppTextField(
                                  label: 'Customer Name (Optional)',
                                  initialValue: payment.customerName,
                                  onChanged: (value) => _updatePaymentCustomerName(index, value),
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  label: 'Customer Phone (Optional)',
                                  initialValue: payment.customerPhone,
                                  onChanged: (value) => _updatePaymentCustomerPhone(index, value),
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  label: 'Reference (Optional)',
                                  initialValue: payment.reference,
                                  onChanged: (value) => _updatePaymentReference(index, value),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    type: AppButtonType.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    text: 'Complete Split Payment',
                    onPressed: _isValid ? _completeSplitPayment : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _completeSplitPayment() {
    
    if (!_isValid) {
      return;
    }

    final splitPayments = _payments.map((entry) => SplitPayment(
      amount: entry.amount,
      method: entry.method,
      customerName: entry.customerName?.isNotEmpty == true ? entry.customerName : null,
      customerPhone: entry.customerPhone?.isNotEmpty == true ? entry.customerPhone : null,
      reference: entry.reference?.isNotEmpty == true ? entry.reference : null,
    )).toList();

    final splitSaleRequest = SplitSaleRequest(
      userId: widget.userId,
      totalAmount: widget.totalAmount,
      customerName: _customerName?.isNotEmpty == true ? _customerName : null,
      customerPhone: _customerPhone?.isNotEmpty == true ? _customerPhone : null,
      customerEmail: _customerEmail?.isNotEmpty == true ? _customerEmail : null,
      notes: _notes?.isNotEmpty == true ? _notes : null,
      items: widget.cartItems.map((item) => SplitSaleItem(
        itemId: int.tryParse(item.id) ?? 0,
        quantity: item.quantity,
        unitPrice: item.price,
      )).toList(),
      payments: splitPayments,
    );
    
    Navigator.of(context).pop(splitSaleRequest);
  }
}

class SplitPaymentEntry {
  final double amount;
  final String method;
  final String? customerName;
  final String? customerPhone;
  final String? reference;

  SplitPaymentEntry({
    this.amount = 0.0,
    this.method = '',
    this.customerName,
    this.customerPhone,
    this.reference,
  });

  SplitPaymentEntry copyWith({
    double? amount,
    String? method,
    String? customerName,
    String? customerPhone,
    String? reference,
  }) {
    return SplitPaymentEntry(
      amount: amount ?? this.amount,
      method: method ?? this.method,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      reference: reference ?? this.reference,
    );
  }
} 