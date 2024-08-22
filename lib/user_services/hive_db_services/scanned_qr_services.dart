import 'package:hive/hive.dart';
import 'package:qr_mobile_app/model/scanned_qr_model.dart';
import 'package:uuid/uuid.dart';

class ScannedQRServices {
  List<ScannedQrModel> allQRCodes = [
    ScannedQrModel(
      id: const Uuid().v4(),
      title: "qr 10",
      date: DateTime.now(),
    ),
    ScannedQrModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      title: "qr 20",
    ),
    ScannedQrModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      title: "qr 30",
    )
  ];

  // database reference for notes
  final _myQRBox = Hive.box("scanned_qr");

  // check box is empty
  Future<bool> isQRBoxEmpty() async {
    return _myQRBox.isEmpty;
  }

  Future<void> createInitialQRCodes() async {
    if (_myQRBox.isEmpty) {
      await _myQRBox.put("scanned_qr", allQRCodes);
    }
  }

  // Method to load qr codes
  Future<List<ScannedQrModel>> loadQRCodes() async {
    final dynamic qrCodes = _myQRBox.get("scanned_qr");

    if (qrCodes != null && qrCodes is List<dynamic>) {
      return qrCodes.cast<ScannedQrModel>().toList();
    }
    return [];
  }

  // Method to delete a single history
  Future<void> deleteScannedQRCode (ScannedQrModel scannedQRModel)async {
    try {
      final dynamic allQRCodes = _myQRBox.get("scanned_qr");
      allQRCodes.remove(scannedQRModel);
      await _myQRBox.put("scanned_qr", allQRCodes);
    } catch(err) {
      print(err.toString());
    }
  }

  // method to store new qr code
  Future<void> storeScannedQR (ScannedQrModel scannedQRModel) async {
    try {
      final dynamic allQRCodes = _myQRBox.get("scanned_qr");
      allQRCodes.add(scannedQRModel);
      await _myQRBox.put("scanned_qr", allQRCodes);
    } catch(err){
      print(err.toString());
    }
  }

  // Method to clear storage
  Future<void> clearQRBox() async {
    await _myQRBox.clear();
  }
}
