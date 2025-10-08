import 'package:billfold/budget/subcat.dart';
import 'package:billfold/categories/catbasemodel.dart';
import 'package:billfold/categories/subcatbasemodel.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/user_model.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MonthlyBudget extends StatefulWidget {
  
  final void Function(Locale) onLanguageChanged;
  const MonthlyBudget({super.key,required this.onLanguageChanged});

  @override
  State<MonthlyBudget> createState() => _MonthlyBudgetState();
}

final budgetcontroller = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _MonthlyBudgetState extends State<MonthlyBudget> {
  Catbase? cat;
  Subcatbase? subcat;
  String? currency;
  UserAPIDetails? userdata;
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
    'Retail':'assets/images/shopping.png',
    'Rent':"assets/images/rent.png",  'BankStatement':"assets/images/bankstatement.png"

  };
  
  @override
  void initState() {
    categoriesapi();
    // TODO: implement initState
    super.initState();

    userdata = context.readuser.userdata;

    currency = " ${userdata?.currency!.split(' - ')[0]}";
  }

  void categoriesapi() async {
    cat = context.readuser.categorydata;
  }



  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

   
    return  SafeArea(
            child: Scaffold(
          backgroundColor: currentTheme.canvasColor,

              appBar: AppBar(
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
                backgroundColor: currentTheme.primaryColor,
                title: Text(
                    AppLocalizations.of(context).translate("Monthly_budget"),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                centerTitle: true,
                leading: IconButton(onPressed: (){                      Navigator.pop(context);
}, icon: Icon(Icons.keyboard_arrow_left)),
              ),
              body: SingleChildScrollView(
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Align(
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         AppLocalizations.of(context)
                      //             .translate("what_is_your_monthly_budget"),
                      //         style: currentTheme.textTheme.displayLarge,
                      //       )),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Center(
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide(
                      //                 color: currentTheme.primaryColor,
                      //                 width: 3))),
                      //     width: MediaQuery.of(context).size.width / 3,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Expanded(
                      //           // width: MediaQuery.of(context).size.width / 4,
                      //           child: TextFormField(
                      //             textAlign: TextAlign.center,
                      //             controller: budgetcontroller,
                      //             decoration: const InputDecoration(
                      //                 border: InputBorder.none, hintText: "0"),
                      //             keyboardType: TextInputType.number,
                      //             inputFormatters: <TextInputFormatter>[
                      //               FilteringTextInputFormatter.allow(RegExp(
                      //                   r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                      //             ],
                      //             validator: (value) {
                      //               var availableValue =
                      //                   value ?? "assets/images/other.png";
                      //               if (availableValue.isEmpty) {
                      //                 return ("Enter Valid Amount!");
                      //               }
                      //               return null;
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("Set_catogoris"),
                              style: currentTheme.textTheme.displayLarge,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(children: [
                        if (cat != null && cat!.categories!.isNotEmpty)
                          ...cat!.categories!.map(
                            (e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: InkWell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                catimages[e.categoryname] ?? "assets/images/category.png",
                                                width: userdata?.language == 'Tamil'?30:40,
                                                height:userdata?.language == 'Tamil'?40: 50,
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                AppLocalizations.of(context).translate('${e.categoryname}'),
                                                style: userdata?.language == 'Tamil'?currentTheme
                                                    .textTheme.displayMedium:currentTheme
                                                    .textTheme.displayLarge,
                                              ),
                                            ],
                                          ),
                                          Icon(Icons.keyboard_arrow_right_outlined,color: Colors.grey,)
                                        ],
                                      ),
                                      onTap: ()  {
                                             Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Subcatpage(catname: e.categoryname!,catid: e.categoryid!),
                                        ),
                                      );
                                           
                                      },
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
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
                                  AppLocalizations.of(context)
                                      .translate("goto_dashboard"),
                                  style: TextStyle(
                                      color: currentTheme.canvasColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                                  Navigator.pop(context);

                                  
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }
}
