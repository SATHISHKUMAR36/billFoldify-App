// import 'package:billfold/goal/goal_detail.dart';
// import 'package:billfold/goal/goal_finish.dart';
// import 'package:billfold/goal/req_amount.dart';
// import 'package:billfold/main.dart';
// import 'package:billfold/settings/contextextension.dart';
// import 'package:billfold/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:provider/provider.dart';

// class GoalSavings extends StatefulWidget {
//   String? goalname;
//   String? note;
//   num? amount;
//   String? startdate;

//   GoalSavings(
//       {super.key, this.goalname, this.note, this.amount, this.startdate});

//   @override
//   State<GoalSavings> createState() => _GoalSavingsState();
// }

// class _GoalSavingsState extends State<GoalSavings> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _goalamt.dispose();
//   }

//   bool week = false;
//   bool month = true;
//   bool sixmonth = false;
//   bool year = false;

//   bool notificaton = true;

//   DateTime? selectedDate;

//   DateTime? currentdate = DateTime.now().add(Duration(days: 183));

//   _stepper(currentStep, currentTheme, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//               height: 4,
//               width: MediaQuery.of(context).size.width / 3.1,
//               margin: EdgeInsets.symmetric(vertical: 16),
//               decoration: BoxDecoration(
//                   color: currentTheme.primaryColor,
//                   borderRadius: BorderRadius.all(Radius.circular(8)))),
//           // SizedBox(
//           //   width: 20,
//           // ),
//           Container(
//               height: 4,
//               width: MediaQuery.of(context).size.width / 3.1,
//               margin: EdgeInsets.symmetric(vertical: 16),
//               decoration: BoxDecoration(
//                   color: currentStep >= 1
//                       ? currentTheme.primaryColor
//                       : Colors.grey,
//                   borderRadius: BorderRadius.all(Radius.circular(8)))),
//           Container(
//               height: 4,
//               width: MediaQuery.of(context).size.width / 3.1,
//               margin: EdgeInsets.symmetric(vertical: 16),
//               decoration: BoxDecoration(
//                   color: currentStep >= 2
//                       ? currentTheme.primaryColor
//                       : Colors.grey,
//                   borderRadius: BorderRadius.all(Radius.circular(8))))
//         ],
//       ),
//     );
//   }

//   int currentStep = 2;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final _goalamt = TextEditingController();



//   insertgoal(
//       goalname, targetamt, currentamt, startdate, duedate, description) async {
//     await context.readuser.insertgoal(
//         goalname, targetamt, currentamt, startdate, duedate, description);
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
//     Future<void> selectDate(BuildContext context) async {
//       selectedDate = await showDatePicker(
//         context: context,
//         initialDate: selectedDate ?? currentdate,
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2100),
//       );
//       setState(() {
//         currentdate = selectedDate;
//       });
//     }

