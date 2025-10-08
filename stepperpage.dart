import 'package:billfold/signinpage.dart';
import 'package:billfold/signuppage.dart';
import 'package:billfold/stepprogress.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
// import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class StepperPage extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  String language;

  StepperPage({super.key, required this.language,required this.onLanguageChanged});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  PageController _controller = PageController(initialPage: 0);
  double _currentpage = 0;
  bool skip = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentpage = _controller.page!;
      });
    });
  }

  _signuppage(currentTheme, language) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
            height: 250,
            width: 250,
            child: Image.asset(
              "assets/images/analysis.png",
            )),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(AppLocalizations.of(context).translate("stat"),
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  AppLocalizations.of(context).translate("stat_sub"),
                  style: TextStyle(fontSize: 14,height: 1.5 ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: currentTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate("signup"),
                      style: TextStyle(
                          color: currentTheme.canvasColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpPage(language: language,onLanguageChanged: widget.onLanguageChanged,)),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  child: Center(
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("i_have_an_account"),
                          style: currentTheme.textTheme.displayMedium)),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage(language: language,onLanguageChanged: widget.onLanguageChanged,)));
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          
          children: [
            SizedBox(
              height: 15,
            ),
            _currentpage <= 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: InkWell(
                            child: Text(
                                AppLocalizations.of(context).translate("Skip"),
                                style: currentTheme.textTheme.displayMedium),
                            onTap: () {
                              setState(() {
                                _currentpage = 2;
                                skip = !skip;
                              });
                            }),
                      )
                      // Text(
                      //     '${(widget.currentStep + 1).toInt()} / ${widget.steps.toInt()}')
                    ],
                  )
                : Text(''),
            StepProgress(currentStep: _currentpage, steps: 3),
            Expanded(
                child: skip
                    ? PageView(children: [_signuppage(currentTheme, widget.language)])
                    : PageView(
                        controller: _controller,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: Image.asset(
                                    "assets/images/organization.png",
                                  )),
                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("organization"),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("organization_sub"),
                                    style: TextStyle(fontSize: 14,height: 1.5 ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: Image.asset(
                                    "assets/images/planning.png",
                                  )),
                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("budget_plan"),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("budget_plan_sub"),
                                    style: TextStyle(fontSize: 14,height: 1.5 ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          _signuppage(currentTheme, widget.language)
                        ],
                      ))
          ],
        ),
      ),
    );
  }
}
