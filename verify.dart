import 'package:billfold/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billfold/theme_provider.dart';

import 'main.dart';

class VerifyAccount extends StatefulWidget {
  String language;
    final void Function(Locale) onLanguageChanged;
  

   VerifyAccount({super.key,required this.language,required this.onLanguageChanged});

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
          backgroundColor: currentTheme.canvasColor,

        body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
        SizedBox(
            height: 250,
            width: 250,
            child: Image.asset(
              "assets/images/verified.png",
            )),
        Text( AppLocalizations.of(context).translate("your_ac_is_verified"),
            style: currentTheme.textTheme.displayLarge),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfo(language: widget.language,onLanguageChanged: widget.onLanguageChanged,)),
                  );
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
