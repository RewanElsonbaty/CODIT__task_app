// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'data': instance.data,
      'imageUrl': instance.imageUrl,
      'actionUrl': instance.actionUrl,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.approvalRequest: 'approval_request',
  NotificationType.approvalResponse: 'approval_response',
  NotificationType.saleCompleted: 'sale_completed',
  NotificationType.installmentDue: 'installment_due',
  NotificationType.installmentCollected: 'installment_collected',
  NotificationType.priceUpdate: 'price_update',
  NotificationType.systemAlert: 'system_alert',
  NotificationType.general: 'general',
};
