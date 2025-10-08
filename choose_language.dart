import 'package:billfold/stepperpage.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class ChooseLanguage extends StatefulWidget {
    final void Function(Locale) onLanguageChanged;
   const ChooseLanguage({super.key,required this.onLanguageChanged});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}



var items = ['English', 'Tamil', 'Hindi'];

String dropdownvalue = 'English';

class _ChooseLanguageState extends State<ChooseLanguage> {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child: Image.asset(
              "assets/images/languages.png",
            ),
          ),
          Column(
            children: [
              Text(
                "Choose app language!",
                style: currentTheme.textTheme.displayLarge,
              ),
              SizedBox(
                height: 25,
              ),
              DropdownButton(
                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
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
              ),
            ],
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
                    borderRadius: BorderRadius.circular(40)),
                child: InkWell(
                  child: Center(
                    child: Text(
                       AppLocalizations.of(context).translate("Continue"),
                      style: TextStyle(
                          color: currentTheme.canvasColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                if (dropdownvalue == 'Tamil') {
                  widget.onLanguageChanged(const Locale('ta', ''));
                } else if (dropdownvalue == 'Hindi') {
                  widget.onLanguageChanged(const Locale('hi', ''));
                } else {
                  widget.onLanguageChanged(const Locale('en', ''));
                }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  StepperPage(language: dropdownvalue,onLanguageChanged: widget.onLanguageChanged,)),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
