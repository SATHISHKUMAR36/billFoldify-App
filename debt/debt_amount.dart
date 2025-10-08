import 'package:billfold/debt/debt_detail.dart';
import 'package:billfold/debt/debt_final.dart';
import 'package:billfold/debt/debt_model.dart';
import 'package:billfold/main.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DebtAmount extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;

  const DebtAmount({super.key,required this.onLanguageChanged});

  @override
  State<DebtAmount> createState() => _DebtAmountState();
}

_stepper(currentStep, currentTheme, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 4,
            width: MediaQuery.of(context).size.width / 2.1,
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: currentTheme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8)))),
        // SizedBox(
        //   width: 20,
        // ),
        Container(
            height: 4,
            width: MediaQuery.of(context).size.width / 2.1,
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color:
                    currentStep >= 1 ? currentTheme.primaryColor : Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8)))),
      ],
    ),
  );
}

int currentStep = 1;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      DateTime? selectedDate;
    DateTime? currentdate = DateTime.now().add(Duration(days: 30));

final debtamount = TextEditingController();


bool notificaton = true;

class _DebtAmountState extends State<DebtAmount> {
  @override

  Widget build(BuildContext context) {
    
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
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

    return  SafeArea(child: Scaffold(
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
                      MaterialPageRoute(builder: (context) => DebtDetail(onLanguageChanged: widget.onLanguageChanged,)),
                    );
                  },
                  icon: Icon(Icons.keyboard_arrow_left)),
              flexibleSpace: Center(
                  child: Text(
                AppLocalizations.of(context).translate("New_debt"),
                style: currentTheme.textTheme.displayMedium,
              )),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                _stepper(currentStep, currentTheme, context),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "₹ " +AppLocalizations.of(context).translate("Amount_of_debt"),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: currentTheme.primaryColor, width: 3))),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                              key: _formKey,
                              child: Expanded(
                                // width: MediaQuery.of(context).size.width / 4,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: debtamount,
                                  decoration: InputDecoration(
                                      border: InputBorder.none, hintText: "0"),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
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
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
              
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                                backgroundColor: currentTheme.canvasColor,
                                radius: 16,
                                child: Image.asset(
                                  height:23,
                                    "assets/images/bank.png",
                                  ),),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate("borrow_from"),
                        style: currentTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                color:currentTheme.primaryColor,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: currentTheme.primaryColor,
                            radius: 20,
                            child: CircleAvatar(
                                backgroundColor: currentTheme.canvasColor,
                                radius: 16,
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate("repaid"),
                        style: currentTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right:20.0),
                        child: Text(DateFormat('dd-MMM-yyyy').format(currentdate ?? DateTime.now().add(Duration(days: 30))).toString(),style: TextStyle(color: currentTheme.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),),
                      ))
                ],
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( AppLocalizations.of(context).translate("Receive_alerts")),
                      Switch(
                          value: notificaton,
                          activeColor: currentTheme.primaryColor,
                          onChanged: (bool value) {
                            setState(() {
                              notificaton = value;
                            });
                          })
                    ],
                  ),

              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
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
                          AppLocalizations.of(context).translate("Next"),
                          style: TextStyle(
                              color: currentTheme.canvasColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                      //  final dt= Debt(Debtor_nmae: , )
                      //  dt.toJson()
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => (DebtFinal(onLanguageChanged: widget.onLanguageChanged,))),
                        );
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