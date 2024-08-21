import 'package:hive/hive.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';
import 'package:uuid/uuid.dart';

class GeneratedQRServices {
  List<GeneratedQRModel> allQRCodes = [
    GeneratedQRModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      title: "qr 1",
    ),
    GeneratedQRModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      title: "qr 2",
    ),
    GeneratedQRModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      title: "qr 3",
    )
  ];

  // database reference for notes
  final _myQRBox = Hive.box("generated_qr");

  // check box is empty
  Future<bool> isQRBoxEmpty() async{
    return _myQRBox.isEmpty;
  }

  Future<void> createInitialQRCodes () async {
    if(_myQRBox.isEmpty){
      await _myQRBox.put("generated_qr", allQRCodes);
    }
  }
  // Method to load qr codes
  Future<List<GeneratedQRModel>> loadQRCodes() async {
    final dynamic qrCodes = _myQRBox.get("generated_qr");

    if (qrCodes != null && qrCodes is List<dynamic>){
      return qrCodes.cast<GeneratedQRModel>().toList();
    }
    return [];
  }

  Future<void> clearQRBox() async {
    await _myQRBox.clear();
  }
}
