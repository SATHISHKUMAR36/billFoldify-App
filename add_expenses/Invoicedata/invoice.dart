import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/categories/subcatmodel.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class InvoiceData extends StatefulWidget {
  String imagepath;

  InvoiceData({
    super.key,
    required this.imagepath,
  });

  @override
  State<InvoiceData> createState() => _InvoiceDataState();
}

class _InvoiceDataState extends State<InvoiceData> {
  List<Subcategory>? subcategories;

  DateTime? selectedDate;
  DateTime? currentdate = DateTime.now();

  int? catid;
  int? subcatid;
  List<Bank> bank = [];
  List<String>? list;
  String? dropdownvalue;
  int? acid;
  late UserProvider _userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  subid() {
    if (_userProvider.subcategorydata?.subcategories != null &&
        _userProvider.invoicedata?.subcategory != null) {
      var other =
          _userProvider.subcategorydata!.subcategories!.where((element) {
        return element.subcategoryname ==
            _userProvider.invoicedata!.subcategory;
      }).toList();

      if (other.isNotEmpty) {
        subcatid = other.first.subcategoryid!;
      } else {
        subcatid = subcategories!.last.subcategoryid!;
      }
    } else {
      subcatid = subcategories!.last.subcategoryid!;
    }
  }

  insertinvoiceitems(transactionid, items) async {
    await context.read<UserProvider>().insertinvoiceitems(transactionid, items);
  }

