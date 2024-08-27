// // Open bottom sheet
// import 'package:flutter/material.dart';
//
// import '../utils/routers.dart';
//
// class BottomSheetWidget {
//   void openBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       barrierColor: Colors.black.withOpacity(0.7),
//       context: context,
//       builder: (context) {
//         // return CategoryInputBottomSheet(
//           onNewNote: () {
//             Navigator.pop(context); // Close the bottom sheet
//             AppRouter.router.push("/create_new_note", extra: false);
//           },
//           onNewCategory: () {
//             Navigator.pop(context); // Close the bottom sheet
//             AppRouter.router.push("/create_new_note", extra: true);
//           },
//         );
//       },
//     );
//   }
// }
