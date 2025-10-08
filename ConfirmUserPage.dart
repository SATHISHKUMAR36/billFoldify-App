import 'package:billfold/main.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:billfold/signinpage.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ConfirmUserPage extends StatefulWidget {
   String? username;
   String? language;
     final void Function(Locale) onLanguageChanged;

   ConfirmUserPage({ this.username, this.language,required this.onLanguageChanged});
  @override
  _ConfirmUserPageState createState() => _ConfirmUserPageState();
}

class _ConfirmUserPageState extends State<ConfirmUserPage> {
  TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _verifybuttonpressed(language) async {
    if (_formKey.currentState!.validate()) {
      try {
        context.loaderOverlay.show();
        final code = codeController.text.trim();
        final res = await UserRepository().confirmRegistration(
            username: widget.username!, confirmationCode: code);

        if (res) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(language: language?? 'English',onLanguageChanged: widget.onLanguageChanged),));
        }
        context.loaderOverlay.hide();
      } on Exception catch (e) {
        context.loaderOverlay.hide();
        print(e);
        ScaffoldMessengerState scaffoldMessenger =
            ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  _resendbuttononpressed(username) async {
    try {
      await UserRepository().resendConfirmationCode(username: username);
    } on Exception catch (e) {
      print(e);
    }
  }

  _verifybutton(language) {
    return InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Verify',
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        onTap: () {
          _verifybuttonpressed(language);
        });
  }

  _resendcode(username) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text('Resend Code',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Theme.of(context).primaryColor)),
        onPressed: () {
          _resendbuttononpressed(username);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return SafeArea(
      child: Scaffold(
          backgroundColor: currentTheme.canvasColor,

        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("verification"),style: TextStyle(color: currentTheme.canvasColor,fontWeight: FontWeight.bold),),
          backgroundColor: currentTheme.primaryColor,
          centerTitle: true,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        ),
        
          body:  Container(
            height:double.infinity,
              color: Colors.grey.withOpacity(0.2),
              child: SingleChildScrollView(

                child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(24.0, 60, 24.0, 24.0),
                    child: Container(
                      
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                        ),
                        // duration: Duration(seconds: 1),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            
                            children: [
                               SizedBox(height: 15,),
                              Padding(
                               
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Enter the verification code sent to your email id ${widget.username}.\n\nCheck your bulk / spam email folders with subject 'Email Verification' ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                               SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                        obscureText: true,
                                        controller: codeController,
                                        validator: (value) {
                                          if (value!.length != 6) {
                                            return 'Please enter valid code';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                       SizedBox(height: 15,),
                                      _resendcode(widget.username),
                                       SizedBox(height: 15,),
                                      _verifybutton(widget.language),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))),
              ))),
    );
  }
}
