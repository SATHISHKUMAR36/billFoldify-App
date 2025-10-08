import 'package:billfold/accounts.dart';
import 'package:billfold/add_expenses/Expenseview.dart';
import 'package:billfold/add_expenses/Invoicedata/invoiceview.dart';
import 'package:billfold/add_expenses/expensemodel.dart';
import 'package:billfold/bank_details/choosebank.dart';
import 'package:billfold/budget/budgetview.dart';
import 'package:billfold/budget/get_budget.dart';
import 'package:billfold/goal/goal_detail.dart';
import 'package:billfold/goal/goal_view.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/recurring_payments/recurring_view.dart';
import 'package:billfold/recurring_payments/recurringmodel.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'face_finger_lock.dart';
import 'image_picker.dart';
import 'main.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class DashboardPage extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;

  const DashboardPage({super.key, required this.onLanguageChanged});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

DateTime currentdate = DateTime.now();
String currentdate1 = DateFormat("MMM-yyyy").format(DateTime.now());

class _DashboardPageState extends State<DashboardPage> {
  late UserProvider _userProvider;

  num? totalexpense;
  num? totalincome;

  num? totalrecurringexpense;
  num? totalrecurringincome;

  Map<String, double> data = {};
  Map<String, double> data1 = {};
  List<Expense>? amot;
  List<Expense>? amot1;
  List<RecurringPayments>? recexp;
  List<RecurringPayments>? recinc;

  List<Color> colorList = [
    Color.fromARGB(255, 247, 123, 114),
    const Color.fromARGB(255, 86, 173, 245),
    const Color.fromARGB(255, 238, 223, 88),
    Color.fromARGB(255, 144, 240, 147),
    const Color.fromARGB(255, 86, 210, 226),
    const Color.fromARGB(255, 150, 100, 236),
    Color.fromARGB(255, 245, 103, 150),
    const Color.fromARGB(255, 104, 125, 243),
    const Color.fromARGB(255, 231, 126, 94),
    const Color.fromARGB(255, 211, 98, 231),
    const Color.fromARGB(255, 105, 132, 146),
    const Color.fromARGB(255, 231, 198, 98),
     Color.fromARGB(255, 169, 235, 231),

    Color.fromARGB(255, 182, 135, 236),
    Color.fromARGB(255, 65, 88, 88),
    Color.fromARGB(255, 172, 131, 116),
   
    
  ];

  @override
  void initState() {
    
    super.initState();
  }

  Future<dynamic> expensefilter() async {
    data.clear();
    data1.clear();
    amot = _userProvider.expensedata?.expenses?.where((element) {
      return element.transactiontype == 'Expense' &&
          DateFormat("yyyy-MMM").format(DateTime.parse(element.date!)) ==
              ('${currentyear}-${currentmonth}');
    }).toList();
    amot1 = _userProvider.expensedata?.expenses?.where((element) {
      return element.transactiontype == 'Income' &&
          DateFormat("yyyy-MMM").format(DateTime.parse(element.date!)) ==
              ('${currentyear}-${currentmonth}');
    }).toList();
    if (amot!.isNotEmpty) {
      totalexpense = num.parse(amot!
          .map(
            (e) => e.amt,
          )
          .toList()
          .reduce((value, element) => value! + element!)!
          .toStringAsFixed(1));
      for (var i = 0; i < amot!.length; i++) {
        if (data.keys.contains(
            AppLocalizations.of(context).translate(amot![i].catname!))) {
          data[AppLocalizations.of(context).translate(amot![i].catname!)] =
              data[AppLocalizations.of(context).translate(amot![i].catname!)]! +
                  double.parse(amot![i].amt.toString());
        } else {
          data[AppLocalizations.of(context).translate(amot![i].catname!)] =
              double.parse(amot![i].amt.toString());
        }
      }
    } else {
      totalexpense = 0;
      data = {};
    }

    if (amot1!.isNotEmpty) {
      totalincome = amot1!
          .map(
            (e) => e.amt,
          )
          .toList()
          .reduce((value, element) => value! + element!);
      for (var i = 0; i < amot1!.length; i++) {
        if (data1.keys.contains(
            AppLocalizations.of(context).translate(amot1![i].catname!))) {
          data1[AppLocalizations.of(context).translate(amot1![i].catname!)] =
              data1[AppLocalizations.of(context)
                      .translate(amot1![i].catname!)]! +
                  double.parse(amot1![i].amt.toString());
        } else {
          data1[AppLocalizations.of(context).translate(amot1![i].catname!)] =
              double.parse(amot1![i].amt.toString());
        }
        ;
      }
    } else {
      totalincome = 0;
      data1 = {};
    }
  }

