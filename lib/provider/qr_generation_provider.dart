import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';

class QRGenerationProvider extends ChangeNotifier{

  // Empty list to store qr data as qr model objects
  List<GeneratedQRModel> allQRCodes = [];

  // database reference for notes
  final _myQRBox = Hive.box("generated_qr");

  //final Map<String, GeneratedQRModel> _genQRCodes = {};

  // Map<String, GeneratedQRModel> get genQRCodes{
  //   return {..._genQRCodes};
  // }

  // check box is empty
  Future<bool> isQRBoxEmpty() async{
    return _myQRBox.isEmpty;
  }

  // method to store new generated qr code to generated hive box
  Future<void> storeGeneratedQR (GeneratedQRModel generatedQRModel) async {
    try {
      final dynamic allQRCodes = _myQRBox.get("generated_qr"); // get qwr code set
      allQRCodes.add(generatedQRModel); // ad new qr code obj to set
      await _myQRBox.put("generated_qr", allQRCodes); // again add/over write updated set to "generated_qr"
    } catch(err){
      print(err.toString());
    }
    notifyListeners();
  }
}