//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         backgroundColor: currentTheme.canvasColor,
//         
//         flexibleSpace: Center(
//             child: Text(
//           AppLocalizations.of(context).translate("New_Goal"),
//           style: currentTheme.textTheme.displayMedium,
//         )),
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: [
//           _stepper(currentStep, currentTheme, context),
//           SizedBox(
//             height: 25,
//           ),
//           Text(
//             AppLocalizations.of(context).translate("save_amount"),
//             style: currentTheme.textTheme.bodySmall,
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Center(
//             child: Container(
//               decoration: BoxDecoration(
//                   border: Border(
//                       bottom: BorderSide(
//                           color: currentTheme.primaryColor, width: 3))),
//               width: MediaQuery.of(context).size.width / 3,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     // width: MediaQuery.of(context).size.width / 4,
//                     child: TextFormField(
//                       textAlign: TextAlign.center,
//                       controller: _goalamt,
//                       decoration: InputDecoration(
//                           border: InputBorder.none, hintText: "0"),
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.allow(RegExp(
//                             r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
//                       ],
//                       validator: (value) {
//                         var availableValue = value ?? '';
//                         if (availableValue.isEmpty) {
//                           return ("Enter Valid Amount!");
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Slider(
//             activeColor: currentTheme.primaryColor,
//             inactiveColor: Colors.grey,
//             value:(double.parse (_goalamt.text.isNotEmpty?_goalamt.text:'0'))/((widget.amount)!.toDouble())*100,
//             max: 100,
//             label: _goalamt.text.isNotEmpty?_goalamt.text:'0',
            
//             onChanged: (double value) {
// //           setState(() {
// //             _currentSliderValue = value;
// //           });
//             },
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Expanded(
//                 child: InkWell(
//                   child: Chip(
//                     backgroundColor:
//                         week ? currentTheme.primaryColor : Colors.grey[300],
//                     side: BorderSide.none,
//                     label: SizedBox(
//                         width: 120,
//                         height: 20,
//                         child: Center(
//                             child: Text(
//                                 AppLocalizations.of(context)
//                                     .translate("Once_a_week"),
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color:
//                                         week ? Colors.white : Colors.black)))),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       week = true;
//                       month = false;
//                       year = false;
//                       sixmonth = false;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: InkWell(
//                   child: Chip(
//                     backgroundColor:
//                         month ? currentTheme.primaryColor : Colors.grey[300],
//                     side: BorderSide.none,
//                     label: SizedBox(
//                         width: 120,
//                         height: 20,
//                         child: Center(
//                             child: Text(
//                                 AppLocalizations.of(context)
//                                     .translate("Once_a_month"),
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color:
//                                         month ? Colors.white : Colors.black)))),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       week = false;
//                       month = true;
//                       year = false;
//                       sixmonth = false;
//                     });
//                   },
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Expanded(
//                 child: InkWell(
//                   child: Chip(
//                     backgroundColor:
//                         sixmonth ? currentTheme.primaryColor : Colors.grey[300],
//                     side: BorderSide.none,
//                     label: SizedBox(
//                         width: 120,
//                         height: 20,
//                         child: Center(
//                             child: Text(
//                           AppLocalizations.of(context)
//                               .translate("once_in_6_months"),
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: sixmonth ? Colors.white : Colors.black),
//                         ))),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       week = false;
//                       month = false;
//                       year = false;
//                       sixmonth = true;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: InkWell(
//                   child: Chip(
//                     backgroundColor:
//                         year ? currentTheme.primaryColor : Colors.grey[300],
//                     side: BorderSide.none,
//                     label: SizedBox(
//                         width: 120,
//                         height: 20,
//                         child: Center(
//                             child: Text(
//                                 AppLocalizations.of(context)
//                                     .translate("Once_a_year"),
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color:
//                                         year ? Colors.white : Colors.black)))),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       week = false;
//                       month = false;
//                       year = true;
//                       sixmonth = false;
//                     });
//                   },
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     child: SizedBox(
//                       width: 40,
//                       child: CircleAvatar(
//                         backgroundColor: currentTheme.primaryColor,
//                         radius: 20,
//                         child: CircleAvatar(
//                             backgroundColor: currentTheme.canvasColor,
//                             radius: 17,
//                             child: Icon(
//                               Icons.calendar_month,
//                               color: Colors.black,
//                             )),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     AppLocalizations.of(context).translate("Achieve_date"),
//                     style: currentTheme.textTheme.bodySmall,
//                   ),
//                 ],
//               ),
//               InkWell(
//                   onTap: () {
//                     selectDate(context);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 20.0),
//                     child: Text(
//                       DateFormat('dd-MMM-yyyy').format(currentdate!).toString(),
//                       style: TextStyle(
//                           color: currentTheme.primaryColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13),
//                     ),
//                   ))
//             ],
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(AppLocalizations.of(context).translate("Receive_alerts")),
//                 Switch(
//                     value: notificaton,
//                     activeColor: currentTheme.primaryColor,
//                     onChanged: (bool value) {
//                       setState(() {
//                         notificaton = value;
//                       });
//                     })
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 40,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: currentTheme.primaryColor,
//                     borderRadius: BorderRadius.circular(10)),
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
//                   onTap: () {
//                     if (_formKey.currentState!.validate()) {
//                       // var acid =, userid=, acname=, actype=, bankname=bankname, acno= , bal=, ifsc=ifsccode.text, hidden=0;
//                       try {
//                         context.loaderOverlay.show();
//                         insertgoal(
//                             widget.goalname,
//                             widget.amount,
//                             int.parse(_goalamt.text),
//                             widget.startdate,
//                             DateFormat('yyyy-MM-dd')
//                                 .format(currentdate!)
//                                 .toString(),
//                             widget.note);
//                         context.loaderOverlay.hide();
//                       } catch (e) {
//                         print("error in bank insert page");
//                       } finally {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //       // builder: (context) => (GoalFinish())),
//                         // );
//                       }
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     ));
//   }
// }
