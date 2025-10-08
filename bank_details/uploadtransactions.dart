// import 'dart:io';
// import 'package:billfold/bank_details/bankmodel.dart';
// import 'package:billfold/bank_details/choosebank.dart';
// import 'package:billfold/servises/user_respository.dart';
// import 'package:http/http.dart' as http;
// import 'package:billfold/bank_details/bank_final.dart';
// import 'package:billfold/main.dart';
// import 'package:billfold/theme_provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';

// class TransactionUpload extends StatefulWidget {
//   String? bankname;
//   TransactionUpload({super.key, this.bankname});

//   @override
//   State<TransactionUpload> createState() => _TransactionUploadState();
// }

// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// TextEditingController balance = TextEditingController();
// TextEditingController acnumber = TextEditingController();
// TextEditingController ifsccode = TextEditingController();

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
//         //     width: MediaQuery.of(context).size.width / 2.1,
//         //     margin: EdgeInsets.symmetric(vertical: 16),
//         //     decoration: BoxDecoration(
//         //         color: currentStep >= 2 ? currentTheme.primaryColor : Colors.grey,
//         //         borderRadius: BorderRadius.all(Radius.circular(8))))
//       ],
//     ),
//   );
// }

// int currentStep = 1;

// String No_file_chosen = "No file chosen";

// List<String> currencylist = [
//   'Savings',
//   'Current',
//   'Recurring Deposit',
//   'Fixed Deposit'
// ];
// String currecydefault = 'Savings';


// class _TransactionUploadState extends State<TransactionUpload> {
  

//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.keyboard_arrow_left,
//             color: Colors.black,
//           ),
//         ),
//         title: Text(
//           AppLocalizations.of(context).translate("Bank_Sync"),
//           style: currentTheme.textTheme.displayMedium,
//         ),
//         centerTitle: true,
//         backgroundColor: currentTheme.canvasColor,
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _stepper(currentStep, currentTheme, context),
//               SizedBox(
//                 height: 15,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 // crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "₹ " +
//                         AppLocalizations.of(context).translate("enter_balance"),
//                     style: currentTheme.textTheme.displayLarge,
//                   ),
//                   Center(
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: currentTheme.primaryColor, width: 3))),
//                       width: MediaQuery.of(context).size.width / 3,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             // width: MediaQuery.of(context).size.width / 4,
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               controller: balance,
//                               decoration: InputDecoration(
//                                   border: InputBorder.none, hintText: "0"),
//                               keyboardType: TextInputType.number,
//                               inputFormatters: <TextInputFormatter>[
//                                 FilteringTextInputFormatter.allow(RegExp(
//                                     r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
//                               ],
//                               validator: (value) {
//                                 var availableValue = value ?? '';
//                                 if (availableValue.isEmpty) {
//                                   return ("Enter Valid Amount!");
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       AppLocalizations.of(context)
//                           .translate("Transaction_history"),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     )),
//               ),
//               Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 15.0, vertical: 15),
//                   child: Container(
//                     height: 60,
//                     width: MediaQuery.of(context).size.width / 1.1,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.grey.withOpacity(0.2)),
//                     child: InkWell(
//                       onTap: () async {
//                         FilePickerResult? result =
//                             await FilePicker.platform.pickFiles();
//                         if (result != null) {
//                           setState(() {
//                             No_file_chosen = result.names.first!;
//                           });
//                         }
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             No_file_chosen,
//                             style: currentTheme.textTheme.displaySmall,
//                           ),
//                           const Icon(
//                             Icons.file_upload,
//                             color: Colors.black,
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 25,
//               ),   Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       AppLocalizations.of(context).translate("AccountNumber"),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     )),
//               ),
//               Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 15.0, vertical: 15),
//                   child: Container(
//                     height: 60,
//                     width: MediaQuery.of(context).size.width / 1.1,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.grey.withOpacity(0.2)),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: TextFormField(
//                         controller: acnumber,
//                         decoration: InputDecoration(
//                             border: InputBorder.none, hintText: 'XXXXXXXXXX'),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: <TextInputFormatter>[
//                           FilteringTextInputFormatter.allow(
//                               RegExp(r'^\d{0,17}')),
//                           // Allow digits with optional decimal point and up to two decimal places
//                         ],
//                         validator: (value) {
//                           var availableValue = value ?? '';
//                           if (availableValue.isEmpty) {
//                             return ("Enter Valid Account Number!");
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   )),
           
//               SizedBox(
//                 height: 25,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       AppLocalizations.of(context).translate("IFSCCode"),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     )),
//               ),
//               Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 15.0, vertical: 15),
//                   child: Container(
//                     height: 60,
//                     width: MediaQuery.of(context).size.width / 1.1,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.grey.withOpacity(0.2)),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: TextFormField(
//                         controller: ifsccode,
//                         decoration: InputDecoration(
//                             border: InputBorder.none, hintText: 'XXXXXXXXXX'),
//                         validator: (value) {
//                           var availableValue = value ?? '';
//                           if (availableValue.isEmpty) {
//                             return ("Enter Valid IFSC Code!");
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 25,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: SizedBox(
//                           width: 40,
//                           child: CircleAvatar(
//                             backgroundColor: currentTheme.primaryColor,
//                             radius: 25,
//                             child: CircleAvatar(
//                               backgroundColor: currentTheme.canvasColor,
//                               radius: 16,
//                               child: Image.asset(
//                                 height: 25,
//                                 "assets/images/atm.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         AppLocalizations.of(context).translate("AccountType"),
//                         style: currentTheme.textTheme.bodyMedium,
//                       ),
//                     ],
//                   ),
//                   DropdownButton(
//                     // Initial Value
//                     alignment: Alignment.centerRight,
//                     value: currecydefault,

//                     // Down Arrow Icon
//                     icon: Icon(Icons.keyboard_arrow_down),

//                     // Array list of items
//                     items: currencylist.map((String items) {
//                       return DropdownMenuItem(
//                         value: items,
//                         child: Text(
//                           items,
//                         ),
//                       );
//                     }).toList(),
//                     // After selecting the desired option,it will
//                     // change button value to selected value
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         currecydefault = newValue!;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
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
//                         if (_formKey.currentState!.validate()) {
//                             var acid = 3, userid="user567", acname=currecydefault+' account', actype=currecydefault, bankname=widget.bankname, acno= num.parse(acnumber.text), bal=num.parse(balance.text), ifsc=ifsccode.text, hidden=0;
//                           createBank(  acid, userid, acname, actype, bankname, acno, bal, ifsc, hidden);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => (BankFinal())),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }
