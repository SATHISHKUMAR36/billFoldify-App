import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransferEdit extends StatefulWidget {
  int transid;
  String fromdropdownvalue;
  String todropdownvalue;
  String amount;
  String date;

  TransferEdit(
      {super.key,
      required this.fromdropdownvalue,
      required this.todropdownvalue,
      required this.transid,
      required this.amount,
      required this.date});

  @override
  State<TransferEdit> createState() => _TransferEditState();
}

class _TransferEditState extends State<TransferEdit> {
  List<Bank> frombank = [];
  List<Bank> tobank = [];
  List<String>? list;
  String? fromdropdownvalue;
  String? todropdownvalue;
  int? fromacid;
  int? toacid;

  TextEditingController balance = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? currentdate = DateTime.now();
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

  late UserProvider _userProvider;
  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  updateinterbank(
      transid, sendacid, sendbank, receiveacid, receivebank, amt, date) async {
    await context.readuser.updateinterbank(
        transid, sendacid, sendbank, receiveacid, receivebank, amt, date);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromdropdownvalue = widget.fromdropdownvalue;
    todropdownvalue = widget.todropdownvalue;
    balance.text = widget.amount;
    currentdate = DateTime.parse(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;

    list = _userProvider.bankdata!.banks!.map((e) => e.bankname!).toList();

    if (_userProvider.bankdata != null &&
        _userProvider.bankdata!.banks!.isNotEmpty) {
      frombank = _userProvider.bankdata!.banks!.where((element) {
        return element.bankname == fromdropdownvalue;
      }).toList();
      fromacid = frombank.first.acid;
      tobank = _userProvider.bankdata!.banks!.where((element) {
        return element.bankname == todropdownvalue;
      }).toList();
      toacid = tobank.first.acid;
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
            children: [
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 55,
                    // width: 100,
                    child: Image.asset(
                      "assets/images/bans.jpg",
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "₹ " + AppLocalizations.of(context).translate("Amount"),
                      style: currentTheme.textTheme.displayLarge,
                    ),
                    Center(
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
                                controller: balance,
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
                                  if (availableValue.isEmpty ||
                                      availableValue == '0') {
                                    return ("Enter Valid Amount!");
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (list != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton(
                          // Initial Value
                          value: fromdropdownvalue,

                          // Down Arrow Icon
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                          ),

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
                              fromdropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    Center(
                        child: SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset(
                        "assets/images/curveright.png",
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButton(
                          // Initial Value
                          value: todropdownvalue,

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
                            if (newValue != fromdropdownvalue) {
                              setState(() {
                                todropdownvalue = newValue!;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                        selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 40, bottom: 0),
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
                          if (balance.text != widget.amount ||
                              fromdropdownvalue != widget.fromdropdownvalue ||
                              todropdownvalue != widget.todropdownvalue ||
                              currentdate != DateTime.parse(widget.date)) {
                            updateinterbank(
                                widget.transid,
                                fromacid,
                                fromdropdownvalue,
                                toacid,
                                todropdownvalue,
                                num.parse(
                                  balance.text,
                                ),
                                DateFormat('yyyy-MM-dd')
                                    .format(currentdate!)
                                    .toString());
                            if (widget.amount != balance.text) {
                              await updatebank(
                                  frombank.first.acid,
                                  '${frombank.first.actype} account',
                                  frombank.first.actype,
                                  frombank.first.bankname,
                                  num.parse(frombank.first.acnumber!),
                                  (frombank.first.acbalance! +
                                      num.parse(widget.amount)),
                                  frombank.first.ishidden);

                              await updatebank(
                                  tobank.first.acid,
                                  '${tobank.first.actype} account',
                                  tobank.first.actype,
                                  tobank.first.bankname,
                                  num.parse(tobank.first.acnumber!),
                                  (tobank.first.acbalance! +
                                      num.parse(balance.text)),
                                  tobank.first.ishidden);
                              await updatebank(
                                  frombank.first.acid,
                                  '${frombank.first.actype} account',
                                  frombank.first.actype,
                                  frombank.first.bankname,
                                  num.parse(frombank.first.acnumber!),
                                  (frombank.first.acbalance! -
                                      num.parse(balance.text)),
                                  frombank.first.ishidden);
                              await updatebank(
                                  tobank.first.acid,
                                  '${tobank.first.actype} account',
                                  tobank.first.actype,
                                  tobank.first.bankname,
                                  num.parse(tobank.first.acnumber!),
                                  (tobank.first.acbalance! -
                                      num.parse(widget.amount)),
                                  tobank.first.ishidden);
                            }

                            final snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(AppLocalizations.of(context)
                                    .translate("expense_validation_success")),
                                backgroundColor: Colors.green);
                            Navigator.pop(context);
                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
