// import 'package:billfold/budget/budget_categories.dart';
// import 'package:billfold/budget/budget_finish.dart';
// import 'package:billfold/main.dart';
// import 'package:billfold/theme_provider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PlannedBudget extends StatefulWidget {
//   const PlannedBudget({super.key});

//   @override
//   State<PlannedBudget> createState() => _PlannedBudgetState();
// }

// _stepper(currentStep, currentTheme, BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal:5.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//             height: 4,
//             width: MediaQuery.of(context).size.width / 3.1,
//             margin: EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//                 color: currentTheme.primaryColor,
//                 borderRadius: BorderRadius.all(Radius.circular(8)))),
//         // SizedBox(
//         //   width: 20,
//         // ),
//         Container(
//             height: 4,
//             width: MediaQuery.of(context).size.width / 3.1,
//             margin: EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//                 color: currentStep >= 1 ? currentTheme.primaryColor : Colors.grey,
//                 borderRadius: BorderRadius.all(Radius.circular(8)))),
//         Container(
//             height: 4,
//             width: MediaQuery.of(context).size.width / 3.1,
//             margin: EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//                 color: currentStep >= 2 ? currentTheme.primaryColor : Colors.grey,
//                 borderRadius: BorderRadius.all(Radius.circular(8))))
//       ],
//     ),
//   );
// }

// int currentStep = 2;
// double _currentSliderValue=0;
// bool notificaton =true;


// class _PlannedBudgetState extends State<PlannedBudget> {
//   @override
//   Widget build(BuildContext context) {
//         ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
//     return  SafeArea(child: Scaffold(
// appBar: AppBar(
//           backgroundColor: currentTheme.canvasColor,
//           leading: 
//         IconButton(onPressed: (){
//           Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => (BudgetCategory())),
//                       );
//         },icon:Icon(Icons.keyboard_arrow_left)),
//         flexibleSpace: Center(child: Text(AppLocalizations.of(context).translate("Monthly_budget"),style: currentTheme.textTheme.displayMedium,)),),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _stepper(currentStep, currentTheme, context),
//                 SizedBox(height: 30,),
//                 Column(
//                       children: [
//                         Padding(
//                         padding: const EdgeInsets.symmetric(horizontal:10.0),
//                         child: Align(alignment: Alignment.centerLeft,child: Text(AppLocalizations.of(context).translate("planned_amount"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),)),
//                       ),
//                       SizedBox(height: 10,),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal:10.0),
//                         child: Align(alignment: Alignment.centerLeft,child: Text(AppLocalizations.of(context).translate("total_amount"),style: currentTheme.textTheme.bodyMedium,)),
//                       ),

//                       SizedBox(height: 30,),

//                       Center(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: currentTheme.primaryColor, width: 3))),
//                           width: MediaQuery.of(context).size.width / 3,
//                           child: Center(child: Text('₹0',style: currentTheme.textTheme.displayLarge,))
//                         ),
//                       ),
//                         SizedBox(height: 30,),
//                         Text('0%',style: currentTheme.textTheme.bodySmall,),
//                         Slider(
//                           activeColor:currentTheme.primaryColor,
//                           inactiveColor:Colors.grey,
//         value: _currentSliderValue,
//         max: 100,
//         divisions: 5,
//         label: _currentSliderValue.round().toString(),
//         onChanged: (double value) {
// //           setState(() {
// //             _currentSliderValue = value;
// //           });
//         },
//       ),

//       SizedBox(height: 25,),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal:15.0),
//         child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text( AppLocalizations.of(context).translate("notify_me")),
//                       ),
//                       Switch(
//                           value: notificaton,
//                           activeColor: currentTheme.primaryColor,
//                           onChanged: (bool value) {
//                             setState(() {
//                               notificaton = value;
//                             });
//                           })
//                     ],
//                   ),
//       ),
//                 Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: 40,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                         color: currentTheme.primaryColor,
//                         borderRadius: BorderRadius.circular(10)),
//                     child: InkWell(
//                       child: Center(
//                         child: Text(
//                           AppLocalizations.of(context).translate("Next"),
//                           style: TextStyle(
//                               color: currentTheme.canvasColor,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => (BudgetFinish())),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),

//                       ],
                      
//                       ),

//           ],
//         ),
//       ),
//     ));
//   }
// }