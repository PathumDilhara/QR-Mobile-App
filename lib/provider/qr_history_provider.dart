import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_mobile_app/model/scanned_qr_model.dart';

import '../model/generated_qr_model.dart';

class QRHistoryProvider extends ChangeNotifier {

  // Empty list to store qr data as qr model objects
  List<GeneratedQRModel> storedGenQRCodes = [];
  List<ScannedQrModel> storedScnQRCodes = [];

  // database reference for notes
  final _myGenQRBox = Hive.box("generated_qr");
  final _myScnQRBox = Hive.box("scanned_qr");

  // check gen box is empty
  Future<bool> isGenQRBoxEmpty() async {
    return _myGenQRBox.isEmpty;
  }

  // method to store new generated qr code to generated hive box
  Future<void> storeGeneratedQR(GeneratedQRModel generatedQRModel) async {
    try {
      final dynamic allGenQRCodes =
          _myGenQRBox.get("generated_qr", defaultValue: []); // get qr code set
      allGenQRCodes.add(generatedQRModel); // ad new qr code obj to set
      await _myGenQRBox.put("generated_qr",
          allGenQRCodes); // again add/over write updated set to "generated_qr"
    } catch (err) {
      print(err.toString());
    }
    loadGeneratedQRCodes();
    notifyListeners();
  }

  // Method to load qr codes
  Future<void> loadGeneratedQRCodes() async {
    final dynamic allGenQRCodes =
        _myGenQRBox.get("generated_qr", defaultValue: []);

    storedGenQRCodes = allGenQRCodes.cast<GeneratedQRModel>().toList();
  }

  // Method to delete a single history
  Future<void> deleteGeneratedQRCode(GeneratedQRModel generatedQRModel) async {
    try {
      final dynamic allGenQRCodes =
          _myGenQRBox.get("generated_qr", defaultValue: []);
      allGenQRCodes.remove(generatedQRModel);
      await _myGenQRBox.put("generated_qr", allGenQRCodes);
    } catch (err) {
      print(err.toString());
    }
    notifyListeners();
  }

  // Method to clear storage
  Future<void> clearGeneratedQRBox() async {
    await _myGenQRBox.clear();
    notifyListeners();
  }

  // ******************************************************************************************

  // check box is empty
  Future<bool> isScnQRBoxEmpty() async {
    return _myScnQRBox.isEmpty;
  }

  // method to store new scanned qr code to scanned hive box
  Future<void> storeScnQR(ScannedQrModel scannedQRModel) async {
    try {
      final dynamic allScnQRCodes =
          _myScnQRBox.get("scanned_qr", defaultValue: []); // get qr code set
      allScnQRCodes.add(scannedQRModel); // ad new qr code obj to set
      await _myScnQRBox.put("scanned_qr",
          allScnQRCodes); // again add/over write updated set to "scanned_qr"
    } catch (err) {
      print(err.toString());
    }
    loadScnQRCodes();
    notifyListeners();
  }

  // Method to load scn qr codes
  Future<void> loadScnQRCodes() async {
    final dynamic allScnQRCodes =
        _myScnQRBox.get("scanned_qr", defaultValue: []);

    storedScnQRCodes = allScnQRCodes.cast<ScannedQrModel>().toList();
  }

  // Method to delete a single scn history
  Future<void> deleteScnQRCode(ScannedQrModel scannedQRModel) async {
    try {
      final dynamic allScnQRCodes =
          _myScnQRBox.get("scanned_qr", defaultValue: []);
      allScnQRCodes.remove(scannedQRModel);
      await _myScnQRBox.put("scanned_qr", allScnQRCodes);
    } catch (err) {
      print(err.toString());
    }
    notifyListeners();
  }

  // Method to clear storage
  Future<void> clearScnQRBox() async {
    await _myScnQRBox.clear();
    notifyListeners();
  }
}
