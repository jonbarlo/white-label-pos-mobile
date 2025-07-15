import 'package:flutter_test/flutter_test.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/split_payment.dart';

void main() {
  group('SplitPayment Models', () {
    test('SplitPayment should be created correctly', () {
      const payment = SplitPayment(
        amount: 50.0,
        method: 'credit_card',
        customerName: 'John Doe',
        customerPhone: '555-1234',
        reference: 'CC123456',
      );

      expect(payment.amount, 50.0);
      expect(payment.method, 'credit_card');
      expect(payment.customerName, 'John Doe');
      expect(payment.customerPhone, '555-1234');
      expect(payment.reference, 'CC123456');
    });

    test('SplitPayment should handle optional fields', () {
      const payment = SplitPayment(
        amount: 25.0,
        method: 'cash',
      );

      expect(payment.amount, 25.0);
      expect(payment.method, 'cash');
      expect(payment.customerName, null);
      expect(payment.customerPhone, null);
      expect(payment.reference, null);
    });

    test('SplitSaleRequest should be created correctly', () {
      final payments = [
        const SplitPayment(amount: 40.0, method: 'credit_card'),
        const SplitPayment(amount: 35.0, method: 'cash'),
        const SplitPayment(amount: 25.0, method: 'debit_card'),
      ];

      final request = SplitSaleRequest(
        userId: 1,
        totalAmount: 100.0,
        customerName: 'Group Order',
        customerPhone: '555-1234',
        customerEmail: 'group@example.com',
        notes: 'Split between 3 people',
        payments: payments,
      );

      expect(request.userId, 1);
      expect(request.totalAmount, 100.0);
      expect(request.customerName, 'Group Order');
      expect(request.customerPhone, '555-1234');
      expect(request.customerEmail, 'group@example.com');
      expect(request.notes, 'Split between 3 people');
      expect(request.payments.length, 3);
      expect(request.payments[0].amount, 40.0);
      expect(request.payments[1].amount, 35.0);
      expect(request.payments[2].amount, 25.0);
    });

    test('SplitSaleItem should be created correctly', () {
      const item = SplitSaleItem(
        itemId: 1,
        quantity: 2,
        unitPrice: 25.0,
      );

      expect(item.itemId, 1);
      expect(item.quantity, 2);
      expect(item.unitPrice, 25.0);
    });

    test('AddPaymentRequest should be created correctly', () {
      const request = AddPaymentRequest(
        amount: 25.0,
        method: 'cash',
        customerName: 'Alice Johnson',
        customerPhone: '555-4444',
        reference: 'CASH001',
      );

      expect(request.amount, 25.0);
      expect(request.method, 'cash');
      expect(request.customerName, 'Alice Johnson');
      expect(request.customerPhone, '555-4444');
      expect(request.reference, 'CASH001');
    });

    test('RefundRequest should be created correctly', () {
      const request = RefundRequest(
        paymentIndex: 0,
        refundAmount: 20.0,
        reason: 'Customer requested partial refund',
      );

      expect(request.paymentIndex, 0);
      expect(request.refundAmount, 20.0);
      expect(request.reason, 'Customer requested partial refund');
    });

    test('SplitBillingStats should be created correctly', () {
      const stats = SplitBillingStats(
        totalSplitSales: 15,
        totalAmount: 2500.0,
        averageSplitAmount: 166.67,
        averagePaymentsPerSale: 2.8,
      );

      expect(stats.totalSplitSales, 15);
      expect(stats.totalAmount, 2500.0);
      expect(stats.averageSplitAmount, 166.67);
      expect(stats.averagePaymentsPerSale, 2.8);
    });
  });

  group('SplitPayment JSON Serialization', () {
    test('SplitPayment should serialize to JSON correctly', () {
      const payment = SplitPayment(
        amount: 50.0,
        method: 'credit_card',
        customerName: 'John Doe',
        customerPhone: '555-1234',
        reference: 'CC123456',
      );

      final json = payment.toJson();
      
      expect(json['amount'], 50.0);
      expect(json['method'], 'credit_card');
      expect(json['customerName'], 'John Doe');
      expect(json['customerPhone'], '555-1234');
      expect(json['reference'], 'CC123456');
    });

    test('SplitPayment should deserialize from JSON correctly', () {
      final json = {
        'amount': 50.0,
        'method': 'credit_card',
        'customerName': 'John Doe',
        'customerPhone': '555-1234',
        'reference': 'CC123456',
      };

      final payment = SplitPayment.fromJson(json);
      
      expect(payment.amount, 50.0);
      expect(payment.method, 'credit_card');
      expect(payment.customerName, 'John Doe');
      expect(payment.customerPhone, '555-1234');
      expect(payment.reference, 'CC123456');
    });

    test('SplitSaleRequest should serialize to JSON correctly', () {
      final payments = [
        const SplitPayment(amount: 40.0, method: 'credit_card'),
        const SplitPayment(amount: 35.0, method: 'cash'),
        const SplitPayment(amount: 25.0, method: 'debit_card'),
      ];

      final request = SplitSaleRequest(
        userId: 1,
        totalAmount: 100.0,
        customerName: 'Group Order',
        customerPhone: '555-1234',
        customerEmail: 'group@example.com',
        notes: 'Split between 3 people',
        payments: payments,
      );

      final json = request.toJson();
      
      expect(json['userId'], 1);
      expect(json['totalAmount'], 100.0);
      expect(json['customerName'], 'Group Order');
      expect(json['customerPhone'], '555-1234');
      expect(json['customerEmail'], 'group@example.com');
      expect(json['notes'], 'Split between 3 people');
      expect(json['payments'], isA<List>());
      expect(json['payments'].length, 3);
    });
  });

  group('SplitPayment Business Logic', () {
    test('Payment amounts should sum to total amount', () {
      final payments = [
        const SplitPayment(amount: 40.0, method: 'credit_card'),
        const SplitPayment(amount: 35.0, method: 'cash'),
        const SplitPayment(amount: 25.0, method: 'debit_card'),
      ];

      final totalAmount = payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
      
      expect(totalAmount, 100.0);
    });

    test('SplitSaleRequest should validate payment total', () {
      final payments = [
        const SplitPayment(amount: 40.0, method: 'credit_card'),
        const SplitPayment(amount: 35.0, method: 'cash'),
        const SplitPayment(amount: 25.0, method: 'debit_card'),
      ];

      final request = SplitSaleRequest(
        userId: 1,
        totalAmount: 100.0,
        payments: payments,
      );

      final paymentTotal = request.payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
      final isValid = (paymentTotal - request.totalAmount).abs() < 0.01;
      
      expect(isValid, true);
    });
  });
} 