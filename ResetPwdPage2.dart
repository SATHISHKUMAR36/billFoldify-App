import 'package:billfold/main.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:billfold/signinpage.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ResetPwdPage2 extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  final dynamic email;
  ResetPwdPage2({this.email, required this.onLanguageChanged});
  @override
  _ResetPwdPage2State createState() => _ResetPwdPage2State();
}

class _ResetPwdPage2State extends State<ResetPwdPage2> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*()^]).{8,}$');
  bool showpassword = false;
  bool showconfirmpassword = false;
  late String password;
  late String email;
  late String otp;

  Future<void> _submitButtonOnPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.loaderOverlay.show();

      /// Login code
      try {
        email = widget.email;
        password = passwordController.text.trim();
        otp = otpController.text.trim();
        await UserRepository().confirmPassword(
          username: email,
          confirmationCode: otp,
          newPassword: password,
        );

        // await Amplify.Auth.confirmResetPassword(
        //         username: email, newPassword: password, confirmationCode: otp)
        //     .timeout(const Duration(seconds: 30));

        context.loaderOverlay.hide();
        ScaffoldMessengerState scaffoldMessenger =
            ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[400],
            elevation: 5,
            content: Text("Password update successful! Please login again!"),
          ),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                  language: 'English',
                  onLanguageChanged: widget.onLanguageChanged),
            ),
            (route) => false);

        // context.pushReplacementNamed('login');
      } catch (e) {
        print(e);
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
          'Submit',
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

  _resendotp() async {
    // await Amplify.Auth.resetPassword(username: widget.email)
    //     .timeout(const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Confirm password',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        body: Container(
            height: double.infinity,
            color: Colors.grey.withOpacity(0.2),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24, 24.0, 24.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    "Please enter the OTP sent to your email ID ${widget.email}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            TextFormField(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall,
                                              controller: otpController,
                                              keyboardType:
                                                  TextInputType.number,
                                              obscureText: true,
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
                                                  labelText: "OTP"
                                                  // border: OutlineInputBorder(),
                                                  ),
                                              validator: (value) {
                                                if (value!.length == 0) {
                                                  return 'Enter the verification code';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            Positioned(
                                                top: 10,
                                                right: 5,
                                                child: TextButton(
                                                  onPressed: () {
                                                    _resendotp();
                                                  },
                                                  child: Text(
                                                    "Resend OTP",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Stack(children: [
                                          TextFormField(
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            obscureText: !showpassword,
                                            controller: passwordController,
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
                                                    fontFamily: "Montserrat",
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
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
                                              labelText: 'New Password',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        "password_requierd");
                                              } else if (!regex
                                                  .hasMatch(value)) {
                                                return "Your password should contain atleast \n 1 Upper case \n 1 Lower case \n 1 Number \n 1 Special Character ( ! @ # \$\ % ^ & * )";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          Positioned(
                                              top: 10,
                                              right: 5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showpassword =
                                                          !showpassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    showpassword
                                                        ? Icons.remove_red_eye
                                                        : Icons
                                                            .remove_red_eye_outlined,
                                                    color: Colors.grey,
                                                  )))
                                        ]),
                                        Stack(children: [
                                          TextFormField(
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            obscureText: !showconfirmpassword,
                                            controller:
                                                confirmpasswordController,
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
                                                    fontFamily: "Montserrat",
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
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
                                              labelText: 'Confirm New Password',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter valid password';
                                              } else if (value !=
                                                  passwordController.text) {
                                                return 'Password doesnot match';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          Positioned(
                                              top: 10,
                                              right: 5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showconfirmpassword =
                                                          !showconfirmpassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    showpassword
                                                        ? Icons.remove_red_eye
                                                        : Icons
                                                            .remove_red_eye_outlined,
                                                    color: Colors.grey,
                                                  )))
                                        ])
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: _submitButton(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
