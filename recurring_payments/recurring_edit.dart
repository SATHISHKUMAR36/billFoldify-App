import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class RecurringEdit extends StatefulWidget {
  num recurringid;
  num catid;
  num subcatid;
  num acid;
  String defreccurringdate;
  String catname;
  String subcatname;
  num amount;
  String bankname;
  String frequency;
  String startdate;
  String enddate;
  String nextoccuring;
  String status;
  String note;

  final void Function(Locale) onLanguageChanged;

  RecurringEdit(
      {super.key,
      required this.catname,
      required this.acid,
      required this.subcatname,
      required this.amount,
      required this.recurringid,
      required this.catid,
      required this.startdate,
      required this.subcatid,
      required this.onLanguageChanged,
      required this.bankname,
      required this.enddate,
      required this.nextoccuring,
      required this.frequency,
      required this.status,
      required this.note,
      required this.defreccurringdate});

  @override
  State<RecurringEdit> createState() => _ExpenseEditState();
}

class _ExpenseEditState extends State<RecurringEdit> {
  List<Bank> bank = [];
  String? defreccurringdate;
  List<Bank> widgetbank = [];
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController amount = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    amount.text = widget.amount.toString();
    super.initState();
    currentdate = DateTime.parse(widget.startdate);
    enddate = DateTime.parse(widget.enddate);