  invoiceapi(image_path) async {
    await context.read<UserProvider>().getinvoice(image_path);
    _userProvider.invoicedata = context.readuser.invoicedata;

    if (_userProvider.categorydata?.categories != null &&
        _userProvider.invoicedata!.invoice_data!) {
      currentdate = DateFormat("MM/dd/yyyy")
          .parse(_userProvider.invoicedata?.date ?? DateTime.now().toString());
      var other = _userProvider.categorydata!.categories!.where((element) {
        return element.categoryname == _userProvider.invoicedata!.category;
      }).toList();

      if (other.isNotEmpty) {
        catid = other.first.categoryid!;
        subcategoriesapi(catid);
      } else {
        var other = _userProvider.categorydata!.categories!.where((element) {
          return element.categoryname == 'Miscellaneous';
        });

        catid = other.first.categoryid!;
        subcategoriesapi(catid);
      }
    } else {
      final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text(AppLocalizations.of(context)
              .translate("transactrion_validation")),
          backgroundColor: Colors.red);

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context);
    }
  }

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

  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  Future<void> subcategoriesapi(int? catid) async {
    subcategories =
        _userProvider.subcategorydata?.subcategories?.where((element) {
      return element.categoryid == catid;
    }).toList();

    if (_userProvider.bankdata != null &&
        _userProvider.bankdata!.banks!.isNotEmpty) {
      bank = _userProvider.bankdata!.banks!.where((element) {
        return element.acid == acid;
      }).toList();
    }
  }

  insertexpense(transactiontype, amt, description, date, catid, subcatid, acid,
      merchant, location, currency, exchangerate, receptpath, note) async {
    await context.read<UserProvider>().insertexpense(
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
    'Rent': "assets/images/rent.png",  'BankStatement':"assets/images/bankstatement.png"
  };

  dateformat(String date) {
    try {
      date = date.replaceAll('-', '/');
      List split_date = date.split('/');

      if (int.parse(split_date[0]) > 12 && int.parse(split_date[1]) < 13) {
        DateTime outdate = DateFormat('dd/MM/yyyy').parse(date);
        if (outdate.year < 100) {
          return DateTime(outdate.year + 2000, outdate.month, outdate.day);
        } else {
          return outdate;
        }
      } else {
        DateTime outdate = DateFormat('MM/dd/yyyy').parse(date);
        if (outdate.year < 100) {
          return DateTime(outdate.year + 2000, outdate.month, outdate.day);
        } else {
          return outdate;
        }
      }
    } catch (e) {
      print("dateformat Error in INVOICE");
      return DateTime.now();
    }
  }

  filterdata() {
    var filterdata = [];
    for (var i = 0; i < _userProvider.expensedata!.expenses!.length; i++) {
      if (_userProvider.expensedata!.expenses![i].catname
                  .toString()
                  .toLowerCase() ==
              _userProvider.invoicedata!.category.toString().toLowerCase() &&
          _userProvider.expensedata!.expenses![i].subcatname
                  .toString()
                  .toLowerCase() ==
              _userProvider.invoicedata!.subcategory.toString().toLowerCase() &&
          _userProvider.expensedata!.expenses![i].amt.toString() ==
              _userProvider.invoicedata!.amt.toString() &&
          _userProvider.expensedata!.expenses![i].date ==
              DateFormat('yyyy-MM-dd')
                  .format(dateformat(_userProvider.invoicedata!.date!))) {
        filterdata.add(_userProvider.expensedata!.expenses![i]);
      }
    }
    if (filterdata.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)
                .translate("Duplicate_transaction_found"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(AppLocalizations.of(context).translate("not_enter"),
              style: currentTheme.textTheme.bodyMedium),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
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

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
    if (dropdownvalue == null) {
      invoiceapi(widget.imagepath);
      if (_userProvider.bankdata?.banks == null ||
          _userProvider.bankdata!.banks!.isEmpty) {
        list = <String>[];
        acid = 0;
      } else {
        list = _userProvider.bankdata!.banks!.map((e) => e.bankname!).toList();

        dropdownvalue = list!.first;
      }
    }

    if (_userProvider.bankdata != null) {
      if (_userProvider.bankdata!.banks!.isNotEmpty) {
        var acts = _userProvider.bankdata!.banks!.where((element) {
          return element.bankname == dropdownvalue;
        });
        acid = acts.first.acid;
        bank = _userProvider.bankdata!.banks!.where((element) {
          return element.acid == acid;
        }).toList();
      }
    }
    return Scaffold(
      backgroundColor: currentTheme.canvasColor,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate("Expense"),
          style: currentTheme.textTheme.displayMedium,
        ),
        backgroundColor: currentTheme.canvasColor,
      ),
      body: (_userProvider.getinvoicing || _userProvider.addinvoiceitems)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleLoader(context),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (_userProvider.invoicedata != null &&
                      _userProvider.invoicedata?.amt != null) ...[
                    Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            catimages.containsKey(
                                    _userProvider.invoicedata?.category ??
                                        'Miscellaneous')
                                ? catimages[
                                        _userProvider.invoicedata!.category] ??
                                    'assets/images/other.png'
                                : 'assets/images/other.png',
                            // Replace with your asset path
                            width: 40,
                            height: 50,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Text(
                              AppLocalizations.of(context).translate(
                                  _userProvider.invoicedata!.category ??
                                      'Miscellaneous'),
                              style: currentTheme.textTheme.displayLarge,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: SizedBox(
                                            width: 35,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  currentTheme.primaryColor,
                                              radius: 20,
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      currentTheme.canvasColor,
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
                                              .translate("Date"),
                                          style: currentTheme
                                              .textTheme.displayMedium,
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                        onTap: () {
                                          selectDate(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Text(
                                            DateFormat('dd-MM-yyyy')
                                                .format(currentdate!)
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    currentTheme.primaryColor,
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
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: SizedBox(
                                                width: 35,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      currentTheme.primaryColor,
                                                  radius: 20,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        currentTheme
                                                            .canvasColor,
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
                                              style: currentTheme
                                                  .textTheme.displayMedium,
                                            ),
                                          ],
                                        ),
                                        list != null
                                            ? DropdownButton(
                                                // Initial Value
                                                value: dropdownvalue,

                                                // Down Arrow Icon
                                                icon: Icon(
                                                    Icons.keyboard_arrow_down),

                                                // Array list of items
                                                items:
                                                    list!.map((String items) {
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                    dropdownvalue ??
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate("Nil"),
                                                    style: currentTheme
                                                        .textTheme
                                                        .displayMedium),
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate(_userProvider
                                                        .invoicedata!
                                                        .subcategory ??
                                                    'Miscellaneous'),
                                            style: currentTheme
                                                .textTheme.displayLarge,
                                          ),
                                          Text(
                                            '${_userProvider.currency} ${_userProvider.invoicedata!.amt.toString()}',
                                            style: currentTheme
                                                .textTheme.displayLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]))
                    ])
                  ] else ...[
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Center(child: Text("no data found")),
                      ],
                    )
                  ],
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 150),
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
                            context.loaderOverlay.show();
                            await subid();
                            bool duplicatte = await filterdata();

                            if (duplicatte) {
                              bool returnvale =
                                  await _showMyDialog(context, currentTheme);

                              if (!returnvale) {
                                Navigator.pop(context);
                              } else {
                                if (_userProvider.invoicedata?.amt != null &&
                                    _userProvider.invoicedata!.invoice_data! &&
                                    _userProvider.expensedata != null) {
                                  await insertexpense(
                                      'Expense',
                                      _userProvider.invoicedata!.amt,
                                      _userProvider.invoicedata!.category ??
                                          'others',
                                      DateFormat('yyyy-MM-dd')
                                          .format(currentdate!),
                                      catid,
                                      subcatid,
                                      acid,
                                      'merchant',
                                      _userProvider.invoicedata!.location ??
                                          'location',
                                      _userProvider.currency,
                                      0,
                                      widget.imagepath,
                                      'This is Invoice');

                                  await insertinvoiceitems(
                                      _userProvider.expensedata!.expenses!.last
                                          .transactionid,
                                      _userProvider.invoicedata!);
                                  final snackBar = SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(AppLocalizations.of(context)
                                          .translate(
                                              "expense_validation_success")),
                                      backgroundColor: Colors.green);

                                  // Find the ScaffoldMessenger in the widget tree
                                  // and use it to show a SnackBar.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.pop(context);
                                }
                              }
                            } else {
                              if (_userProvider.invoicedata?.amt != null &&
                                  _userProvider.invoicedata!.invoice_data! &&
                                  _userProvider.expensedata != null) {
                                await insertexpense(
                                    'Expense',
                                    _userProvider.invoicedata!.amt,
                                    _userProvider.invoicedata!.category ??
                                        'others',
                                    _userProvider.invoicedata!.date == null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now())
                                        : DateFormat('yyyy-MM-dd')
                                            .format(currentdate!),
                                    catid ?? 0,
                                    subcatid ?? 0,
                                    acid,
                                    'merchant',
                                    _userProvider.invoicedata!.location ??
                                        'location',
                                    _userProvider.currency,
                                    0,
                                    widget.imagepath,
                                    'This is Invoice');

                                await insertinvoiceitems(
                                    _userProvider.expensedata!.expenses!.last
                                        .transactionid,
                                    _userProvider.invoicedata!);

                                    await _userProvider.getinvoiceitems();

                                if (bank.isNotEmpty) {
                                  updatebank(
                                      bank.first.acid,
                                      "${bank.first.actype} account",
                                      bank.first.actype,
                                      bank.first.bankname,
                                      num.parse(bank.first.acnumber!),
                                      bank.first.acbalance! -
                                          _userProvider.invoicedata!.amt!,
                                      bank.first.ishidden);
                                }

                                final snackBar = SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(AppLocalizations.of(context)
                                        .translate(
                                            "expense_validation_success")),
                                    backgroundColor: Colors.green);

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                              } else {
                                Future.delayed(new Duration(seconds: 0), () {
                                  Navigator.pop(context); //pop dialog
                                });
                              }
                            }
                            context.loaderOverlay.hide();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
