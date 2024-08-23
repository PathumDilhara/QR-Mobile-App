import 'package:flutter/material.dart';

class CustomFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Return the desired offset for your custom position
    return Offset(
      scaffoldGeometry.scaffoldSize.width - 130.0,
      scaffoldGeometry.scaffoldSize.height - 140.0,
    );
  }
}