  Future<dynamic> recurringsum() async {
    recexp = _userProvider.recurringpaymentsdata?.recurringpayments
        ?.where((element) {
      return element.transactiontype == 'Expense';
    }).toList();
    recinc = _userProvider.recurringpaymentsdata?.recurringpayments
        ?.where((element) {
      return element.transactiontype == 'Income';
    }).toList();

    if (recexp!.isNotEmpty) {
      totalrecurringexpense = recexp!
          .map(
            (e) => e.amount,
          )
          .toList()
          .reduce((value, element) => value! + element!);
    } else {
      totalrecurringexpense = 0;
    }
    if (recinc!.isNotEmpty) {
      totalrecurringincome = recinc!
          .map(
            (e) => e.amount,
          )
          .toList()
          .reduce((value, element) => value! + element!);
    } else {
      totalrecurringincome = 0;
    }
  }

  CarouselSliderController buttonCarouselController = CarouselSliderController();
  CarouselSliderController piecarosel = CarouselSliderController();
  CarouselSliderController recurringcarosel = CarouselSliderController();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {});
  }

  Future<void> refresh() async {
    context.readuser.getbudget();
    context.readuser.getbankdata();
    context.readuser.getbudgetsum();
    context.readuser.alltransactions();

    if (_userProvider.expensedata?.expenses == null ||
        _userProvider.expensedata!.expenses!.isEmpty) {
      totalexpense = 0;
      totalincome = 0;
      data = {};
      data1 = {};
    } else {
      expensefilter();
    }
  }

  String currentmonth = DateFormat("MMM").format(DateTime.now());

  String currentyear = DateFormat("yyyy").format(DateTime.now());

  Future<List> _showMyDialog(
      context, currentTheme, String currentmonth, currentyear) async {
    final List<String> _monthList = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    final List<String> _yearList = [];
    for (int i = 2001; i <= 2100; i++) {
      _yearList.add(i.toString());
    }

    int? _value = _monthList.indexOf(currentmonth);
    List? lst;
    lst = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              AppLocalizations.of(context).translate("Choose_month_and_year"),
              style: currentTheme.textTheme.displayLarge,
            ),
            content: Container(
              height: 250,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          AppLocalizations.of(context).translate("Choose_year"),
                          style: currentTheme.textTheme.displayMedium),
                      DropdownButton<String>(
                        underline: Container(),
                        items: _yearList.map((e) {
                          return DropdownMenuItem<String>(
                              value: e, child: Text(e));
                        }).toList(),
                        value: currentyear.toString(),
                        onChanged: (val) {
                          setState(() {
                            currentyear = val ?? "";
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  Text(AppLocalizations.of(context).translate("Choose_month"),
                      style: currentTheme.textTheme.displayMedium),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 10,
                    children: List<Widget>.generate(
                      _monthList.length,
                      (int index) {
                        return ChoiceChip(
                          selectedColor: currentTheme.primaryColor,
                          label: Text('${_monthList[index]}'),
                          selected: _value == index,
                          onSelected: (bool selected) {
                            setState(() {
                              _value = selected ? index : _value;
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child:
                        Text(AppLocalizations.of(context).translate('Cancel')),
                    onPressed: () {
                      Navigator.of(context).pop(lst = []);
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context).translate('Ok')),
                    onPressed: () {
                      Navigator.of(context).pop(lst = [
                        _monthList[_value!],
                        currentyear,
                        _value! + 1
                      ]);
                    },
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
    return lst!;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;

    if (!_userProvider.getexpensing) {
      if (_userProvider.expensedata?.expenses == null ||
          _userProvider.expensedata!.expenses!.isEmpty) {
        totalexpense = 0;
        totalincome = 0;
        data = {};
        data1 = {};
      } else {
        expensefilter();
      }
    }

    if (_userProvider.recurringpaymentsdata?.recurringpayments == null ||
        _userProvider.recurringpaymentsdata!.recurringpayments!.isEmpty) {
      totalrecurringexpense = 0;
      totalincome = 0;
    } else {
      recurringsum();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 1,
          title: Text(
            AppLocalizations.of(context).translate("Hi") +
                " ${_userProvider.userdata?.name}",
            style: TextStyle(
                color: currentTheme.canvasColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: IconButton(
                      //     onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => FaceFingerLogin(),
                      //     ));
                      //   },
                      //   icon: Icon(
                      //     Icons.notifications,
                      //     // color: Colors.white,
                      //     color: currentTheme.canvasColor,
                      //   ),
                      // ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: Center(
                      //     child: _image != null
                      //         ? CircleAvatar(
                      //             radius: 20,
                      //             backgroundImage: MemoryImage(_image!))
                      //         : CircleAvatar(
                      //             radius: 20,
                      //             backgroundColor: currentTheme.primaryColor
                      //                 .withOpacity(0.5),
                      //             child: CircleAvatar(
                      //                 radius: 25,
                      //                 backgroundColor:
                      //                     currentTheme.primaryColor,
                      //                 child: Center(
                      //                   child: IconButton(
                      //                       color: currentTheme.canvasColor,
                      //                       onPressed: () {
                      //                         Navigator.push(
                      //                             context,
                      //                             MaterialPageRoute(
                      //                               builder: (context) => Settingspage(
                      //                                   onLanguageChanged: widget
                      //                                       .onLanguageChanged),
                      //                             ));
                      //                       },
                      //                       icon: const Icon(
                      //                         Icons.person,
                      //                       )),
                      //                 )),
                      //           ),
                      //   ),
                      // ),
                    ]),
              ),
            ],
          ),
          backgroundColor: currentTheme.appBarTheme.backgroundColor,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          color: currentTheme.primaryColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  _userProvider.getbanking
                      ? ListTile(
                          title: ShimmerWidget.rectangular(
                            height: 60,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Accounts(
                                      onLanguageChanged:
                                          widget.onLanguageChanged),
                                ));
                          },
                          child: Container(
                              height: 60,
                              // width: MediaQuery.of(context).size.width / 1.1,
                              decoration: BoxDecoration(
                                  color: currentTheme.canvasColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _userProvider.bankdata?.banks != null &&
                                            _userProvider
                                                .bankdata!.banks!.isNotEmpty
                                        ? _userProvider
                                                    .bankdata!.banks!.length ==
                                                1
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(_userProvider
                                                            .bankdata!
                                                            .banks!
                                                            .first
                                                            .bankname!),
                                                    style: _userProvider
                                                                .userdata
                                                                ?.language ==
                                                            'Tamil'
                                                        ? TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold)
                                                        : currentTheme.textTheme
                                                            .displayMedium,
                                                  ),
                                                  Text(
                                                    '${_userProvider.currency} '
                                                    '${commaSepartor(_userProvider.bankdata!.banks!.first.acbalance ?? 0)}',
                                                    style: _userProvider
                                                                .userdata
                                                                ?.language !=
                                                            'Tamil'
                                                        ? currentTheme.textTheme
                                                            .bodyMedium
                                                        : TextStyle(
                                                            fontSize: 12),
                                                  ),
                                                ],
                                              )
                                            : CarouselSlider.builder(
                                                itemCount: _userProvider
                                                    .bankdata?.banks?.length,
                                                itemBuilder: (context, index,
                                                        realIndex) =>
                                                    Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          buttonCarouselController
                                                              .previousPage(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .linear);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_left_outlined,
                                                          color: currentTheme
                                                              .primaryColor,
                                                        )),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              _userProvider
                                                                  .bankdata!
                                                                  .banks![index]
                                                                  .bankname!),
                                                      style: _userProvider
                                                                  .userdata
                                                                  ?.language ==
                                                              'Tamil'
                                                          ? TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)
                                                          : TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      '${_userProvider.currency} '
                                                      '${commaSepartor(_userProvider.bankdata!.banks![index].acbalance ?? 0)}',
                                                      style: _userProvider
                                                                  .userdata
                                                                  ?.language !=
                                                              'Tamil'
                                                          ? currentTheme
                                                              .textTheme
                                                              .bodyMedium
                                                          : TextStyle(
                                                              fontSize: 12),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          buttonCarouselController
                                                              .nextPage(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .linear);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_right_outlined,
                                                          color: currentTheme
                                                              .primaryColor,
                                                        )),
                                                  ],
                                                ),
                                                carouselController:
                                                    buttonCarouselController,
                                                options: CarouselOptions(
                                                  height: 50,
                                                  autoPlay: false,
                                                  enlargeCenterPage: true,
                                                  viewportFraction: 1.005,
                                                  aspectRatio: 2.0,
                                                  // initialPage: 0,
                                                ),
                                              )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        "add_new_account"),
                                                style: currentTheme
                                                    .textTheme.displayMedium,
                                              ),
                                              if (!_userProvider.userid!
                                                  .contains('S_')) ...[
                                                CircleAvatar(
                                                  // radius: 16,
                                                  backgroundColor:
                                                      currentTheme.primaryColor,
                                                  child: IconButton(
                                                    color: currentTheme
                                                        .canvasColor,
                                                    // iconSize: 22,
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ChooseBank(
                                                                        onLanguageChanged:
                                                                            widget.onLanguageChanged,
                                                                      )));
                                                    },
                                                  ),
                                                ),
                                              ]
                                            ],
                                          )
                                  ])),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  !_userProvider.getbudgeting
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Budgetview(
                                      onLanguageChanged:
                                          widget.onLanguageChanged),
                                ));
                          },
                          child: Container(
                            height: 120,
                            // width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                              color: currentTheme.canvasColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: currentTheme.primaryColor,
                                    radius: 20,
                                    child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 16,
                                      child: Image.asset(
                                        "assets/images/database.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("monthly_budget"),
                                              style: currentTheme
                                                  .textTheme.displayMedium,
                                            ),
                                          ),
                                          // SizedBox(
                                          //     width: _userProvider
                                          //                 .userdata?.language ==
                                          //             'Tamil'
                                          //         ? MediaQuery.of(context)
                                          //                 .size
                                          //                 .width /
                                          //             7
                                          //         : MediaQuery.of(context)
                                          //                 .size
                                          //                 .width /
                                          //             3),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MonthlyBudget(
                                                                onLanguageChanged:
                                                                    widget
                                                                        .onLanguageChanged)));
                                              },
                                              icon: Icon(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  Icons.more_horiz_sharp))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        '${_userProvider.currency} '
                                        '${commaSepartor(_userProvider.totalbudget ?? 0)}',
                                        style:
                                            currentTheme.textTheme.displayLarge,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: LinearPercentIndicator(
                                        // width:
                                        //     MediaQuery.of(context).size.width /
                                        //         1.4,
                                        barRadius: const Radius.circular(8),
                                        backgroundColor: Colors.grey,
                                        lineHeight: 6.0,
                                        percent: _userProvider.percent ?? 0.0,
                                        progressColor:
                                            currentTheme.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context).translate("spent")} : ${_userProvider.currency} ${commaSepartor(_userProvider.spent ?? 0)}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          // SizedBox(
                                          //     width: _userProvider
                                          //                 .userdata?.language ==
                                          //             'Tamil'
                                          //         ? 8
                                          //         : MediaQuery.of(context)
                                          //                 .size
                                          //                 .width /
                                          //             5),
                                          Text(
                                              AppLocalizations.of(context)
                                                      .translate("left") +
                                                  ' : ${_userProvider.currency}  ${commaSepartor(_userProvider.left ?? 0)}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    )
                                  ],
                                ),
                              )
                            ]),
                          ),
                        )
                      : ListTile(
                          title: ShimmerWidget.rectangular(
                            height: 120,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  _userProvider.getexpensing
                      ? ListTile(
                          title: ShimmerWidget.rectangular(
                            height: data.length < 8
                                ? 300
                                : data.length < 14
                                    ? 410
                                    : 475,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        )
                      : Container(
                          height: data.length < 8
                              ? 300
                              : data.length < 14
                                  ? 410
                                  : 475,
                          // width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                            color: currentTheme.canvasColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CarouselSlider.builder(
                                  itemCount: 2,
                                  itemBuilder: (context, index, realIndex) =>
                                      Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _userProvider.userdata?.language ==
                                                    'Tamil'
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${AppLocalizations.of(context).translate(index == 1 ? "top_categories" : "top_categories_income")} ',
                                                        style: currentTheme
                                                            .textTheme
                                                            .displayMedium,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          List<dynamic> choose =
                                                              await _showMyDialog(
                                                                  context,
                                                                  currentTheme,
                                                                  currentmonth,
                                                                  currentyear);

                                                          print(choose);
                                                          if (choose
                                                              .isNotEmpty) {
                                                            setState(() {
                                                              currentmonth =
                                                                  choose[0];
                                                              currentyear =
                                                                  choose[1];
                                                            });

                                                            await expensefilter();
                                                          }
                                                        },
                                                        child: Container(
                                                            height: 30,
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .blue
                                                                    .withOpacity(
                                                                        0.2)),
                                                            child: Center(
                                                              child: Text(
                                                                '${AppLocalizations.of(context).translate(currentmonth)} ${currentyear}',
                                                                style: TextStyle(
                                                                    color: currentTheme
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  )
                                                : Text(
                                                    '${AppLocalizations.of(context).translate(index == 1 ? "top_categories" : "top_categories_income")}',
                                                    style: currentTheme
                                                        .textTheme
                                                        .displayMedium,
                                                  ),
                                            if (_userProvider
                                                    .userdata?.language !=
                                                'Tamil') ...[
                                              InkWell(
                                                onTap: () async {
                                                  List<dynamic> choose =
                                                      await _showMyDialog(
                                                          context,
                                                          currentTheme,
                                                          currentmonth,
                                                          currentyear);

                                                  print(choose);
                                                  if (choose.isNotEmpty) {
                                                    setState(() {
                                                      currentmonth = choose[0];
                                                      currentyear = choose[1];
                                                    });

                                                    await expensefilter();
                                                  }
                                                },
                                                child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.blue
                                                            .withOpacity(0.2)),
                                                    child: Center(
                                                      child: Text(
                                                        '${AppLocalizations.of(context).translate(currentmonth)} ${currentyear}',
                                                        style: TextStyle(
                                                            color: currentTheme
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                    )),
                                              )
                                            ]
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IncExpView(
                                                        onLanguageChanged: widget
                                                            .onLanguageChanged,
                                                        currentmonth:
                                                            currentmonth,
                                                        currentyear:
                                                            currentyear,
                                                        ttype: index == 1
                                                            ? "Expense"
                                                            : "Income",
                                                      )));
                                        },
                                        child: PieChart(
                                          colorList: colorList,
                                          dataMap: index == 1
                                              ? data.isNotEmpty
                                                  ? data
                                                  : {
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Nil'): 0.0
                                                    }
                                              : data1.isNotEmpty
                                                  ? data1
                                                  : {
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Nil'): 0.0
                                                    },
                                          chartLegendSpacing: 25,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          legendOptions: LegendOptions(
                                              legendPosition:
                                                  LegendPosition.right,
                                              legendTextStyle: _userProvider
                                                          .userdata?.language ==
                                                      'Tamil'
                                                  ? TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : defaultLegendStyle),
                                          // : LegendOptions(
                                          //     showLegends: false,
                                          //   ),
                                          chartValuesOptions:
                                              const ChartValuesOptions(
                                            showChartValues: false,
                                            // showChartValueBackground: true,
                                            // showChartValuesInPercentage: true,
                                            // showChartValuesOutside: true,
                                          ),
                                          chartType: ChartType.ring,
                                          ringStrokeWidth: 10,
                                          centerWidget: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(index == 1
                                                        ? "expenses"
                                                        : "incomes"),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                '${_userProvider.currency} ${index == 1 ? commaSepartor(totalexpense ?? 0) : commaSepartor(totalincome ?? 0)}',
                                                style: currentTheme
                                                    .textTheme.displayMedium,
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                  carouselController: piecarosel,
                                  options: CarouselOptions(
                                      height: data.length < 8
                                          ? 260
                                          : data.length < 14
                                              ? 410
                                              : 475,
                                      autoPlay: true,
                                      enlargeCenterPage: true,
                                      viewportFraction: 1.005,
                                      aspectRatio: 2.0,
                                      initialPage: 1,
                                      autoPlayInterval:
                                          const Duration(seconds: 30)),
                                ),
                              ]),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 60,
                      // width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          color: currentTheme.canvasColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CarouselSlider.builder(
                            itemCount: 2,
                            itemBuilder: (context, index, realIndex) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => RecurringView(onLanguageChanged: widget.onLanguageChanged, ttype: index==1?"Expense":"Income"),));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
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
                                        child: Icon(     Icons.refresh,
                                        color: Colors.black,)
                                      ),
                                    ),
                                  ),
                                                                ),
                                          Text(
                                            '${AppLocalizations.of(context).translate(index == 1 ? "total_recurring_Expense" : "total_recurring_income")} ',
                                            style:
                                                currentTheme.textTheme.displayMedium,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 25),
                                        child: Text(
                                            '${_userProvider.currency} '
                                            '${commaSepartor(index == 1 ? totalrecurringexpense??0 : totalrecurringincome??0)}',
                                            style:
                                                currentTheme.textTheme.displayMedium),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            carouselController: recurringcarosel,
                            options: CarouselOptions(
                                height: 60,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1.005,
                                aspectRatio: 2.0,
                                initialPage: 1,
                                autoPlayInterval: const Duration(seconds: 30)),
                          ),
                        ],
                      )),
                      const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Invoiceview(
                                            onLanguageChanged:
                                                widget.onLanguageChanged),
                                      ));
                    },
                    child: Container(
                        height: 60,
                        // width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          color: currentTheme.canvasColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                        child: Icon(Icons.image_outlined,color: Colors.black,)
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("Myinvoice"),
                                      style:
                                          currentTheme.textTheme.displayMedium,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Invoiceview(
                                            onLanguageChanged:
                                                widget.onLanguageChanged),
                                      ));
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: currentTheme.primaryColor,
                                ))
                          ],
                        )),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalsView(
                                onLanguageChanged: widget.onLanguageChanged),
                          ));
                    },
                    child: Container(
                        height: 60,
                        // width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          color: currentTheme.canvasColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                        child: Image.asset(
                                          "assets/images/bulb.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("my_goals"),
                                      style:
                                          currentTheme.textTheme.displayMedium,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)
                                            .translate("add_new_goal"),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12))
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GoalDetails(
                                            onLanguageChanged:
                                                widget.onLanguageChanged),
                                      ));
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: currentTheme.primaryColor,
                                ))
                          ],
                        )),
                  ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => DebtView(
                  //               onLanguageChanged:
                  //                   widget.onLanguageChanged),
                  //         ));
                  //   },
                  //   child: Container(
                  //       height: 60,
                  //       width: MediaQuery.of(context).size.width / 1.1,
                  //       decoration: BoxDecoration(
                  //         color: currentTheme.canvasColor,
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment:
                  //             MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 10.0),
                  //                 child: SizedBox(
                  //                   width: 40,
                  //                   child: CircleAvatar(
                  //                     backgroundColor:
                  //                         currentTheme.primaryColor,
                  //                     radius: 20,
                  //                     child: CircleAvatar(
                  //                       backgroundColor:
                  //                           currentTheme.canvasColor,
                  //                       radius: 16,
                  //                       child: Image.asset(
                  //                         height: 20,
                  //                         "assets/images/hand.png",
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Column(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.center,
                  //                 crossAxisAlignment:
                  //                     CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     AppLocalizations.of(context)
                  //                         .translate("Debts"),
                  //                     style: currentTheme
                  //                         .textTheme.displayMedium,
                  //                   ),
                  //                   SizedBox(
                  //                     height: 5,
                  //                   ),
                  //                   Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("add_new_debt"),
                  //                       style: const TextStyle(
                  //                           color: Colors.grey,
                  //                           fontSize: 12))
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //           IconButton(
                  //               onPressed: () {
                  //                 Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                       builder: (context) => DebtDetail(
                  //                           onLanguageChanged:
                  //                               widget.onLanguageChanged),
                  //                     ));
                  //               },
                  //               icon: Icon(
                  //                 Icons.add,
                  //                 color: currentTheme.primaryColor,
                  //               ))
                  //         ],
                  //       )),
                  // ),

                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          //  )
          //   ]),
        ),
      ),
    );
  }
}
