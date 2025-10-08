import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ExpenseEdit extends StatefulWidget {
  num transacionid;
  num catid;
  num subcatid;
  num acid;
  String transactiontype;
  String description;
  String date;
  String catname;
  String subcatname;
  num amt;
  String location;
  num exrate;
  String merchant;
  String receptpath;
  String currency;
  String note;
  bool transacionhistory;
  String bankname;

  final void Function(Locale) onLanguageChanged;

  ExpenseEdit(
      {super.key,
      required this.catname,
      required this.acid,
      required this.description,
      required this.subcatname,
      required this.amt,
      required this.transactiontype,
      required this.transacionid,
      required this.catid,
      required this.merchant,
      required this.date,
      required this.subcatid,
      required this.location,
      required this.receptpath,
      required this.currency,
      required this.note,
      required this.exrate,
      required this.onLanguageChanged,
      required this.transacionhistory,
      required this.bankname});

  @override
  State<ExpenseEdit> createState() => _ExpenseEditState();
}

class _ExpenseEditState extends State<ExpenseEdit> {
  List<Bank> bank = [];
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
    'Rent': "assets/images/rent.png",  'BankStatement':"assets/images/bankstatement.png"
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController amt = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    amt.text = widget.amt.toString();
    super.initState();
    currentdate = DateTime.parse(widget.date);
  
    dropdownvalue = widget.bankname;
    
  }

  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  updateexpense(
      transid,
      transactiontype,
      amt,
      description,
      date,
      categoryid,
      subcategoryid,
      acid,
      merchant,
      location,
      currency,
      exrate,
      receptpath,
      note) async {
    await context.readuser.updateexpense(
        transid,
        transactiontype,
        amt,
        description,
        date,
        categoryid,
        subcategoryid,
        acid,
        merchant,
        location,
        currency,
        exrate,
        receptpath,
        note);
  }

  DateTime? selectedDate;
  late DateTime? currentdate;
   

  List<String>? list;

  String? dropdownvalue;

  int? acid;
  late UserProvider _userProvider; 
  @override
  Widget build(BuildContext context) {
    
    //  DateTime? currentdate = DateTime.parse(widget.date);
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    
  _userProvider=context.watchuser;
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

    return SafeArea(
        child: Scaffold(
          backgroundColor: currentTheme.canvasColor,

      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("Edit_transaction"),
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
              height: 30,
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
              height: 30,
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
                                    color: currentTheme.primaryColor, width: 3))),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              // width: MediaQuery.of(context).size.width / 4,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: amt,
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
              height: 35,
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
                      AppLocalizations.of(context).translate("Createdate"),
                      style: currentTheme.textTheme.displayMedium,
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      selectDate(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text(
                        DateFormat('dd-MM-yyyy')
                            .format(currentdate ?? DateTime.now())
                            .toString(),
                        style: TextStyle(
                            color: currentTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Column(
              children: [
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
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 100),
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
                        if (num.parse(amt.text) != widget.amt ||
                            acid != widget.acid ||DateTime.parse(widget.date) != currentdate) {
                              context.loaderOverlay.show();
                          try {
                            
                            await updateexpense(
                                widget.transacionid,
                                widget.transactiontype,
                                num.parse(amt.text),
                                widget.description,
                                DateFormat('yyyy-MM-dd')
                                    .format(currentdate!)
                                    .toString(),
                                widget.catid,
                                widget.subcatid,
                                acid,
                                widget.merchant,
                                widget.location,
                                widget.currency,
                                widget.exrate,
                                widget.receptpath,
                                widget.note);

                                if(widget.note=='This is Invoice'){
                                      await _userProvider.getinvoiceitems();
                                }
                            if (acid == widget.acid) {
                              await updatebank(
                                  bank.first.acid,
                                  "${bank.first.actype} account",
                                  bank.first.actype,
                                  bank.first.bankname,
                                  num.parse(bank.first.acnumber!),
                                  bank.first.acbalance! +
                                      (widget.amt - num.parse(amt.text)),
                                  bank.first.ishidden);
                            } else {
                              await updatebank(
                                  bank.first.acid,
                                  "${bank.first.actype} account",
                                  bank.first.actype,
                                  bank.first.bankname,
                                  num.parse(bank.first.acnumber!),
                                  bank.first.acbalance! - num.parse(amt.text),
                                  bank.first.ishidden);
        
                              await updatebank(
                                  widget.acid,
                                  "${widgetbank.first.actype} account",
                                  widgetbank.first.actype,
                                  widgetbank.first.bankname,
                                  num.parse(widgetbank.first.acnumber!),
                                  widgetbank.first.acbalance! +widget.amt,
                                  widgetbank.first.ishidden);
                            }
                          } finally {
                            context.loaderOverlay.hide();
                            final snackBar = SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(AppLocalizations.of(context)
                                    .translate("expense_validation_success")),
                                backgroundColor: Colors.green);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            
                            
                                                   Navigator.pop(context);

                            
                            // TODO
                          }
                        } else {
                          final snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(AppLocalizations.of(context)
                                  .translate("save_validation")),
                              backgroundColor: Colors.red);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    ));
  }
}
