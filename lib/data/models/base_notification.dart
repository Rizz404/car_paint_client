import 'dart:convert';

// Generic function type for converting JSON map to a type T
typedef FromJsonFunction<T> = T Function(Map<String, dynamic> json);

// Generic function type for converting JSON string to a type T
typedef FromJsonStringFunction<T> = T Function(String json);

class BaseNotification<T> {
  final String type;
  final String message;
  final DateTime timestamp;
  final T data;

  BaseNotification({
    required this.type,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  BaseNotification<T> copyWith({
    String? type,
    String? message,
    DateTime? timestamp,
    T? data,
  }) {
    return BaseNotification<T>(
      type: type ?? this.type,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'data': data is Map ? data : data.toString(),
    };
  }

  factory BaseNotification.fromMap(
    Map<String, dynamic> map, {
    FromJsonFunction<T>? fromJson,
  }) {
    // Handle timestamp which might be in different formats from the server
    DateTime parsedTimestamp;
    if (map['timestamp'] is int) {
      parsedTimestamp =
          DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int);
    } else if (map['timestamp'] is String) {
      parsedTimestamp = DateTime.parse(map['timestamp'] as String);
    } else {
      parsedTimestamp = DateTime.now(); // Fallback
    }

    // Handle data field based on the type parameter T
    T parsedData;
    if (fromJson != null && map.containsKey('data')) {
      if (map['data'] is Map<String, dynamic>) {
        // Use custom converter for complex objects
        parsedData = fromJson(map['data'] as Map<String, dynamic>);
      } else if (map['data'] is String) {
        // Try to parse string data as JSON if we have a fromJson function
        try {
          final jsonData =
              json.decode(map['data'] as String) as Map<String, dynamic>;
          parsedData = fromJson(jsonData);
        } catch (e) {
          // Fallback for when string is not valid JSON
          parsedData = null as T;
        }
      } else {
        parsedData = null as T;
      }
    } else {
      // Fallback for primitive types
      if (T == String) {
        parsedData = (map['data']?.toString() ?? '') as T;
      } else if (map['data'] is T) {
        parsedData = map['data'] as T;
      } else {
        // For when data is null or can't be properly cast
        parsedData = null as T;
      }
    }

    return BaseNotification<T>(
      type: map['type'] as String,
      message: map['message'] as String,
      timestamp: parsedTimestamp,
      data: parsedData,
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseNotification.fromJson(
    String source, {
    FromJsonFunction<T>? fromJson,
  }) =>
      BaseNotification.fromMap(
        json.decode(source) as Map<String, dynamic>,
        fromJson: fromJson,
      );

  @override
  String toString() {
    return 'BaseNotification(type: $type, message: $message, timestamp: $timestamp, data: $data)';
  }

  @override
  bool operator ==(covariant BaseNotification<T> other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.message == message &&
        other.timestamp == timestamp &&
        other.data == data;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        message.hashCode ^
        timestamp.hashCode ^
        data.hashCode;
  }
}
