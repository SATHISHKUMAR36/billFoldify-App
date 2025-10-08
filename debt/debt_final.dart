import 'package:billfold/dashboardpage.dart';
import 'package:billfold/debt/debt_view.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtFinal extends StatefulWidget {

  final void Function(Locale) onLanguageChanged;

  const DebtFinal({super.key,required this.onLanguageChanged});

  @override
  State<DebtFinal> createState() => _DebtFinalState();
}

class _DebtFinalState extends State<DebtFinal> {
  @override
  Widget build(BuildContext context) {
      ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(child: Scaffold(
      body: Column(
        children: [ 
          SizedBox(height: 50,),
          SizedBox(
            height: 250,
            width: 250,
            child: Image.asset(
              "assets/images/debt_final.png",
            ),
          ),

          SizedBox(height: 30,),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal:10.0),
        child: Align(alignment: Alignment.centerLeft,child: Text(AppLocalizations.of(context).translate("finish_debt"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),)),
      ),            
       SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Align(alignment: Alignment.centerLeft,child: Text(AppLocalizations.of(context).translate("debt_watch"),style: currentTheme.textTheme.bodyMedium,)),
                      ),
    SizedBox(height: 80,),
                        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate("view_my_debt"),
                        style: TextStyle(
                            color: currentTheme.canvasColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => (DebtView(onLanguageChanged: widget.onLanguageChanged,))),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    child: Center(
                        child: Text( AppLocalizations.of(context).translate("back_to_dashboard"),
                            style: currentTheme.textTheme.displayMedium)),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => (LandingPage(onLanguageChanged: widget.onLanguageChanged,))),(route) => false,
                      );
                    },
                  ),
                )
              ],
            ),
          )
      
          
          ],
      ),
    ));
  
  }
}