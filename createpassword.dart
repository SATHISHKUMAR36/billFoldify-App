import 'package:billfold/main.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/signinpage.dart';
import 'package:flutter/material.dart';

class CreatePassword extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  final String username;
  final String language;
  final String password;

  CreatePassword(this.username, this.password,  this.onLanguageChanged,this.language ,{Key? key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePassword();
}

class _CreatePassword extends State<CreatePassword> {
  TextEditingController newpwdTextEditingController =
      new TextEditingController();
  TextEditingController confirmnewpwdTextEditingController =
      new TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    newpwdTextEditingController.dispose();
    confirmnewpwdTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                  Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
              LoginPage(language: widget.language,onLanguageChanged: widget.onLanguageChanged,)),
        );
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context).translate("New_Password"),
                  style: context.watchtheme.currentTheme.textTheme.displayMedium,
                ),
                backgroundColor: context.watchtheme.currentTheme.canvasColor,
              ),
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                context.watchtheme.currentTheme.splashColor,
                context.watchtheme.currentTheme.primaryColor,
              ]),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                AppLocalizations.of(context).translate('create_new_password'),
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: newpwdTextEditingController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              label: Text(
                                AppLocalizations.of(context)
                                    .translate('New_Password'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: context.watchtheme.currentTheme
                                        .colorScheme.secondary),
                              )),
                          validator: (value) {
                            var availableValue = value ?? '';
                            if (availableValue.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate("password_requierd");
                            }else if (availableValue.length < 8) {
                          return AppLocalizations.of(context)
                              .translate("valid_password");
                        }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: confirmnewpwdTextEditingController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              label: Text(
                                AppLocalizations.of(context)
                                    .translate('Confirm_Password'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: context.watchtheme.currentTheme
                                        .colorScheme.secondary),
                              )),
                          validator: (value) {
                            var availableValue = value ?? '';
                            if (availableValue.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate("password_requierd");
                            } else if (availableValue !=
                                newpwdTextEditingController.text) {
                              return AppLocalizations.of(context)
                                  .translate("confirm_password_requierd");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            if (formkey.currentState?.validate() ?? false) {
                              UserRepository().createNewPassword(
                                username: widget.username,
                                newPassword:
                                    newpwdTextEditingController.text.trim(),
                              );
                              Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
              LoginPage(language: widget.language,onLanguageChanged: widget.onLanguageChanged,)),
        );
                            }
                           
                          },
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                context.watchtheme.currentTheme.splashColor,
                                context.watchtheme.currentTheme.primaryColor,
                              ]),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('Submit'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
