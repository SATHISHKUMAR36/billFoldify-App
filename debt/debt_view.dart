import 'dart:convert';
import 'dart:math';

import 'package:billfold/dashboardpage.dart';
import 'package:billfold/debt/debitbasemodel.dart';
import 'package:billfold/main.dart';

import 'package:billfold/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DebtView extends StatefulWidget {
   final void Function(Locale) onLanguageChanged;
  
  const DebtView({super.key,required this.onLanguageChanged});

  @override
  State<DebtView> createState() => _DebtViewState();
}

class _DebtViewState extends State<DebtView> {
 Future<DebtBaseModel>? _debtBaseModelFuture;
  @override
  void initState() {
    super.initState();
    print("iii");
    // Future.delayed(const Duration(seconds: 2), () {
    // });}
  }

  

_mainwidget(currentTheme, context, iowe, oweme) {
  iowe.map((e) {
    int mm = daysBetween(
        DateTime.parse(e.debt_date), DateTime.parse(e.debt_repaid_date));
    int current =
        daysBetween(DateTime.now(), DateTime.parse(e.debt_repaid_date));
    double percent = (mm - current) / mm;
  }).toList();

  return DefaultTabController(
    length: 2,
    child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
          backgroundColor: currentTheme.canvasColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage(onLanguageChanged: widget.onLanguageChanged,)),
                );
              },
              icon: Icon(Icons.keyboard_arrow_left)),
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  AppLocalizations.of(context).translate("Debt"),
                  style: currentTheme.textTheme.displayMedium,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            //  indicator:BoxDecoration(shape border: Border(bottom:BorderSide(width: 50) )),
            labelColor: currentTheme.primaryColor,
            indicatorColor: currentTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child:
                    Tab(text: AppLocalizations.of(context).translate("I_owe")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child:
                    Tab(text: AppLocalizations.of(context).translate("Owe_me")),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
           _tabview(context,currentTheme,iowe),
           _tabview(context,currentTheme,oweme),


          ],
        ),
      ),
    ),
  );
}


  
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
     
    // Future<DebtBaseModel> loaddata =  jsondata();
    return Scaffold(
      body: FutureBuilder<DebtBaseModel>(
        future: _debtBaseModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data != null) {
            // Data loaded successfully, you can use it here

            final iowe = snapshot.data!.iowe;
            final oweme = snapshot.data!.oweme!;
            // ${debtBaseModel.iowe!.first.Debtor_nmae}

            return _mainwidget(currentTheme, context, iowe, oweme);
          }
          return Text("No data found");
        },
      ),
    );
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

_percent(debt_date, debt_repaid_date) {
  int mm =
      daysBetween(DateTime.parse(debt_date), DateTime.parse(debt_repaid_date));
  int current = daysBetween(DateTime.now(), DateTime.parse(debt_repaid_date));
  double percent = (mm - current) / mm;
  if (percent <= 1 && percent >= 0) {
    return percent;
  } else if (percent < 0) {
    return 0.0;
  } else if (percent > 1) {
    return 1.0;
  }
}

_passed(left,debt_date, context, currentTheme) {
int dd;
  if (left) {
   dd = daysBetween(DateTime.now(), DateTime.parse(debt_date));
   if (dd<0){
    dd=0;
   }

}
else{
   dd = daysBetween(DateTime.parse(debt_date),DateTime.now());
   if (dd<0){
    dd=0;
   }
}

  if (dd < 30) {
    return Text(
      '$dd ' + AppLocalizations.of(context).translate("days"),
      style: currentTheme.textTheme.bodySmall,
    );
  } else if (dd < 60 && dd >= 30) {
    return Text(
      AppLocalizations.of(context).translate("one_month"),
      style: currentTheme.textTheme.bodySmall,
    );
  } else if (dd < 90 && dd >= 60) {
    return Text(
      AppLocalizations.of(context).translate("two_months"),
      style: currentTheme.textTheme.bodySmall,
    );
  } else if (dd < 120 && dd >= 90) {
    return Text(
      AppLocalizations.of(context).translate("three_months"),
      style: currentTheme.textTheme.bodySmall,
    );
  } else if (dd < 150 && dd >= 120) {
    return Text(
      AppLocalizations.of(context).translate("Four_months"),
      style: currentTheme.textTheme.bodySmall,
    );
  } else if (dd < 180 && dd >= 150) {
    return Text(
      AppLocalizations.of(context).translate("Five_months"),
      style: currentTheme.textTheme.bodySmall,
    );
  } else {
    return (
     Text( AppLocalizations.of(context).translate("Six_months"),
      style: currentTheme.textTheme.bodySmall,)
    );
  }
}



_tabview(context,currentTheme,data){
  return  Container(
              color: Colors.grey.withOpacity(0.1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var item in data)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: currentTheme.canvasColor.withOpacity(0.9)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.Debtor_nmae,
                                      style: currentTheme.textTheme.displayMedium,
                                    ),
                                    Text(
                                      item.amount_of_debt.toString(),
                                      style: currentTheme.textTheme.displayLarge,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: LinearPercentIndicator(
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  barRadius: const Radius.circular(8),
                                  backgroundColor: Colors.grey,
                                  lineHeight: 6.0,
                                  percent: _percent(
                                      item.debt_date, item.debt_repaid_date),
                                  progressColor: currentTheme.primaryColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text( AppLocalizations.of(context).translate("Passed")+": "),
                                        _passed( false,item.debt_date, context, currentTheme)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text( AppLocalizations.of(context).translate("Left")+": "),
                                        _passed( true,item.debt_repaid_date, context, currentTheme)
                                      ],
                                    ),
                                
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );

            
            
}
