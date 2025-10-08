import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/categories/catrgories.dart';
import 'package:billfold/categories/subcatmodel.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubcatExpensepage extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;

  String catname;
  String transactiontype;
  int catid;

  SubcatExpensepage(
      {super.key,
      required this.catname,
      required this.transactiontype,
      required this.catid,
      required this.onLanguageChanged});

  @override
  State<SubcatExpensepage> createState() => _SubcatExpensepageState();
}

class _SubcatExpensepageState extends State<SubcatExpensepage> {
  List<TextEditingController> _controllers = [];
  DateTime? selectedDate;
  DateTime currentdate = DateTime.now();

  DateTime now = DateTime.now();
  DateTime enddate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  DateTime? nextoccurance;

  bool recurring = false;
  List<Subcategory>? subcategories;

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
    "Savings & Investments": "assets/images/return-on-investment.png",
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

  TextEditingController note = TextEditingController();

  void _initializeControllers() {
    for (var i = 0; i < subcategories!.length; i++) {
      _controllers.add(TextEditingController());
    }
  }

  late UserProvider _userProvider;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  List<Bank> bank = [];
  List<String>? list;
  String? dropdownvalue;
  int? acid;

  List<String> recurringlist = [
    "Monthly",
    "Quarterly",
    "Half yearly",
    "Yearly"
  ];

  nextoccur(freqency) {
    if (freqency == "Monthly") {
      nextoccurance = DateTime(currentdate.year, currentdate.month + 1,
          int.parse(defreccurringdate));
    } else if (freqency == "Quarterly") {
      nextoccurance = DateTime(currentdate.year, currentdate.month + 3,
          int.parse(defreccurringdate));
    } else if (freqency == "Half yearly") {
      nextoccurance = DateTime(currentdate.year, currentdate.month + 6,
          int.parse(defreccurringdate));
    } else if (freqency == "Yearly") {
      nextoccurance = DateTime(currentdate.year + 1, currentdate.month,
          int.parse(defreccurringdate));
    }
    print(nextoccurance);
  }

  String? defreccurring;

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
  String defreccurringdate =
      DateTime.now().day < 29 ? DateTime.now().day.toString() : "28";