    defreccurringdate = widget.defreccurringdate;
    dropdownvalue = widget.bankname;
    defreccurring = widget.frequency;
    nextoccurance = DateTime.parse(widget.nextoccuring);
  }

  updaterecurring(recurringid, amount, acid, catid, subcatid, frequency,
      startdate, enddate, nextoccurance, status, note) async {
    await _userProvider.updaterecurringpayments(
        recurringid,
        amount,
        acid,
        catid,
        subcatid,
        frequency,
        startdate,
        enddate,
        nextoccurance,
        status,
        note);
  }

  DateTime? selectedDate;
  DateTime? currentdate;
  DateTime? enddate;
  List<String>? list;

  String? dropdownvalue;
  List<String> recurringlist = [
    "Monthly",
    "Quarterly",
    "Half yearly",
    "Yearly"
  ];
  List<String> paymentdatelist = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28"
  ];
  DateTime? nextoccurance;

  nextoccur(freqency) {
    if (freqency == "Monthly") {
      nextoccurance = DateTime(currentdate!.year, currentdate!.month + 1,
          int.parse(defreccurringdate!));
    } else if (freqency == "Quarterly") {
      nextoccurance = DateTime(currentdate!.year, currentdate!.month + 3,
          int.parse(defreccurringdate!));
    } else if (freqency == "Half yearly") {
      nextoccurance = DateTime(currentdate!.year, currentdate!.month + 6,
          int.parse(defreccurringdate!));
    } else if (freqency == "Yearly") {
      nextoccurance = DateTime(currentdate!.year + 1, currentdate!.month,
          int.parse(defreccurringdate!));
    }
  }

  String? defreccurring;

  int? acid;
  late UserProvider _userProvider;
  @override
  Widget build(BuildContext context) {
    //  DateTime? currentdate = DateTime.parse(widget.startdate);
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    _userProvider = context.watchuser;
    if (_userProvider.bankdata != null) {
      if (_userProvider.bankdata!.banks!.isNotEmpty) {
        var acts = _userProvider.bankdata!.banks!.where((element) {
          return element.bankname == dropdownvalue;
        });
        acid = acts.first.acid;
        bank = _userProvider.bankdata!.banks!.where((element) {
          return element.acid == acid;
        }).toList();

        widgetbank = _userProvider.bankdata!.banks!.where((element) {
          return element.acid == widget.acid;
        }).toList();

        list = _userProvider.bankdata!.banks!.map((e) => e.bankname!).toList();
      }
    }

    Future<void> selectDate(BuildContext context) async {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: currentdate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue, // header background color
              ),
            ),
            child: child!,
          );
        },
      );
      setState(() {
        currentdate = selectedDate ?? DateTime.now();
      });
    }

    Future<void> selectendDate(BuildContext context) async {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: enddate,
        firstDate: DateTime.parse(widget.nextoccuring),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue, // header background color
              ),
            ),
            child: child!,
          );
        },
      );
      setState(() {
        enddate = selectedDate ?? DateTime.now();
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.canvasColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate("edit_recurring"),
            style: TextStyle(
                color: currentTheme.canvasColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      catimages[widget.catname] ?? "assets/images/category.png",
                      width: 40,
                      height: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).translate(widget.catname),
                      style: currentTheme.textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate(widget.subcatname),
                      style: currentTheme.textTheme.displayMedium,
                    ),
                    Form(
                      key: _formKey,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: currentTheme.primaryColor,
                                      width: 3))),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                // width: MediaQuery.of(context).size.width / 4,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: amount,
                                  decoration: InputDecoration(
                                      border: InputBorder.none, hintText: "0"),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                                  ],
                                  validator: (value) {
                                    var availableValue = value ?? '';
                                    if (availableValue.isEmpty) {
                                      return ("Enter Valid Amount!");
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          width: 35,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                                backgroundColor: currentTheme.canvasColor,
                                radius: 15,
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                  size: 25,
                                )),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate("Createdate"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        // selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                          DateFormat('dd-MM-yyyy')
                              .format(currentdate ?? DateTime.now())
                              .toString(),
                          style: TextStyle(
                              // color: currentTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          width: 35,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                              backgroundColor: currentTheme.canvasColor,
                              radius: 15,
                              child: Image.asset(
                                height: 20,
                                "assets/images/bank.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("Select_account"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  list != null
                      ? DropdownButton(
                          // Initial Value
                          value: dropdownvalue,

                          // Down Arrow Icon
                          icon: Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: list!.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              dropdownvalue ??
                                  AppLocalizations.of(context).translate("Nil"),
                              style: currentTheme.textTheme.displayMedium),
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          width: 35,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                                backgroundColor: currentTheme.canvasColor,
                                radius: 15,
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                  size: 25,
                                )),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("Recurring_date"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: DropdownButton(
                      // Initial Value
                      value: defreccurringdate,

                      // Down Arrow Icon
                      icon: Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: paymentdatelist.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          defreccurringdate = newValue!;
                          // nextoccur(defreccurring);

                          Future.delayed(
                              Duration.zero, () => (nextoccur(defreccurring)));
                        });
                      },
                    ),
                  )
                ],
              ),
              Divider(
                thickness: 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          width: 35,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                                backgroundColor: currentTheme.canvasColor,
                                radius: 14.5,
                                child: Icon(
                                  Icons.cached,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate("Frequency"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: DropdownButton(
                      // Initial Value
                      value: defreccurring,

                      // Down Arrow Icon
                      icon: Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: recurringlist.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          nextoccur(newValue);
                          defreccurring = newValue;
                        });
                      },
                    ),
                  )
                ],
              ),
              Divider(
                thickness: 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          width: 35,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                                backgroundColor: currentTheme.canvasColor,
                                radius: 15,
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                  size: 25,
                                )),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("Next_Occurance"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        // selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                          DateFormat('dd-MM-yyyy')
                              .format(nextoccurance ?? DateTime.now())
                              .toString(),
                          style: TextStyle(
                              // color: currentTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ))
                ],
              ),
              Divider(
                thickness: 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          width: 35,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                                backgroundColor: currentTheme.canvasColor,
                                radius: 15,
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                  size: 25,
                                )),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate("end_date"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        selectendDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                          DateFormat('dd-MM-yyyy')
                              .format(enddate ?? DateTime.now())
                              .toString(),
                          style: TextStyle(
                              color: currentTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: currentTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate("Submit"),
                          style: TextStyle(
                            color: currentTheme.canvasColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (num.parse(amount.text) != widget.amount ||
                              acid != widget.acid ||
                              DateTime.parse(widget.enddate) != (enddate) ||
                              defreccurring != widget.frequency ||
                              defreccurringdate != widget.defreccurringdate) {
                            context.loaderOverlay.show();
                            try {
                              updaterecurring(
                                  widget.recurringid,
                                  num.parse(amount.text),
                                  acid,
                                  widget.catid,
                                  widget.subcatid,
                                  defreccurring,
                                  widget.startdate,
                                  DateFormat('yyyy-MM-dd')
                                      .format(enddate!)
                                      .toString(),
                                  DateFormat('yyyy-MM-dd')
                                      .format(nextoccurance!)
                                      .toString(),
                                  widget.status,
                                  widget.note);
                            } finally {
                              context.loaderOverlay.hide();
                              final snackBar = SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(AppLocalizations.of(context)
                                      .translate("expense_validation_success")),
                                  backgroundColor: Colors.green);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              Navigator.pop(context);

                              // TODO
                            }
                          } else {
                            final snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(AppLocalizations.of(context)
                                    .translate("save_validation")),
                                backgroundColor: Colors.red);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
