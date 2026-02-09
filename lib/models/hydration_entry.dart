import 'package:uuid/uuid.dart';

class HydrationEntry {
  final String id;
  final DateTime timestamp;
  final int amountMl;
  final String? source;

  HydrationEntry({
    String? id,
    DateTime? timestamp,
    required this.amountMl,
    this.source,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'amountMl': amountMl,
        'source': source,
      };

  factory HydrationEntry.fromJson(Map<String, dynamic> json) {
    return HydrationEntry(
      id: json['id'] as String?,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      amountMl: (json['amountMl'] as int?) ?? 0,
      source: json['source'] as String?,
    );
  }
}
