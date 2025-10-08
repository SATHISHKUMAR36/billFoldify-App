import 'package:billfold/dashboardpage.dart';
import 'package:billfold/debt/debt_amount.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtDetail extends StatefulWidget {
     final void Function(Locale) onLanguageChanged;
  const DebtDetail({super.key,required this.onLanguageChanged});

  @override
  State<DebtDetail> createState() => _DebtDetailState();
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

int currentStep = 0;
final _debtname = TextEditingController();
final _debtnote = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

int _selectedValue = 1;

class _DebtDetailState extends State<DebtDetail> {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return SafeArea(
        child: Scaffold(
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
                      MaterialPageRoute(builder: (context) => LandingPage(onLanguageChanged: widget.onLanguageChanged,)),
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("debt_name"),
                              style: currentTheme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: TextFormField(
                            controller: _debtname,
                            decoration: InputDecoration(
                                // hintText: AppLocalizations.of(context).translate(''),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              var availableValue = value ?? '';
                              if (availableValue.isEmpty) {
                                return ("Debtor Name is required");
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context).translate("Note"),
                              style: currentTheme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: TextFormField(
                            controller: _debtnote,
                            decoration: InputDecoration(
                                // hintText: AppLocalizations.of(context).translate(''),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            //                    validator: (value) {
                            // var availableValue = value ?? '';
                            // if (availableValue.isEmpty) {
                            //   return ("Goal Name is required");
                            // }
                            // return null;
                            //                    },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RadioListTile<int>(
                    activeColor:currentTheme.primaryColor,
                    title: Text( AppLocalizations.of(context).translate("I_owe"),style: currentTheme.textTheme.displayMedium,),
                    // subtitle: Text('Description of Option 1'),
                    value: 1,
                    groupValue: _selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    activeColor:currentTheme.primaryColor,
                    title: Text( AppLocalizations.of(context).translate("Owe_me"),style: currentTheme.textTheme.displayMedium),
                    // subtitle: Text('Description of Option 1'),
                    value: 2,
                    groupValue: _selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => (DebtAmount(onLanguageChanged: widget.onLanguageChanged,))),
                        );
                      },
                    ),
                  ),
                ),
              ),
                ],
              ),
            )));
  }
}
