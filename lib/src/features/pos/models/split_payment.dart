import 'package:freezed_annotation/freezed_annotation.dart';

part 'split_payment.freezed.dart';
part 'split_payment.g.dart';

@freezed
class SplitPayment with _$SplitPayment {
  const factory SplitPayment({
    required double amount,
    required String method,
    String? customerName,
    String? customerPhone,
    String? reference,
    DateTime? paidAt,
  }) = _SplitPayment;

  factory SplitPayment.fromJson(Map<String, dynamic> json) =>
      _$SplitPaymentFromJson(json);
}

@freezed
class SplitSaleRequest with _$SplitSaleRequest {
  const factory SplitSaleRequest({
    required int userId,
    required double totalAmount,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? notes,
    List<SplitSaleItem>? items,
    required List<SplitPayment> payments,
  }) = _SplitSaleRequest;

  factory SplitSaleRequest.fromJson(Map<String, dynamic> json) =>
      _$SplitSaleRequestFromJson(json);
}

@freezed
class SplitSaleItem with _$SplitSaleItem {
  const factory SplitSaleItem({
    required int itemId,
    required int quantity,
    required double unitPrice,
  }) = _SplitSaleItem;

  factory SplitSaleItem.fromJson(Map<String, dynamic> json) =>
      _$SplitSaleItemFromJson(json);
}

@freezed
class SplitSaleResponse with _$SplitSaleResponse {
  const factory SplitSaleResponse({
    required String message,
    required SplitSale sale,
  }) = _SplitSaleResponse;

  factory SplitSaleResponse.fromJson(Map<String, dynamic> json) =>
      _$SplitSaleResponseFromJson(json);
}

@freezed
class SplitSale with _$SplitSale {
  const factory SplitSale({
    required int id,
    required double totalAmount,
    required String status,
    required List<SplitPayment> payments,
    required DateTime createdAt,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? notes,
    double? totalPaid,
    double? remainingAmount,
    DateTime? updatedAt,
  }) = _SplitSale;

  factory SplitSale.fromJson(Map<String, dynamic> json) =>
      _$SplitSaleFromJson(json);
}

@freezed
class AddPaymentRequest with _$AddPaymentRequest {
  const factory AddPaymentRequest({
    required double amount,
    required String method,
    String? customerName,
    String? customerPhone,
    String? reference,
  }) = _AddPaymentRequest;

  factory AddPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddPaymentRequestFromJson(json);
}

@freezed
class RefundRequest with _$RefundRequest {
  const factory RefundRequest({
    required int paymentIndex,
    required double refundAmount,
    String? reason,
  }) = _RefundRequest;

  factory RefundRequest.fromJson(Map<String, dynamic> json) =>
      _$RefundRequestFromJson(json);
}

@freezed
class SplitBillingStats with _$SplitBillingStats {
  const factory SplitBillingStats({
    required int totalSplitSales,
    required double totalAmount,
    required double averageSplitAmount,
    required double averagePaymentsPerSale,
  }) = _SplitBillingStats;

  factory SplitBillingStats.fromJson(Map<String, dynamic> json) =>
      _$SplitBillingStatsFromJson(json);
} 