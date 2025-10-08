// import 'dart:convert';
// import 'package:billfold/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'face_finger_lock.dart';
// import 'main.dart';

// class CurrencyPage extends StatefulWidget {

//     String language;

//   String name;
//    CurrencyPage({super.key,required this.language,required this.name});

//   @override
//   State<CurrencyPage> createState() => _CurrencyPageState();

// }



// List<String> items =[
//   "₹ - Indian Rupee",
//   "\$ -  Singapore dollar (SGD) ",
//   "€ - Euro",
//   "\$ - US Dollar",
//   "£ - British Pound",
//   "¥ - Japanese Yen",
// ];
// String currecydefault = '₹ - Indian Rupee';



// int currentStep = 0;

// _stepper(currentStep, currentTheme, BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: [
//       Container(
//           height: 4,
//           width: MediaQuery.of(context).size.width / 2.1,
//           margin: EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//               color: currentTheme.primaryColor,
//               borderRadius: BorderRadius.all(Radius.circular(8)))),
//       // SizedBox(
//       //   width: 20,
//       // ),
//       Container(
//           height: 4,
//           width: MediaQuery.of(context).size.width / 2.1,
//           margin: EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//               color: currentStep >= 1 ? currentTheme.primaryColor : Colors.grey,
//               borderRadius: BorderRadius.all(Radius.circular(8)))),
//       // Container(
//       //     height: 4,
//       //     width: MediaQuery.of(context).size.width / 3.1,
//       //     margin: EdgeInsets.symmetric(vertical: 16),
//       //     decoration: BoxDecoration(
//       //         color: currentStep >= 2 ? currentTheme.primaryColor : Colors.grey,
//       //         borderRadius: BorderRadius.all(Radius.circular(8))))
//     ],
//   );
// }

// class _CurrencyPageState extends State<CurrencyPage> {

//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    
//     return Scaffold(
//       body: SafeArea(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _stepper(currentStep, currentTheme, context),
//           SizedBox(
//             height: 250,
//             width: 250,
//             child: Image.asset(
//               "assets/images/currency.png",
//             ),
//           ),
//           Column(
//             children: [
//               Text(
//                 AppLocalizations.of(context).translate("choose_currency"),
//                 style: currentTheme.textTheme.displayLarge,
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               DropdownButton(
//                 // Initial Value
//                 value: currecydefault,

//                 // Down Arrow Icon
//                 icon: Icon(Icons.keyboard_arrow_down),

//                 // Array list of items
//                 items: items.map((String items) {
//                   return DropdownMenuItem(
//                     value: items,
//                     child: Text(items),
//                   );
//                 }).toList(),
//                 // After selecting the desired option,it will
//                 // change button value to selected value
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     currecydefault = newValue!;
//                   });
//                 },
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 100),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 40,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: currentTheme.primaryColor,
//                     borderRadius: BorderRadius.circular(40)),
//                 child: InkWell(
//                   child: Center(
//                     child: Text(
//                       AppLocalizations.of(context).translate("Next"),
//                       style: TextStyle(
//                           color: currentTheme.canvasColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   onTap: () async {

                   

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => FaceFingerLogin(language: widget.language, name: widget.name, currency: currecydefault,)),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       )),
//     );
//   }
// }
