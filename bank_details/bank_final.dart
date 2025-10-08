import 'dart:async';

import 'package:billfold/landingpage.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class BankFinal extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  
  bool update;
   BankFinal({super.key,required this.update,required this.onLanguageChanged});

  @override
  State<BankFinal> createState() => _BankFinalState();
}

class _BankFinalState extends State<BankFinal> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), (){
      Navigator.pop(context);
      

    });
  }
  @override
  Widget build(BuildContext context) {
       ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return  Scaffold(
          backgroundColor: currentTheme.canvasColor,

      body: Column(
        children: [
          SizedBox(height: 50,),
          SizedBox(
            height: 250,
            width: 250,
            child: Image.asset(
              "assets/images/creditcard.png",
            ),
          ),
            SizedBox(height: 30,),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal:10.0),
        child: Align(alignment: Alignment.centerLeft,child: Text(widget.update ?  AppLocalizations.of(context).translate("edit_bank") : AppLocalizations.of(context).translate("finish_bank"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),)),
      ),            
       SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Align(alignment: Alignment.centerLeft,child: Text(AppLocalizations.of(context).translate("finish_bank_sub"),style: currentTheme.textTheme.bodyMedium,)),
                      ),
    // SizedBox(height: 80,),
          //               Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 15.0),
          // child: Column(
          //   children: [
          //     Container(
          //       height: 40,
          //       width: MediaQuery.of(context).size.width,
          //       decoration: BoxDecoration(
          //             color: currentTheme.primaryColor,
          //             borderRadius: BorderRadius.circular(10)),
          //         child: InkWell(
          //           child: Center(
          //             child: Text(
          //               AppLocalizations.of(context).translate("add_bank"), 
          //               style: TextStyle(
          //                   color: currentTheme.canvasColor,
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //           ),
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => (ChooseBank())),
          //             );
          //           },
          //         ),
          //       ),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Container(
          //         height: 40,
          //         width: MediaQuery.of(context).size.width,
          //         decoration: BoxDecoration(
          //             color: Colors.grey.withOpacity(0.3),
          //             borderRadius: BorderRadius.circular(10)),
          //         child: InkWell(
          //           child: Center(
          //               child: Text( AppLocalizations.of(context).translate("back_to_dashboard"),
          //                   style: currentTheme.textTheme.displayMedium)),
          //           onTap: () {
          //             Navigator.pushAndRemoveUntil(
          //               context,
          //               MaterialPageRoute(builder: (context) => (const LandingPage())),(route) => false,
          //             );
          //           },
          //         ),
          //       )
          //     ],
          //   ),
          // )
      

        ],
      ),
    );
  }
}