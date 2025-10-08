// import 'dart:convert';
// import 'dart:io';

// import 'package:billfold/landingpage.dart';
// import 'package:billfold/servises/bilfoldifyApi.dart';
// import 'package:billfold/servises/signinusermodel.dart';
// import 'package:billfold/servises/user_model.dart';
// import 'package:billfold/servises/user_respository.dart';
// import 'package:billfold/settings/contextextension.dart';
// import 'package:billfold/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'main.dart';

// class FaceFingerLogin extends StatefulWidget {
//   FaceFingerLogin({
//     super.key,
//   });

//   @override
//   State<FaceFingerLogin> createState() => _FaceFingerLoginState();
// }

// bool face = true;
// bool notificaton = true;

// var user;

// _stepper(currentStep, currentTheme, BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 5.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//             height: 4,
//             width: MediaQuery.of(context).size.width / 2.1,
//             margin: EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//                 color: currentTheme.primaryColor,
//                 borderRadius: BorderRadius.all(Radius.circular(8)))),
//         // SizedBox(
//         //   width: 20,
//         // ),
//         Container(
//             height: 4,
//             width: MediaQuery.of(context).size.width / 2.1,
//             margin: EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//                 color:
//                     currentStep >= 1 ? currentTheme.primaryColor : Colors.grey,
//                 borderRadius: BorderRadius.all(Radius.circular(8)))),
//         // Container(
//         //     height: 4,
//         //     width: MediaQuery.of(context).size.width / 3.1,
//         //     margin: EdgeInsets.symmetric(vertical: 16),
//         //     decoration: BoxDecoration(
//         //         color: currentStep >= 2 ? currentTheme.primaryColor : Colors.grey,
//         //         borderRadius: BorderRadius.all(Radius.circular(8))))
//       ],
//     ),
//   );
// }

// int currentStep = 1;

// class _FaceFingerLoginState extends State<FaceFingerLogin> {
//   UserAPIDetails? userdata;
//   @override
//   void initState() {
//     super.initState();
//   }

//  Future<void> savePdfToCustomPath() async {
//   try {
//     // Load the PDF file from assets
//     final byteData = await rootBundle.load('assets/images/bankstatement.pdf');

//     // Get the external storage directory
//     final externalDir = await getExternalStorageDirectory();

//     if (externalDir != null) {
//       // Define a custom folder path within the external directory
//       final customPath = Directory('${externalDir.path}/MyAppFiles');

//       // Create the directory if it doesn't exist
//       if (!await customPath.exists()) {
//         await customPath.create(recursive: true);
//       }

//       // Define the full file path
//       final filePath = '${customPath.path}/bankstatement.pdf';
//       final file = File(filePath);

//       // Write the file to this path
//       await file.writeAsBytes(byteData.buffer.asUint8List());

//       print('PDF saved at: $filePath');
//     } else {
//       print("External storage directory not available.");
//     }
//   } catch (e) {
//     print('Error saving PDF to custom path: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
//     return Scaffold(
//       body: SafeArea(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//             onPressed: savePdfToCustomPath,
//             child: Text('Save File'),
//           ),
//         ],
//       )),
//     );
//   }
// }
