import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'scanned_qr_model.g.dart';

@HiveType(typeId: 2)
class ScannedQrModel {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime date;

  ScannedQrModel({
    String ? id,
    required this.title,
    required this.date,
  }) : id =id ?? const Uuid().v4();
}
