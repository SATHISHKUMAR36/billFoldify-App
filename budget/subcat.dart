import 'package:billfold/budget/budgetbasemodel.dart';
import 'package:billfold/budget/budgetmodel.dart';
import 'package:billfold/categories/subcatmodel.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Subcatpage extends StatefulWidget {
  String catname;
  int catid;
  int? subcatid;
  num? amt;
  Subcatpage(
      {super.key,
      required this.catname,
      required this.catid,
      this.subcatid,
      this.amt});

  @override
  State<Subcatpage> createState() => _SubcatpageState();
}

class _SubcatpageState extends State<Subcatpage> {
  List<TextEditingController> _controllers = [];
  List<Subcategory>? subcategories;
  List<Budget>? budgets;
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

  DateTime? duedate = DateTime.now().add(Duration(days: 30));
  DateTime? currentdate = DateTime.now();
  late UserProvider _userProvider;
  void _initializeControllers() {
    if (widget.amt != null && widget.subcatid != null) {
      Navigator.pop(context);
    } else {
      for (var i = 0; i < subcategories!.length; i++) {
        _controllers.add(TextEditingController());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Future<void> subcategoriesapi() async {
    budgets = _userProvider.budgetdata?.budget;
    subcategories =
        _userProvider.subcategorydata?.subcategories?.where((element) {
      return element.categoryid == widget.catid;
    }).toList();

    _initializeControllers();
  }

  insertbudget(categoryid, subcategoryid, budgetamt, startdate, enddate,
      frequency, threshold) async {
    await context.read<UserProvider>().insertbudget(categoryid, subcategoryid,
        budgetamt, startdate, enddate, frequency, threshold);
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
    subcategoriesapi();
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.canvasColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
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
                          AppLocalizations.of(context)
                              .translate(widget.catname),
                          style: currentTheme.textTheme.displayLarge,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
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
                                  style: _userProvider.userdata!.language ==
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
                          onTap: () {
                            List<String> values = _controllers
                                .map((controller) => controller.text)
                                .toList();

                            if (values.isNotEmpty &&
                                values.any((element) =>
                                    element.isNotEmpty && element != '0')) {
                              for (var i in values) {
                                if (i.isNotEmpty) {
                                  var budlist = budgets
                                      ?.where(
                                        (e) => e.subcatid==subcategories![values.indexOf(i)].subcategoryid
                                      )
                                      .toList();
                                  if (budlist?.first.subcatid !=
                                      subcategories![values.indexOf(i)]
                                          .subcategoryid){ 
                                             print(i.indexOf(i));
                                              insertbudget(
                                      widget.catid,
                                      subcategories![values.indexOf(i)].subcategoryid,
                                      num.parse(i),
                                      DateFormat('yyyy-MM-dd')
                                          .format(currentdate!)
                                          .toString(),
                                      DateFormat('yyyy-MM-dd')
                                          .format(duedate!)
                                          .toString(),
                                      "Monthly",
                                      0);

                                      final snackBar = SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(AppLocalizations.of(context)
                                      .translate("budget_validation_success")),
                                  backgroundColor: Colors.green);

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pop(context);
                              
                               }else{
                                final snackBar = SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(AppLocalizations.of(context)
                                      .translate("${budlist?.first.subcatname} have a budget already..!, You can modify it .")),
                                  backgroundColor: Colors.red);

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                               }
                                }
                              }
                              
                            } else {
                              final snackBar = SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(AppLocalizations.of(context)
                                      .translate("budget_validation")),
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 8, bottom: 40),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: currentTheme.disabledColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate("back"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            //       Navigator.pushAndRemoveUntil(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) =>  LandingPage(onLanguageChanged: widget.onLanguageChanged,)),
                            // (route) => false,);
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
