import 'package:billfold/budget/editbudget.dart';
import 'package:billfold/budget/get_budget.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Budgetview extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  Budgetview({super.key, required this.onLanguageChanged});

  @override
  State<Budgetview> createState() => _BudgetviewState();
}

class _BudgetviewState extends State<Budgetview> {
  num? spent;
    late UserProvider _userProvider; 

  @override
  void initState() {
    // TODO: implement initState
  
    super.initState();

  }

  

  void deletebudgetapi(budgetid) async {
    await context.read<UserProvider>().deletebudget(budgetid);
  }

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("Delete_this_budget"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(AppLocalizations.of(context).translate("budget_delete"),
              style: currentTheme.textTheme.bodyMedium),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child:  Text(AppLocalizations.of(context).translate('No')),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child:  Text(AppLocalizations.of(context).translate('Yes')),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return exitApp!;
  }

  Map<String, String> catimages = {
    "Debt": "assets/images/debts.png",
    "Education": "assets/images/education.png",
    "Entertainment": "assets/images/entertainment.png",
    "Food": "assets/images/food.png",
    "Gifts & Donations": "assets/images/gift.png",
    "Health & Wellness": "assets/images/healthcare.png",
    "Housing": "assets/images/home.png",
    "Insurance": "assets/images/insurance.png",
    "Miscellaneous": "assets/images/other.png",
    "Personal Care": "assets/images/personalcare.png",
    "Pet Care": "assets/images/pet.jfif",
    "Savings & Investments": "assets/images/self-awareness.png",
    "Self-Improvement": "assets/images/self-awareness.png",
    "Transportation": "assets/images/shipment.png",
    "Travel": "assets/images/travel.png",
    "Salary": "assets/images/salary.png",
    'Commission': 'assets/images/commision.png',
    'Interest': 'assets/images/interest.png',
    'Scholarship': 'assets/images/scholarship.png',
    'Investments': 'assets/images/investments.png',
    'Retail': 'assets/images/shopping.png',
    'Rent':"assets/images/rent.png",  
    'BankStatement':"assets/images/bankstatement.png"
  };

  _getamount(int? e) {
    var matchamt = _userProvider.budgetsumdata!.budget!.where((element) {
      return element.subcatid == e;
    }).toList();
    if (matchamt.isNotEmpty) {
      spent = matchamt.first.amt;
      return spent;
    } else {
      spent = 0;
      return spent;
    }
  }

  findpercent(spent, left) {
    double val = (spent / left);
    if (val >= 0 && val <= 1) {
      return val;
    } else if (val >= 1) {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
  _userProvider=context.watchuser;
       

    return  SafeArea(
            child: Scaffold(
              appBar: AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                title: Text(
                    AppLocalizations.of(context).translate("my_budgets"),
                    style: currentTheme.textTheme.displayMedium),
                centerTitle: true,
                backgroundColor: currentTheme.canvasColor,
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: Colors.grey.withOpacity(0.2),
                child: SingleChildScrollView(
                    child: _userProvider.getbudgeting? Column(children: [
                      Padding(
                        padding: const EdgeInsets.only( top: 12, left: 15, right: 15),
                        child: ListTile(
                            title: ShimmerWidget.rectangular(
                              height: 180,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),),
                      ),
                     Padding(
                        padding: const EdgeInsets.only( top: 12, left: 15, right: 15),
                        child: ListTile(
                            title: ShimmerWidget.rectangular(
                              height: 180,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),),
                      ),
                     Padding(
                        padding: const EdgeInsets.only( top: 12, left: 15, right: 15),
                        child: ListTile(
                            title: ShimmerWidget.rectangular(
                              height: 180,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),),
                      ),
                    ],): Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_userProvider.budgetdata != null && _userProvider.budgetdata!.budget!.isNotEmpty)
                      ..._userProvider.budgetdata!.budget!.map((e) => Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 15, right: 15),
                            child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    color: currentTheme.canvasColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                catimages[e.catname] ?? "assets/images/category.png",
                                                width: _userProvider.userdata?.language ==
                                                        'Tamil'
                                                    ? 25
                                                    : 35,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(e.catname ?? ""),
                                                style: TextStyle(
                                                    fontSize:
                                                        _userProvider.userdata?.language ==
                                                                'Tamil'
                                                            ? 11
                                                            : 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Budgetedit(
                                                                budgetid:
                                                                    e.budgetid!,
                                                                catid: e.catid!,
                                                                frequency: e
                                                                    .frequency!,
                                                                startdate: e
                                                                    .startdate!,
                                                                subcatid:
                                                                    e.subcatid!,
                                                                threshold: e
                                                                    .threshold!,
                                                                amt: e
                                                                    .budgetamt!,
                                                                catname:
                                                                    e.catname!,
                                                                subcatname: e
                                                                    .subcatname!,
                                                                enddate:
                                                                    e.enddate!,
                                                                onLanguageChanged:
                                                                    widget
                                                                        .onLanguageChanged,
                                                              )));
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate("edit"),
                                                  style: TextStyle(
                                                      fontSize:
                                                          _userProvider.userdata?.language ==
                                                                  'Tamil'
                                                              ? 8
                                                              : 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueGrey),
                                                )),
                                            IconButton(
                                              onPressed: () async {
                                                bool returnvale =
                                                    await _showMyDialog(
                                                        context, currentTheme);

                                                if (returnvale) {
                                                  deletebudgetapi(e.budgetid);
                                                }
                                              },
                                              icon: Icon(
                                                size: 17,
                                                Icons.delete,
                                                color: Colors.black38,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                            e.subcatname ?? "",
                                          ),
                                          style: TextStyle(
                                              fontSize:
                                                  _userProvider.userdata!.language == 'Tamil'
                                                      ? 11
                                                      : 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate("total_amt") +" :",
                                          style: currentTheme
                                              .textTheme.bodySmall,
                                        ),
                                        
                                        Text(
                                          '${_userProvider.currency} ${commaSepartor(e.budgetamt ?? 0)}',
                                          style: currentTheme
                                              .textTheme.displayMedium,
                                        ),
                                       
                                      ],
                                    ),
                                   
                                    Expanded(
                                      child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        barRadius: const Radius.circular(8),
                                        backgroundColor: Colors.grey,
                                        lineHeight: 6.0,
                                        percent: findpercent(
                                            _getamount(e.subcatid),
                                            e.budgetamt!),
                                        progressColor:
                                            currentTheme.primaryColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20,left: 20, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context).translate("spent")}:${_userProvider.currency} ${commaSepartor(_getamount(e.subcatid))}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: _userProvider.userdata?.language == 'Tamil'
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5,
                                          ),
                                          Text(
                                              '${AppLocalizations.of(context).translate("left")}:${_userProvider.currency}  ${commaSepartor(e.budgetamt! - _getamount(e.subcatid))}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ))
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: Center(
                            child: Text(AppLocalizations.of(context)
                                .translate("no_data_found"))),
                      )
                    ],
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 100, bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: currentTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("Create_new_budget"),
                                style: TextStyle(
                                    color: currentTheme.canvasColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (MonthlyBudget(
                                          onLanguageChanged:
                                              widget.onLanguageChanged,
                                        ))),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: currentTheme.canvasColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("goto_dashboard"),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                                                   Navigator.pop(context);

                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          );
  }
}