  Future<void> selectDate(BuildContext context) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("recurring_warng"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(
              AppLocalizations.of(context).translate("recurring_warngbody"),
              style: currentTheme.textTheme.bodyMedium),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Future<void> selectendDate(BuildContext context) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: enddate,
      firstDate: nextoccurance!,
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

  Future<void> subcategoriesapi(int? catid) async {
    list = _userProvider.bankdata!.banks!.map((e) => e.bankname!).toList();

    dropdownvalue = list!.first;

    if (_userProvider.bankdata != null &&
        _userProvider.bankdata!.banks!.isNotEmpty) {
      bank = _userProvider.bankdata!.banks!.where((element) {
        return element.acid == acid;
      }).toList();
    }

    subcategories = _userProvider.subcategorydata?.subcategories?.where(
      (element) {
        return element.categoryid == widget.catid;
      },
    ).toList();
    _initializeControllers();
  }

  insertexpense(transactiontype, amt, description, date, catid, subcatid, acid,
      merchant, location, currency, exchangerate, receptpath, note) async {
    await context.readuser.insertexpense(
        transactiontype,
        amt,
        description,
        date,
        catid,
        subcatid,
        acid,
        merchant,
        location,
        currency,
        exchangerate,
        receptpath,
        note);
  }

  insertrecurringpayments(amount, acid, catid, subcatid, frequency, startdate,
      enddate, nextoccurance, status, note) async {
    await context.readuser.insertrecurringpayments(amount, acid, catid,
        subcatid, frequency, startdate, enddate, nextoccurance, status, note);
  }

  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    _userProvider = context.watchuser;

    if (_userProvider.bankdata != null) {
      if (dropdownvalue == null) {
        subcategoriesapi(widget.catid);
      }
      if (_userProvider.bankdata!.banks!.isNotEmpty) {
        var acts = _userProvider.bankdata!.banks!.where((element) {
          return element.bankname == dropdownvalue;
        }).toList();
        acid = acts.first.acid;
        bank = _userProvider.bankdata!.banks!.where((element) {
          return element.acid == acid;
        }).toList();
      }
      if (defreccurring == null) {
        defreccurring = recurringlist.first;
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.canvasColor,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate("Add") +
                ' ' +
                AppLocalizations.of(context).translate(widget.transactiontype),
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: currentTheme.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    catimages[widget.catname] ??
                        "assets/images/category.png", // Replace with your asset path
                    width: 40,
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(
                      AppLocalizations.of(context).translate(widget.catname),
                      style: currentTheme.textTheme.displayLarge,
                    ),
                  ),
                ],
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
                        AppLocalizations.of(context).translate("Date"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        !recurring ? selectDate(context) : {};
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          DateFormat('dd-MM-yyyy')
                              .format(currentdate)
                              .toString(),
                          style: TextStyle(
                              color: currentTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ))
                ],
              ),
              Divider(
                thickness: 0.2,
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
              Divider(
                thickness: 0.2,
              ),
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
                          child: Icon(
                            Icons.notes_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: TextFormField(
                      controller: note,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)
                              .translate("add_notes"),
                          hintStyle: currentTheme.textTheme.displayMedium),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0.2,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  if (subcategories!.isNotEmpty)
                    for (var i = 0; i < subcategories!.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate(
                                      subcategories![i].subcategoryname!),
                                  style: _userProvider.userdata?.language ==
                                          'Tamil'
                                      ? currentTheme.textTheme.displayMedium
                                      : currentTheme.textTheme.displayLarge,
                                ),
                                Form(
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                    child: TextFormField(
                                      controller: _controllers[i],
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: '${_userProvider.currency} 0',
                                        border: InputBorder.none,
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 2,
                            )
                          ],
                        ),
                      ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Usercategories(
                                      onLanguageChanged:
                                          widget.onLanguageChanged,
                                      categoryname: widget.catname,
                                      catid: widget.catid)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.add,
                              color: currentTheme.primaryColor,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("add_subcategory"),
                              style: TextStyle(
                                color: currentTheme.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: SizedBox(
                                width: 35,
                                child: CircleAvatar(
                                  backgroundColor: currentTheme.primaryColor,
                                  radius: 20,
                                  child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 14.5,
                                      child: Icon(
                                        Icons.refresh,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Text(
                                AppLocalizations.of(context)
                                    .translate("make_recurring"),
                                style: currentTheme.textTheme.displayMedium),
                          ],
                        ),
                        Switch(
                            value: recurring,
                            activeColor: currentTheme.primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                recurring = value;
                                if (value) {
                                  Future.delayed(Duration.zero,
                                      () => (nextoccur(defreccurring)));
                                }
                              });
                            })
                      ],
                    ),
                  ),
                  if (recurring) ...[
                    Divider(
                      thickness: 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                            onChanged: (String? newValue) async {
                              setState(() {
                                defreccurringdate = newValue!;
                              });

                              if (defreccurringdate !=
                                  DateTime.now().day.toString()) {
                                bool returnvale =
                                    await _showMyDialog(context, currentTheme);
                                    if (!returnvale) {
                                      setState(() {
                                defreccurringdate =   DateTime.now().day < 29 ? DateTime.now().day.toString() : "28";
                              });
                                    }
                              }
                              
                              await nextoccur(defreccurring);
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
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
                              AppLocalizations.of(context)
                                  .translate("Frequency"),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                                  .translate("end_date"),
                              style: currentTheme.textTheme.displayMedium,
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () async {
                              await nextoccur(defreccurring);
                              selectendDate(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(enddate)
                                    .toString(),
                                style: TextStyle(
                                    color: currentTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ))
                      ],
                    ),
                    Divider(
                      thickness: 0.2,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 40),
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
                            List<String> values = _controllers
                                .map((controller) => controller.text)
                                .toList();

                            if (values.isNotEmpty &&
                                values.any((element) =>
                                    element.isNotEmpty && element != '0') &&
                                _userProvider.bankdata!.banks!.isNotEmpty) {
                              for (var i in values) {
                                if (i.isNotEmpty) {
                                  print(i.indexOf(i));
                                  insertexpense(
                                      widget.transactiontype,
                                      num.parse(i),
                                      widget.catname,
                                      DateFormat('yyyy-MM-dd')
                                          .format(currentdate)
                                          .toString(),
                                      widget.catid,
                                      subcategories![values.indexOf(i)]
                                          .subcategoryid,
                                      acid ?? 0,
                                      'merchant',
                                      'location',
                                      _userProvider.currency,
                                      0,
                                      '/path.jpg',
                                      note.text);
                                  if (bank.isNotEmpty &&
                                      widget.transactiontype == "Expense") {
                                    updatebank(
                                        bank.first.acid,
                                        "${bank.first.actype} account",
                                        bank.first.actype,
                                        bank.first.bankname,
                                        num.parse(bank.first.acnumber!),
                                        bank.first.acbalance! - num.parse(i),
                                        bank.first.ishidden);
                                  } else if (bank.isNotEmpty &&
                                      widget.transactiontype == "Income") {
                                    updatebank(
                                        bank.first.acid,
                                        "${bank.first.actype} account",
                                        bank.first.actype,
                                        bank.first.bankname,
                                        num.parse(bank.first.acnumber!),
                                        bank.first.acbalance! + num.parse(i),
                                        bank.first.ishidden);
                                  }
                                  if (recurring) {
                                    insertrecurringpayments(
                                        num.parse(i),
                                        acid,
                                        widget.catid,
                                        subcategories![values.indexOf(i)]
                                            .subcategoryid,
                                        defreccurring,
                                        DateFormat('yyyy-MM-dd')
                                            .format(currentdate)
                                            .toString(),
                                        DateFormat('yyyy-MM-dd')
                                            .format(enddate)
                                            .toString(),
                                        DateFormat('yyyy-MM-dd')
                                            .format(nextoccurance ?? enddate)
                                            .toString(),
                                        "Active",
                                        note.text);
                                  }
                                }
                              }
                              final snackBar = SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text(AppLocalizations.of(context)
                                      .translate("expense_validation_success")),
                                  backgroundColor: Colors.green);

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pop(context);
                            } else {
                              final snackBar = SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(AppLocalizations.of(context)
                                      .translate(_userProvider
                                              .bankdata!.banks!.isNotEmpty
                                          ? "budget_validation"
                                          : "bankvalidation")),
                                  backgroundColor: Colors.red);

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
