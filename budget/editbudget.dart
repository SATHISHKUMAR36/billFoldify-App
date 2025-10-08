import 'package:billfold/budget/budgetview.dart';
import 'package:billfold/main.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Budgetedit extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;

  num budgetid;
  num catid;
  num subcatid;
  String startdate;
  String catname;
  String subcatname;
  num amt;
  String enddate;
  num threshold;
  String frequency;

  Budgetedit(
      {super.key,
      required this.catname,
      required this.subcatname,
      required this.amt,
      required this.enddate,
      required this.budgetid,
      required this.catid,
      required this.frequency,
      required this.startdate,
      required this.subcatid,
      required this.threshold,
      required this.onLanguageChanged});

  @override
  State<Budgetedit> createState() => _BudgeteditState();
}

class _BudgeteditState extends State<Budgetedit> {
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
    'Rent':"assets/images/rent.png",  'BankStatement':"assets/images/bankstatement.png"
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController amt = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    amt.text = widget.amt.toString();
    super.initState();
  }

  updatebudget(budgeid, categoryid, subcategoryid, budgetamt, startdate,
      enddate, frequency, threshold) async {
    await context.readuser.updatebudget(budgeid, categoryid, subcategoryid,
        budgetamt, startdate, enddate, frequency, threshold);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      
        child: Scaffold(
          backgroundColor: currentTheme.canvasColor,

      appBar: AppBar(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        
        title: Text(
          AppLocalizations.of(context).translate("Edit_budget"),
          style: TextStyle(
              color: currentTheme.canvasColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                AppLocalizations.of(context).translate(widget.subcatname),
                style: currentTheme.textTheme.displayLarge,
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
                            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                            ],
                            validator: (value) {
                              var availableValue = value ?? '';
                              if (availableValue.isEmpty) {
                                return ("Enter Valid Amount!");
                              } else if(availableValue=='0'){
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
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 150),
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
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      try {
                        updatebudget(
                            widget.budgetid,
                            widget.catid,
                            widget.subcatid,
                            num.parse(amt.text),
                            widget.startdate,
                            widget.enddate,
                            widget.frequency,
                            widget.threshold);
                      } finally {
                        final snackBar = SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(AppLocalizations.of(context)
                                .translate("budget_validation_success")),
                            backgroundColor: Colors.green);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(
                            context,
                            );
                        // TODO
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
