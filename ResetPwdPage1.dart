import 'package:billfold/ResetPwdPage2.dart';
import 'package:billfold/main.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ResetPwdPage1 extends StatefulWidget {

  final void Function(Locale) onLanguageChanged;
  ResetPwdPage1({super.key, required this.onLanguageChanged});
  @override
  _ResetPwdPage1State createState() => _ResetPwdPage1State();
}

class _ResetPwdPage1State extends State<ResetPwdPage1> {
  
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool phone = false;
  
PhoneNumber initnumber = PhoneNumber(isoCode: 'IN');
PhoneNumber number = PhoneNumber(isoCode: 'IN');

  Future<void> _submitButtonOnPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.loaderOverlay.show();
      var email = emailController.text.trim().toLowerCase();
      String? phno = number.phoneNumber;
      if(number.phoneNumber !=null){
        email= phno!;
      }

      /// Login code
      try {
        await UserRepository().forgotPassword(username: email);
        // await Amplify.Auth.resetPassword(username: email)
        //     .timeout(const Duration(seconds: 30));

        context.loaderOverlay.hide();
        //_confirmdialogbox(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPwdPage2(email: email,onLanguageChanged: widget.onLanguageChanged),
          ),
        );
      } catch  (e) {
      ScaffoldMessengerState scaffoldMessenger =
                  ScaffoldMessenger.of(context);
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              );
        print(e);
         context.loaderOverlay.hide();
      
        //   } on ApiException catch (e) {
        //     print(e);
        //     context.loaderOverlay.hide();
        //     if (e.message.contains('There is already a user signed in')) {
        //     } else if (e.message.contains('User not found in the system')) {
        //       ScaffoldMessengerState scaffoldMessenger =
        //           ScaffoldMessenger.of(context);
        //       scaffoldMessenger.showSnackBar(
        //         SnackBar(
        //           content: Text("Please Signup to login!"),
        //         ),
        //       );
        //     } else {
        //       // context.loaderOverlay.hide();

        //       ScaffoldMessengerState scaffoldMessenger =
        //           ScaffoldMessenger.of(context);
        //       scaffoldMessenger.showSnackBar(
        //         SnackBar(
        //           content: Text(e.message),
        //         ),
        //       );
        //     }
        //   } on Exception catch (e) {
        //     context.loaderOverlay.hide();
        //     ScaffoldMessengerState scaffoldMessenger =
        //         ScaffoldMessenger.of(context);
        //     scaffoldMessenger.showSnackBar(
        //       SnackBar(
        //         content: Text(e.toString()),
        //       ),
        //     );
        //   }
        // }
      }
    }
  }


  Widget _submitButton() {
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
          AppLocalizations.of(context).translate("reset_password"),
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.white),
        ),
      ),
      onTap: () {
        // context.loaderOverlay.show();

        _submitButtonOnPressed(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
              AppLocalizations.of(context).translate("forgot_password1"),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          
        ),
        body: Container(
          height: double.infinity,
          color: Colors.grey.withOpacity(0.2),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24.0, 24, 24.0, 24.0),
                        child: AnimatedContainer(
                            height: MediaQuery.of(context).size.height * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            duration: Duration(seconds: 1),
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 8),
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .translate("reset1"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            if (!phone) ...[
                                              TextFormField(
                                                //obscureText: false,
                                                controller: emailController,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,

                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff2633C5))),

                                                  labelStyle: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                  hoverColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  focusColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fillColor: Theme.of(context)
                                                      .primaryColor,
                                                  // border: OutlineInputBorder(),
                                                  labelText:
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate("email"),
                                                ),
                                                validator: (value) {
                                                  if (value == null) {
                                                    return 'Enter a valid email ID';
                                                  }else if(!value.contains('@'))
                                                         return 'Enter a valid email ID';
                                                   else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ],
                                            if (phone) ...[
                                               InternationalPhoneNumberInput(
                        spaceBetweenSelectorAndTextField: 2,
                        formatInput: false,
                        onInputChanged: (PhoneNumber num) {
                          if (!mounted) return;
                          setState(() {
                            number = num;
                          });
                        },
                        ignoreBlank: false,
                        selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                            trailingSpace: false),
                        keyboardType: TextInputType.phone,
                        textFieldController: emailController,
                        textStyle: Theme.of(context).textTheme.displaySmall,
                        autoValidateMode: AutovalidateMode.disabled,
                        initialValue: initnumber,
                        inputDecoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Phone Number',
                            labelStyle: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                        fontFamily:
                                                            "Montserrat",
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),),
                      ),
                                                
                                            ],
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  phone = !phone;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  if (!phone) ...[
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              "did_u_signup_with_mobile"),
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                  if (phone) ...[
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              "did_u_signup_with_mail"),
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: _submitButton(),
                                  )
                                ],
                              ),
                            ))))
                  ]),
            ),
          ),
        ));
  }
}
