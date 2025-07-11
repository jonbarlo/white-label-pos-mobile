// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SplitPaymentImpl _$$SplitPaymentImplFromJson(Map<String, dynamic> json) =>
    _$SplitPaymentImpl(
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      reference: json['reference'] as String?,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$$SplitPaymentImplToJson(_$SplitPaymentImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'method': instance.method,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'reference': instance.reference,
      'paidAt': instance.paidAt?.toIso8601String(),
    };

_$SplitSaleRequestImpl _$$SplitSaleRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SplitSaleRequestImpl(
      userId: (json['userId'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerEmail: json['customerEmail'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SplitSaleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => SplitPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SplitSaleRequestImplToJson(
        _$SplitSaleRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalAmount': instance.totalAmount,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerEmail': instance.customerEmail,
      'notes': instance.notes,
      'items': instance.items,
      'payments': instance.payments,
    };

_$SplitSaleItemImpl _$$SplitSaleItemImplFromJson(Map<String, dynamic> json) =>
    _$SplitSaleItemImpl(
      itemId: (json['itemId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$$SplitSaleItemImplToJson(_$SplitSaleItemImpl instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };

_$SplitSaleResponseImpl _$$SplitSaleResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SplitSaleResponseImpl(
      message: json['message'] as String,
      sale: SplitSale.fromJson(json['sale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SplitSaleResponseImplToJson(
        _$SplitSaleResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'sale': instance.sale,
    };

_$SplitSaleImpl _$$SplitSaleImplFromJson(Map<String, dynamic> json) =>
    _$SplitSaleImpl(
      id: (json['id'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      payments: (json['payments'] as List<dynamic>)
          .map((e) => SplitPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerEmail: json['customerEmail'] as String?,
      notes: json['notes'] as String?,
      totalPaid: (json['totalPaid'] as num?)?.toDouble(),
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SplitSaleImplToJson(_$SplitSaleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'payments': instance.payments,
      'createdAt': instance.createdAt.toIso8601String(),
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerEmail': instance.customerEmail,
      'notes': instance.notes,
      'totalPaid': instance.totalPaid,
      'remainingAmount': instance.remainingAmount,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$AddPaymentRequestImpl _$$AddPaymentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AddPaymentRequestImpl(
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      reference: json['reference'] as String?,
    );

Map<String, dynamic> _$$AddPaymentRequestImplToJson(
        _$AddPaymentRequestImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'method': instance.method,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'reference': instance.reference,
    };

_$RefundRequestImpl _$$RefundRequestImplFromJson(Map<String, dynamic> json) =>
    _$RefundRequestImpl(
      paymentIndex: (json['paymentIndex'] as num).toInt(),
      refundAmount: (json['refundAmount'] as num).toDouble(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$RefundRequestImplToJson(_$RefundRequestImpl instance) =>
    <String, dynamic>{
      'paymentIndex': instance.paymentIndex,
      'refundAmount': instance.refundAmount,
      'reason': instance.reason,
    };

_$SplitBillingStatsImpl _$$SplitBillingStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$SplitBillingStatsImpl(
      totalSplitSales: (json['totalSplitSales'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      averageSplitAmount: (json['averageSplitAmount'] as num).toDouble(),
      averagePaymentsPerSale:
          (json['averagePaymentsPerSale'] as num).toDouble(),
    );

Map<String, dynamic> _$$SplitBillingStatsImplToJson(
        _$SplitBillingStatsImpl instance) =>
    <String, dynamic>{
      'totalSplitSales': instance.totalSplitSales,
      'totalAmount': instance.totalAmount,
      'averageSplitAmount': instance.averageSplitAmount,
      'averagePaymentsPerSale': instance.averagePaymentsPerSale,
    };
