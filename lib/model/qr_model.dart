import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'qr_model.g.dart';

@HiveType(typeId: 1)
class QRModel {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  QRModel({
    String ? id,
    required this.title,
  }) : id =id ?? const Uuid().v4();
}
