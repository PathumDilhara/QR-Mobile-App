import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'generated_qr_model.g.dart';

@HiveType(typeId: 1)
class GeneratedQRModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime date;

  GeneratedQRModel({
    String? id,
    required this.title,
    required this.date,
  }) : id = id ?? const Uuid().v4();
}

// In Hive, adapters are used to enable the storage of custom objects
// (i.e., non-primitive types like classes) within Hive boxes. Here’s why
// adapters are necessary:
//
// Serialization: Hive needs to convert (or serialize) custom objects into a
//                format that it can store, typically as binary data. The adapter is responsible
//                for defining how to convert your object into a storable format and how to
//                reconstruct the object from that format when you retrieve it from the box.
//
//  Custom Classes: When you're dealing with custom data types
//                  (like a class representing a user, a product, etc.), Hive doesn’t inherently
//                  know how to store these objects. An adapter provides the necessary instructions
//                  for Hive on how to encode and decode these objects.
//
// Type Safety: Hive adapters enforce type safety by ensuring that the data you
//              put into and retrieve from a box is consistent with the object type you're
//              working with. This helps prevent errors and ensures that your data is correctly
//              interpreted when retrieved.
