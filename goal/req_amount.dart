// import 'package:billfold/goal/goal_detail.dart';
// import 'package:billfold/goal/goal_savings.dart';
// import 'package:billfold/main.dart';
// import 'package:billfold/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class ReqAmount extends StatefulWidget {
//   String? goalname;
//   String? note;
//   String? startdate;
//   ReqAmount({super.key, this.goalname, this.note,this.startdate});

//   @override
//   State<ReqAmount> createState() => _ReqAmountState();
// }



// class _ReqAmountState extends State<ReqAmount> {
//   _stepper(currentStep, currentTheme, BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
//                 color:
//                     currentStep >= 1 ? currentTheme.primaryColor : Colors.grey,
//                 borderRadius: BorderRadius.all(Radius.circular(8)))),
//         Container(
//             height: 4,
//             width: MediaQuery.of(context).size.width / 3.1,
//             margin: EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//                 color:
//                     currentStep >= 2 ? currentTheme.primaryColor : Colors.grey,
//                 borderRadius: BorderRadius.all(Radius.circular(8))))
//       ],
//     ),
//   );
// }

// int currentStep = 1;
// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// final _goalamt = TextEditingController();

// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

// @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _goalamt.dispose();


//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         backgroundColor: currentTheme.canvasColor,
//         automaticallyImplyLeading: false,
//         flexibleSpace: Center(
//             child: Text(
//           AppLocalizations.of(context).translate("New_Goal"),
//           style: currentTheme.textTheme.displayMedium,
//         )),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _stepper(currentStep, currentTheme, context),
//             SizedBox(
//               height: 30,
//             ),
//             Text(
//               AppLocalizations.of(context).translate("Req_amt"),
//               style: currentTheme.textTheme.bodySmall,
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(
//                             color: currentTheme.primaryColor, width: 3))),
//                 width: MediaQuery.of(context).size.width / 3,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       // width: MediaQuery.of(context).size.width / 4,
//                       child: TextFormField(
//                         textAlign: TextAlign.center,
//                         controller: _goalamt,
//                         decoration: InputDecoration(
//                             border: InputBorder.none, hintText: "0"),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: <TextInputFormatter>[
//                           FilteringTextInputFormatter.allow(RegExp(
//                               r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
//                         ],
//                         validator: (value) {
//                           var availableValue = value ?? '';
//                           if (availableValue.isEmpty) {
//                             return ("Enter Valid Amount!");
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 10, left: 10, top: 300),
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   height: 40,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       color: currentTheme.primaryColor,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: InkWell(
//                     child: Center(
//                       child: Text(
//                         AppLocalizations.of(context).translate("Next"),
//                         style: TextStyle(
//                             color: currentTheme.canvasColor,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     onTap: () {
//                       if (_formKey.currentState!.validate()) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => (GoalSavings(goalname: widget.goalname,note: widget.note,amount: num.parse(_goalamt.text),startdate: widget.startdate,))),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
