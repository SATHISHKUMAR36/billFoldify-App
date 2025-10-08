// import 'package:billfold/budget/budget_finish.dart';
// import 'package:billfold/budget/get_budget.dart';
// import 'package:billfold/budget/total_budget.dart';
// import 'package:billfold/main.dart';
// import 'package:billfold/theme_provider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class BudgetCategory extends StatefulWidget {
//   const BudgetCategory({super.key});

//   @override
//   State<BudgetCategory> createState() => _BudgetCategoryState();
// }
// _stepper(currentStep, currentTheme, BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Container(
//           height: 4,
//           width: MediaQuery.of(context).size.width / 3.1,
//           margin: EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//               color: currentTheme.primaryColor,
//               borderRadius: BorderRadius.all(Radius.circular(8)))),
//       // SizedBox(
//       //   width: 20,
//       // ),
//       Container(
//           height: 4,
//           width: MediaQuery.of(context).size.width / 3.1,
//           margin: EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//               color: currentStep >= 1 ? currentTheme.primaryColor : Colors.grey,
//               borderRadius: BorderRadius.all(Radius.circular(8)))),
//       Container(
//           height: 4,
//           width: MediaQuery.of(context).size.width / 3.1,
//           margin: EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//               color: currentStep >= 2 ? currentTheme.primaryColor : Colors.grey,
//               borderRadius: BorderRadius.all(Radius.circular(8))))
//     ],
//   );
// }

// int currentStep = 1;

// class _BudgetCategoryState extends State<BudgetCategory> {
//   bool showcategorey=false;
//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

//     return  SafeArea(
//       child: Scaffold(
//       appBar: AppBar(
//           backgroundColor: currentTheme.canvasColor,
//           leading: 
//         IconButton(onPressed: (){
//           Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => MonthlyBudget()),
//                       );
//         },icon:Icon(Icons.keyboard_arrow_left)),
//         flexibleSpace: Center(child: Text(AppLocalizations.of(context).translate("Monthly_budget"),style: currentTheme.textTheme.displayMedium,)),),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//                  _stepper(currentStep, currentTheme, context),
//                   SizedBox(height: 15,),
                  
