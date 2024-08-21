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

  Future<void> createInitialGeneratedQRCodes () async {
    if(_myQRBox.isEmpty){
      await _myQRBox.put("generated_qr", allQRCodes);
    }
  }
  // Method to load qr codes
  Future<List<GeneratedQRModel>> loadGeneratedQRCodes() async {
    final dynamic allQRCodes = _myQRBox.get("generated_qr");

    if (allQRCodes != null && allQRCodes is List<dynamic>){
      return allQRCodes.cast<GeneratedQRModel>().toList();
    }
    return [];
  }

  // Method to delete a single history
  Future<void> deleteGeneratedQRCode (GeneratedQRModel qr)async {
    try {
      final dynamic allQRCodes = _myQRBox.get("generated_qr");
      allQRCodes.remove();
      await _myQRBox.put("generated_qr", allQRCodes);
    } catch(err) {
      print(err.toString());
    }
  }

  // method to store new qr code
  Future<void> storeGeneratedQR (GeneratedQRModel generatedQRModel) async {
    try {
      final dynamic allQRCodes = _myQRBox.get("generated_qr");
      allQRCodes.add(generatedQRModel);
      await _myQRBox.put("generated_qr", allQRCodes);
    } catch(err){
      print(err.toString());
    }
  }

  // Method to clear storage
  Future<void> clearQRBox() async {
    await _myQRBox.clear();
  }
}
