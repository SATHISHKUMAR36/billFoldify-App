import 'package:billfold/add_expenses/expense.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/recurring_payments/recurring_edit.dart';
import 'package:billfold/recurring_payments/recurringmodel.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecurringView extends StatefulWidget {
  String ttype;
  final void Function(Locale) onLanguageChanged;
   RecurringView({super.key,required this.onLanguageChanged,required this.ttype});

  @override
  State<RecurringView> createState() => _RecurringViewState();
}

class _RecurringViewState extends State<RecurringView> {
List<RecurringPayments>? filterdata;
List<RecurringPayments>? amot;
recurringfilter() {
    amot = filterdata?.where((element) {
      return element.transactiontype == widget.ttype ;
    }).toList();
  }

void recurringapi() async {
    if (_userProvider.recurringpaymentsdata?.recurringpayments != null ||
        _userProvider.recurringpaymentsdata!.recurringpayments!.isNotEmpty) {
      filterdata =_userProvider.recurringpaymentsdata!.recurringpayments!
        ..sort((a, b) => b.startdate!.compareTo(a.startdate!));
            recurringfilter();
   
    }
  }

    onrefrsh() async {
    await _userProvider.getrecurringpayments();
    recurringapi();
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
    "Savings & Investments": "assets/images/salary.png",
    "Self-Improvement": "assets/images/self-awareness.png",
    "Transportation": "assets/images/shipment.png",
    "Travel": "assets/images/travel.png",
    "Salary": "assets/images/salary.png",
    'Commission': 'assets/images/commision.png',
    'Interest': 'assets/images/interest.png',
    'Scholarship': 'assets/images/scholarship.png',
    'Investments': 'assets/images/investments.png',
    'Retail': 'assets/images/shopping.png',
    'Rent': "assets/images/rent.png",  'BankStatement':"assets/images/bankstatement.png"
  };

  
 Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("Delete_this_transaction"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(
              AppLocalizations.of(context).translate("transactrion_delete"),
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

  deleterecurringapi(tid) async {
    await context.read<UserProvider>().deleterecurringpayments(tid);
    recurringapi();
  }

  late UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
    if (_userProvider.expensedata?.expenses != null) {
      recurringapi();
    }
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(AppLocalizations.of(context).translate("recurringpayments"),
              style: currentTheme.textTheme.displayMedium),
          centerTitle: true,
          backgroundColor: currentTheme.canvasColor,

        ),
        body: SingleChildScrollView(
          child: _userProvider.getrecurringing?Column(
               children: [
                        SizedBox(height: 30),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
          ):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (amot != null && amot!.isNotEmpty)
                          ...amot!.map((e) => Padding(
                                padding: EdgeInsets.only(
                                    top: 12,
                                    left: _userProvider.userdata?.language ==
                                            'Tamil'
                                        ? 8
                                        : 13,
                                    right: _userProvider.userdata?.language ==
                                            'Tamil'
                                        ? 8
                                        : 13),
                                child: Container(
                                    // height: 140,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: e.transactiontype ==
                                                        'Income'
                                                    ? Colors.lightGreen
                                                    : Colors.redAccent)),
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
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    catimages[e.catname] ?? "assets/images/category.png",
                                                    width: _userProvider
                                                                .userdata
                                                                ?.language ==
                                                            'Tamil'
                                                        ? 25
                                                        : 40,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                      e.catname ?? "",
                                                    ),
                                                    style: TextStyle(
                                                        fontSize: _userProvider
                                                                    .userdata
                                                                    ?.language ==
                                                                'Tamil'
                                                            ? 12
                                                            : 15,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                              builder:
                                                                  (context) =>
                                                                      RecurringEdit(
                                                                        acid: e.acid!,amount: e.amount!,bankname: e.bankname!,catid: e.catid!,catname: e.catname!,defreccurringdate: DateTime.parse(e.nextoccurance!).day.toString(),enddate: e.enddate!,nextoccuring: e.nextoccurance!,note: e.note!,onLanguageChanged: widget.onLanguageChanged,frequency: e.frequency!,recurringid: e.recurringid!,startdate: e.startdate!,status: e.status!,subcatid: e.subcatid!,subcatname: e.subcatname!,
                                                                      )));
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate("edit"),
                                                      style: TextStyle(
                                                          fontSize: _userProvider
                                                                      .userdata!
                                                                      .language ==
                                                                  'Tamil'
                                                              ? 8
                                                              : 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.blueGrey),
                                                    )),
                                                IconButton(
                                                  onPressed: () async {
                                                    bool returnvale =
                                                        await _showMyDialog(
                                                            context,
                                                            currentTheme);

                                                    if (returnvale) {
                                                      deleterecurringapi(
                                                          e.recurringid);

                                                                                                   }
                                                  },
                                                  icon: Icon(
                                                   size: 17,
                                                  Icons.delete,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                      e.subcatname ?? "",
                                                    ),
                                                    style: TextStyle(
                                                        fontSize: _userProvider
                                                                    .userdata
                                                                    ?.language ==
                                                                'Tamil'
                                                            ? 10
                                                            : 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                                  SizedBox(height: 8,),
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      AppLocalizations.of(context)
                                                          .translate(
                                                        e.frequency ?? "",
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: _userProvider
                                                                      .userdata
                                                                      ?.language ==
                                                                  'Tamil'
                                                              ? 10
                                                              : 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color.fromARGB(255, 231, 102, 182)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                  e.bankname ?? "",
                                                ),
                                                style: TextStyle(
                                                    fontSize: _userProvider
                                                                .userdata
                                                                ?.language ==
                                                            'Tamil'
                                                        ? 10
                                                        : 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(255, 31, 30, 30)
                                                        .withOpacity(0.8)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate("total_amt"),
                                                  style: currentTheme
                                                      .textTheme.bodySmall,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  '${_userProvider.currency} ${commaSepartor(e.amount ?? 0)}',
                                                  style: currentTheme
                                                      .textTheme.displayMedium,
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate("Next_Occurance"),
                                                  style: currentTheme
                                                      .textTheme.bodySmall,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  '${DateFormat("dd-MM-yyyy").format(DateTime.parse(e.nextoccurance.toString()))}',
                                                  style: currentTheme
                                                      .textTheme.displayMedium,
                                                )
                                              ],
                                            ),
                                            
                                          ],
                                        ),
                                        SizedBox(height: 15,),
                                         Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate("Createdate"),
                                                  style: currentTheme
                                                      .textTheme.bodySmall,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  '${DateFormat("dd-MM-yyyy").format(DateTime.parse(e.startdate.toString()))}',
                                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate("end_date"),
                                                  style: currentTheme
                                                      .textTheme.bodySmall,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  '${DateFormat("dd-MM-yyyy").format(DateTime.parse(e.enddate.toString()))}',
                                                   style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            )
                                            
                                          ],
                                        ),

                                       SizedBox(
                                          height: 15,
                                        )
                                      ],
                                    )),
                              ))
                        else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 100),
                            child: Center(
                                child: Text(AppLocalizations.of(context)
                                    .translate("no data found"))),
                          )
                        ],
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 70, left: 15, right: 15),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: currentTheme.canvasColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LandingPage(
                                        onLanguageChanged:
                                            widget.onLanguageChanged,
                                        selectedIndex: 2),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: SizedBox(
                                      width: 40,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            currentTheme.primaryColor,
                                        radius: 20,
                                        child: CircleAvatar(
                                            backgroundColor:
                                                currentTheme.canvasColor,
                                            radius: 16,
                                            child: Icon(
                                              Icons.restore,
                                              color: Colors.black,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("Trasnsaction_History"),
                                    style: currentTheme.textTheme.displayMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                        .translate("Create_new_transaction"),
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
                                        builder: (context) => (ExpensePage(
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
       
      );
  }
}