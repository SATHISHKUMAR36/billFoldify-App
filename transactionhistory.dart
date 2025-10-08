import 'package:billfold/add_expenses/expense.dart';
import 'package:billfold/add_expenses/expensedit.dart';
import 'package:billfold/add_expenses/expensemodel.dart';
import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/bank_details/interbank.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/settings/event_data_source.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'theme_provider.dart';

class TransactionHstory extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;

  TransactionHstory({super.key, required this.onLanguageChanged});

  @override
  State<TransactionHstory> createState() => _TransactionHstoryState();
}

class _TransactionHstoryState extends State<TransactionHstory> {
  late UserProvider _userProvider;
  late ThemeData currentTheme;

  @override
  void initState() {
    // expenseapi();
    // TODO: implement initState
    super.initState();
  }

  List<Bank> bank = [];
  num? dayincome;
  num? dayexpense;

  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  deleteexpenseapi(tid) async {
    await context.read<UserProvider>().deleteexpense(tid);
    // expenseapi();
  }

  // asc() {
  //   if (expensedata?.expenses != null) {
  //     filterdata = expensedata!.expenses!
  //       ..sort((a, b) => b.date!.compareTo(a.date!));
  //   }
  // }

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
                  child: Text(AppLocalizations.of(context).translate('No')),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context).translate('Yes')),
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

  List<Expense>? filterdata;

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
    'Rent': "assets/images/rent.png",
    'BankStatement': "assets/images/bankstatement.png"
  };

  _showsubcatbottom(currentTheme, appointmentDetails) {
    showModalBottomSheet(
        useSafeArea: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(12),
                          child: new Text(
                            DateFormat('dd-MM-yyyy')
                                .format(appointmentDetails.startTime),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      Expanded(
                        child: SingleChildScrollView(
                          child: context.watchuser.getexpensing
                              ? Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 30),
                                    ListTile(
                                      title: ShimmerWidget.rectangular(
                                        width: 100,
                                        height: 130,
                                        shapeBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ListTile(
                                      title: ShimmerWidget.rectangular(
                                        width: 100,
                                        height: 130,
                                        shapeBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ListTile(
                                      title: ShimmerWidget.rectangular(
                                        width: 100,
                                        height: 130,
                                        shapeBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ListTile(
                                      title: ShimmerWidget.rectangular(
                                        width: 100,
                                        height: 130,
                                        shapeBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (filterdata != null &&
                                            filterdata!.isNotEmpty)
                                          ...filterdata!.map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12,
                                                    left: 15,
                                                    right: 15),
                                                child: Container(
                                                    height: 140,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: e.transactiontype ==
                                                                        'Income'
                                                                    ? Colors
                                                                        .lightGreen
                                                                    : Colors
                                                                        .redAccent)),
                                                        color: currentTheme
                                                            .canvasColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          10.0),
                                                              child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                    catimages[e
                                                                            .catname] ??
                                                                        "assets/images/category.png",
                                                                    width: _userProvider.userdata!.language ==
                                                                            'Tamil'
                                                                        ? 25
                                                                        : 40,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                      e.catname ??
                                                                          "",
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontSize: _userProvider.userdata!.language ==
                                                                                'Tamil'
                                                                            ? 11
                                                                            : 15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .blue),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ExpenseEdit(
                                                                                    transacionhistory: true,
                                                                                    bankname: e.bankname!,
                                                                                    transacionid: e.transactionid!,
                                                                                    acid: e.acid!,
                                                                                    currency: e.currency!,
                                                                                    date: e.date!,
                                                                                    description: e.description!,
                                                                                    exrate: e.exchangerate!,
                                                                                    location: e.location!,
                                                                                    merchant: e.merchant!,
                                                                                    note: e.note!,
                                                                                    receptpath: e.receptpath!,
                                                                                    transactiontype: e.transactiontype!,
                                                                                    catid: e.catid!,
                                                                                    subcatid: e.subcatid!,
                                                                                    amt: e.amt!,
                                                                                    catname: e.catname!,
                                                                                    subcatname: e.subcatname!,
                                                                                    onLanguageChanged: widget.onLanguageChanged,
                                                                                  )));
                                                                    },
                                                                    child: Text(
                                                                      AppLocalizations.of(
                                                                              context)
                                                                          .translate(
                                                                              "edit"),
                                                                      style: TextStyle(
                                                                          fontSize: _userProvider.userdata!.language == 'Tamil'
                                                                              ? 8
                                                                              : 12,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.blueGrey),
                                                                    )),
                                                                IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    bool
                                                                        returnvale =
                                                                        await _showMyDialog(
                                                                            context,
                                                                            currentTheme);

                                                                    if (returnvale) {
                                                                      await deleteexpenseapi(
                                                                          e.transactionid);
                                                                      bank = _userProvider
                                                                          .bankdata!
                                                                          .banks!
                                                                          .where(
                                                                              (element) {
                                                                        return element.acid ==
                                                                            e.acid;
                                                                      }).toList();
                                                                      setState(
                                                                          () {
                                                                        filterdata = _userProvider
                                                                            .expensedata!
                                                                            .expenses!
                                                                            .where((e) =>
                                                                                DateTime.parse(e.date!) ==
                                                                                appointmentDetails.startTime)
                                                                            .toList();
                                                                      });
                                                                      await updatebank(
                                                                          bank.first
                                                                              .acid,
                                                                          "${bank.first.actype} account",
                                                                          bank.first
                                                                              .actype,
                                                                          bank.first
                                                                              .bankname,
                                                                          num.parse(bank
                                                                              .first
                                                                              .acnumber!),
                                                                          bank.first.acbalance! +
                                                                              e.amt!,
                                                                          bank.first.ishidden);

                                                                      // asc();
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                    size: 17,
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                  e.subcatname ??
                                                                      "",
                                                                ),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        _userProvider.userdata?.language == 'Tamil'
                                                                            ? 10
                                                                            : 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                  e.bankname ??
                                                                      "",
                                                                ),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        _userProvider.userdata?.language == 'Tamil'
                                                                            ? 10
                                                                            : 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.8)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          "total_amt"),
                                                                  style: currentTheme
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Text(
                                                                  '${_userProvider.currency} ${commaSepartor(e.amt ?? 0)}',
                                                                  style: currentTheme
                                                                      .textTheme
                                                                      .displayMedium,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              ))
                                        else ...[
                                          Center(child: Text("no data found"))
                                        ],
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 20,
                                              bottom: 20),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color:
                                                      currentTheme.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: InkWell(
                                                child: Center(
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            "Create_new_transaction"),
                                                    style: TextStyle(
                                                        color: currentTheme
                                                            .canvasColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            (ExpensePage(
                                                              onLanguageChanged:
                                                                  widget
                                                                      .onLanguageChanged,
                                                            ))),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ]);
              }
            });
          }
        });
  }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    if (details.appointments.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: details.date == date
                  ? Text(
                      details.date.day.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      details.date.day.toString(),
                      textAlign: TextAlign.center,
                    ),
            ),
            Divider(
              color: Colors.transparent,
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(8),
      child: details.date == date
          ? Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold),
            )
          : Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
            ),
    );
  }

  void calendarTapped(
    CalendarTapDetails details,
  ) {
    if ((details.targetElement == CalendarElement.appointment ||
            details.targetElement == CalendarElement.calendarCell) &&
        details.appointments!.isNotEmpty) {
      final Appointment appointmentDetails = details.appointments![0];

      filterdata = _userProvider.expensedata!.expenses!
          .where((e) => DateTime.parse(e.date!) == appointmentDetails.startTime)
          .toList();
      var incom = filterdata
          ?.where((element) => element.transactiontype == "Income")
          .toList();
      if (incom!.isNotEmpty) {
        var incomlist = incom.map((e) => e.amt).toList();
        dayincome = incomlist.reduce((value, element) => value! + element!);
      }

      var expen = filterdata
          ?.where((element) => element.transactiontype == "Expense")
          .toList();
      if (expen!.isNotEmpty) {
        var expenlist = expen.map((e) => e.amt).toList();
        dayexpense = expenlist.reduce((value, element) => value! + element!);
      }

      _showsubcatbottom(currentTheme, appointmentDetails);
    }
  }

  EventDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    _userProvider.expensedailydata?.expenses?.forEach((element) {
      appointments.add(Appointment(
        startTime: DateTime.parse(element.date!),
        endTime: DateTime.parse(element.date!),
        subject: commaSepartor(element.amt ?? 0),
        color: Colors.pink,
        startTimeZone: '',
        endTimeZone: '',
      ));
    });
    _userProvider.expensedailydata?.incomes?.forEach((element) {
      appointments.add(Appointment(
        startTime: DateTime.parse(element.date!),
        endTime: DateTime.parse(element.date!),
        subject: commaSepartor(element.amt ?? 0),
        color: Colors.lightBlue,
        startTimeZone: '',
        endTimeZone: '',
      ));
    });

    // _userProvider.interbankdata?.banks?.forEach((element) {
    //   appointments.add(Appointment(
    //     startTime: DateTime.parse(element.date!),
    //     endTime: DateTime.parse(element.date!),
    //     subject: commaSepartor(element.amount??0),
    //     color:Colors.indigo,
    //     startTimeZone: '',
    //     endTimeZone: '',
    //   ));
    // });

    return EventDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;
    currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    // if (_userProvider.expensedata?.expenses != null &&
    //     sortbytransactions == 'All transactions' &&
    //     sortbycategories == 'All Categories' &&
    //     sortbyaccount == 'All Accounts' &&
    //     sortbydefault == 'Max') {
    //   expenseapi();
    // }

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              elevation: 0.2,
              centerTitle: true,
              title: Text(
                  AppLocalizations.of(context)
                      .translate("Trasnsaction_History"),
                  style: TextStyle(
                      color: currentTheme.canvasColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              backgroundColor: currentTheme.primaryColor,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (_userProvider.interbankdata!.banks!.isNotEmpty) ...[
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 25, top: 5, bottom: 2),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Interbankview(
                                        onLanguageChanged:
                                            widget.onLanguageChanged),
                                  ));
                            },
                            child: Container(
                              height: 25,
                              width: _userProvider.userdata?.language == "Tamil"
                                  ? 200
                                  : 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(255, 214, 233, 231)),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("view_bank_transfers"),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.73,
                        child: SfCalendar(
                          cellBorderColor: currentTheme.primaryColor,
                          view: CalendarView.month,
                          showNavigationArrow: true,
                          viewHeaderStyle: ViewHeaderStyle(
                            dayTextStyle: currentTheme.textTheme.headlineSmall,
                          ),
                          headerStyle: CalendarHeaderStyle(
                              textStyle: currentTheme.textTheme.displayLarge!
                                  .copyWith(color: currentTheme.primaryColor),
                              textAlign: TextAlign.center),
                          onTap: calendarTapped,
                          initialSelectedDate: DateTime.now(),
                          dataSource: _getCalendarDataSource(),
                          todayHighlightColor: currentTheme.primaryColor,
                          todayTextStyle: TextStyle(
                              color:
                                  context.watchtheme.currentTheme.primaryColor,
                              fontWeight: FontWeight.bold),
                          monthCellBuilder: monthCellBuilder,
                          monthViewSettings: MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.appointment,
                            showTrailingAndLeadingDates: false,
                          ),
                          selectionDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: currentTheme.primaryColor, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