//                     Column(
//                       children: [
//                         Padding(
//                         padding: const EdgeInsets.symmetric(horizontal:10.0),
//                         child: Align(alignment: Alignment.centerLeft,child: Text(AppLocalizations.of(context).translate("Set_catogoris"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),)),
//                       ),
//                       SizedBox(height: 10,),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal:10.0),
//                         child: Text(AppLocalizations.of(context).translate("choose_categories"),style: currentTheme.textTheme.bodyMedium,),
//                       ),
//                       ],
//                       ),
//                       SizedBox(height: 30,),
//                        Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
              
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: SizedBox(
//                           width: 40,
//                           child: CircleAvatar(
//                               backgroundColor: Colors.pink.withOpacity(0.1),
//                               radius: 20,
//                               child: Image.asset(
//                                 height:20,
//                                   "assets/images/shopping.png",
//                                 ),),
//                         ),
//                       ),
//                       Text(
//                         AppLocalizations.of(context).translate("Groceries"),
//                         style: currentTheme.textTheme.displayMedium,
//                       ),
//                     ],
//                   ),
//                  Padding(
//                    padding: const EdgeInsets.only(right:10.0),
//                    child: Container(
//                     height: 40,
//                     width:80,
//                     decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(10)),
//                     child:TextField(
//                       textAlign: TextAlign.center,
//                       textAlignVertical:TextAlignVertical.center,
//                       decoration: InputDecoration(hintText: '₹0',border: InputBorder.none,
//                       ),
//                       keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(RegExp(
//                                         r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
//                                   ],
                      
//                     )
//                    ),
//                  )
//                 ],
//               ),
//               SizedBox(height: 15,),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
              
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: SizedBox(
//                           width: 40,
//                           child: CircleAvatar(
//                               backgroundColor: Colors.yellow.withOpacity(0.1),
//                               radius: 20,
//                               child: Image.asset(
//                                 height:25,
//                                   "assets/images/gift.png",
//                                 ),),
//                         ),
//                       ),
//                       Text(
//                         AppLocalizations.of(context).translate("Gifts"),
//                         style: currentTheme.textTheme.displayMedium,
//                       ),
//                     ],
//                   ),
//                  Padding(
//                    padding: const EdgeInsets.only(right:10.0),
//                    child: Container(
//                     height: 40,
//                     width:80,
//                     decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(10)),
//                     child:TextField(
//                       textAlign: TextAlign.center,
//                       textAlignVertical:TextAlignVertical.center,
//                       decoration: const InputDecoration(hintText: '₹0',border: InputBorder.none,
//                       ),
//                       keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(RegExp(
//                                         r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
//                                   ],
                      
//                     )
//                    ),
//                  )
//                 ],
//               ),
//             SizedBox(height: 15,),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
              
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: SizedBox(
//                           width: 40,
//                           child: CircleAvatar(
//                               backgroundColor: Colors.blue.withOpacity(0.1),
//                               radius: 20,
//                               child: Image.asset(
//                                 height:25,
//                                   "assets/images/travel.png",
//                                 ),),
//                         ),
//                       ),
//                       Text(
//                         AppLocalizations.of(context).translate("Travel"),
//                         style: currentTheme.textTheme.displayMedium,
//                       ),
//                     ],
//                   ),
//                  Padding(
//                    padding: const EdgeInsets.only(right:10.0),
//                    child: Container(
//                     height: 40,
//                     width:80,
//                     decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(10)),
//                     child:TextField(
//                       textAlign: TextAlign.center,
//                       textAlignVertical:TextAlignVertical.center,
//                       decoration: InputDecoration(hintText: '₹0',border: InputBorder.none,
//                       ),
//                       keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(RegExp(
//                                         r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
//                                   ],
                      
//                     )
//                    ),
//                  )
//                 ],
//               ),


//                SizedBox(height: 15,),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
              
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: SizedBox(
//                           width: 40,
//                           child: CircleAvatar(
//                               backgroundColor: Colors.deepPurple.withOpacity(0.1),
//                               radius: 20,
//                               child: Image.asset(
//                                 height:25,
//                                   "assets/images/shirt.png",
//                                 ),),
//                         ),
//                       ),
//                       Text(
//                         AppLocalizations.of(context).translate("Cloths"),
//                         style: currentTheme.textTheme.displayMedium,
//                       ),
//                     ],
//                   ),
//                  Padding(
//                    padding: const EdgeInsets.only(right:10.0),
//                    child: Container(
//                     height: 40,
//                     width:80,
//                     decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(10)),
//                     child:TextField(
//                       textAlign: TextAlign.center,
//                       textAlignVertical:TextAlignVertical.center,
//                       decoration: InputDecoration(hintText: '₹0',border: InputBorder.none,
//                       ),
//                       keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.allow(RegExp(
//                                         r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
//                                   ],
                      
//                     )
//                    ),
//                  )
//                 ],
//               ),
//                  SizedBox(height: 15,),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal:10.0),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius:20 ,
//                       backgroundColor: currentTheme.primaryColor,
//                       child: CircleAvatar(
//                         backgroundColor: currentTheme.canvasColor,
//                         radius:17 ,
//                         child: Icon(Icons.add,color: Colors.black,),
//                       ),
//                     ),
//                     TextButton(onPressed: (){
//                           showcategorey=true;
                       
//                     }, child: Text(AppLocalizations.of(context).translate("add_a_category"),style: TextStyle(color: currentTheme.primaryColor,fontSize:14,fontWeight:FontWeight.bold ),))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
                          // MaterialPageRoute(builder: (context) => PlannedBudget()),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
            
//             ],
//           ),
//         ),

       
//       ),
//     );
//   }
// }