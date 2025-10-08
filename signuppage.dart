import 'dart:io';

import 'package:billfold/ConfirmUserPage.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/storage.dart';
import 'package:billfold/servises/user_model.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/signinpage.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/verify.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';

class SignUpPage extends StatefulWidget {
  String language;
  final void Function(Locale) onLanguageChanged;
  SignUpPage(
      {super.key, required this.language, required this.onLanguageChanged});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%&*()^]).{8,}$');
  late UserProvider _userProvider;
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  PhoneNumber initnumber = PhoneNumber(isoCode: 'IN');
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  checkuser() async {
    await UserRepository().checkforuser();
    await context.read<UserProvider>().loading();
    await context.read<UserProvider>().getdata();
  }

  Future<void> createaccountonAction(
      BuildContext context, String email, password, String phno, lang) async {
    try {
      if (email.isEmpty && phno.isNotEmpty) {
        await UserRepository().signup(
          phno, password,
          userAttributes: {"phone_number": phno},
          // signupAttributes:{
          //   "name":"sathish"
          // }
        );
      } else if (email.isNotEmpty && phno.isEmpty) {
        await UserRepository().signup(
          email, password,
          userAttributes: {"email": email},
          // signupAttributes:{
          //   "name":"sathish"
          // }
        );
      }
      // await UserRepository().signup(
      //   phno, password,
      //   userAttributes: { "phone_number": phno, "name": name},
      //   // signupAttributes:{
      //   //   "name":"sathish"
      //   // }
      // );

      // await prefs.remove(PreferenceKey.refererkey.name);
      // context.loaderOverlay.hide();

      // if (Platform.isAndroid) {
      //   if (res.isSignUpComplete) {

      //   }
      // } else if (Platform.isIOS) {
      //   if (res.nextStep.signUpStep == "CONFIRM_SIGN_UP_STEP") {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => ConfirmUserPage(username: email),
      //       ),
      //     );
      //   }
      // }
    } on CognitoUserConfirmationNeeded catch (_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmUserPage(
              username: email,
              language: lang,
              onLanguageChanged: widget.onLanguageChanged),
        ),
      );
      context.loaderOverlay.hide();
    } on AuthException catch (e) {
      print(e);

      context.loaderOverlay.hide();
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    } on Exception catch (e) {
      print(e);
      context.loaderOverlay.hide();
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text("Failed to create account"),
        ),
      );
    }
  }

  bool _phone = false;

  UserAPIDetails? userdata;

  
  List<Widget> signorSignupSocial(BuildContext context) {
  List<IdentityProvider> _provider = [];
  if (Platform.isAndroid) {
    _provider = [
      IdentityProvider.GOOGLE,
      IdentityProvider.APPLE,
    ];
  }
  if (Platform.isIOS) {
    _provider = [
      IdentityProvider.APPLE,
      IdentityProvider.GOOGLE,
    ];
  }

  // _provider.add(IdentityProvider.FACEBOOK);

  return  _provider
          .map((e) => _loginViaSocialButton(context, e))
          .toList();
}

Widget _loginViaSocialButton(
    BuildContext context, IdentityProvider provider) {
  return InkWell(
    child: provider.imageAsset!,
    onTap: () {
      context.loaderOverlay.show();
      loginSocialButtonOnPressed(context, provider);

      // _loginAppleButtonOnPressed(context);
    },
  );
}


  Future<void> loginSocialButtonOnPressed(
      BuildContext context, IdentityProvider provider) async {
    try {
      // if (provider == IdentityProvider.FACEBOOK) {
      //   launchUrl(Uri.parse(provider.url!),
      //       mode: LaunchMode.externalApplication)
      //     ..asStream().listen((event) {
      //       log(event.toString());
      //     })
      //     ..whenComplete(() => print("completed,.. "))
      //         .then((value) => print("value " + value.toString()));
      //   return;
      // }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => _AuthProvider(
              provider: provider,
              onError: (error, error_details) {
                ScaffoldMessengerState scaffoldMessenger =
                    ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(error_details ?? "Failed to delete"),
                  ),
                );
              },
              onSignInComplete: () async {
                await checkuser();
                await onLoggedIn(UserRepository().currentsession, context);
              })));
    } on Exception catch (_) {
      print(_);
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text("Failed to Signin"),
        ),
      );
      context.loaderOverlay.hide();
    }
  }

  fetchuser(logout) async {
    await context.readuser.updateuser(
      _userProvider.email,
        _userProvider.userdata?.name,
        _userProvider.userdata?.language,
        _userProvider.userdata?.currency,
        _userProvider.userdata?.notificaton,
        _userProvider.userdata?.facelogin,
        logout,
           _userProvider.userdata?.familylogin,);
  }

  Future<void> onLoggedIn(
    dynamic response,
    BuildContext context,
  ) async {
    if (response != null) {
      context.loaderOverlay.show();
      final prefs = await CommonLocalStorage.getInstance();
      await prefs.clear();

      context.loaderOverlay.hide();

      if (_userProvider.userdata != null) {
        context.read<UserProvider>().loadalldata();
         
        if (_userProvider.userdata?.name != null) {
           fetchuser(0);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LandingPage(onLanguageChanged: widget.onLanguageChanged),
              ),
              (route) => false);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyAccount(
                  language: _userProvider.userdata?.language ?? widget.language,
                  onLanguageChanged: widget.onLanguageChanged),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyAccount(
                language: _userProvider.userdata?.language ?? widget.language,
                onLanguageChanged: widget.onLanguageChanged),
          ),
        );
      }
    } else {
      context.loaderOverlay.hide();
      throw Exception("Failed...");
      
    }
  }

  bool isvisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _phonecontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
          backgroundColor: currentTheme.canvasColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        AppLocalizations.of(context).translate("sign_up"),
                        style: currentTheme.textTheme.displayLarge,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_phone) ...[
                          TextFormField(
                            controller: _emailcontroller,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('Email'),
                                labelStyle: currentTheme.textTheme.displaySmall,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              var availableValue = value ?? '';
                              if (availableValue.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate("email_requierd");
                              } else if (!availableValue.contains('@')) {
                                return AppLocalizations.of(context)
                                    .translate("valid_mail");
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                        if (_phone) ...[
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
                            textFieldController: _phonecontroller,
                            textStyle: Theme.of(context).textTheme.displaySmall,
                            autoValidateMode: AutovalidateMode.disabled,
                            initialValue: initnumber,
                            inputDecoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Phone Number',
                                labelStyle:
                                    currentTheme.textTheme.displaySmall),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                        TextFormField(
                          obscureText: isvisible,
                          controller: _passwordcontroller,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate('Password'),
                            labelStyle: currentTheme.textTheme.displaySmall,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isvisible = !isvisible;
                                  });
                                },
                                icon: Icon(
                                    isvisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey)),
                          ),
                          validator: (value) {
                            var availableValue = value ?? '';
                            if (availableValue.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate("password_requierd");
                            } else if (!regex.hasMatch(availableValue)) {
                              return "Your password should contain atleast \n 1 Upper case \n 1 Lower case \n 1 Number \n 1 Special Character ( ! @ # \$\ % ^ & * )";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: currentTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("signup"),
                                style: TextStyle(
                                    color: currentTheme.canvasColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                 context.loaderOverlay.show();
                                String email = _emailcontroller.text.trim();
                                String password =
                                    _passwordcontroller.text.trim();
                                String? phno = number.phoneNumber;

                                await createaccountonAction(context, email,
                                    password, phno ?? '', widget.language);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("or_sign_up_with"),
                    style: currentTheme.textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 25,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          height: 30,
                          // width: 40,
                          child: !_phone
                              ? Image.asset(
                                  "assets/images/telephone.png",
                                  // color: currentTheme.canvasColor,
                                )
                              : Image.asset(
                                  "assets/images/gmail.png",
                                  // color: currentTheme.canvasColor,
                                ),
                          decoration: BoxDecoration(
                              // color: currentTheme.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onTap: () {
                          setState(() {
                            _phone = !_phone;
                          });
                        },
                      ),
                      ...signorSignupSocial(context),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate("alrady_have_an_account"),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                          language: widget.language,
                                          onLanguageChanged:
                                              widget.onLanguageChanged,
                                        )));
                          },
                          child: Text(
                            AppLocalizations.of(context).translate("sign_in"),
                            style: TextStyle(
                                color: currentTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class _AuthProvider extends StatefulWidget {
  final IdentityProvider provider;
  final void Function() onSignInComplete;
  final void Function(String error, String? error_details)? onError;
  _AuthProvider(
      {Key? key,
      required this.provider,
      required this.onSignInComplete,
      this.onError})
      : assert(provider.url != null),
        super(key: key);

  @override
  State<_AuthProvider> createState() => __AuthProviderState();
}

class __AuthProviderState extends State<_AuthProvider> {
  ValueNotifier<double> progress = ValueNotifier<double>(0);

  late WebViewController _webviewController;

  Future<void> authorise() async {
    // await _cookiemanager.clearCookies();

    // final response1 = await http
    //     .get(Uri.parse(userrepo.UserRepository.LOGOUT_OAUTH_PROVIDER_URL));
    await _webviewController.loadRequest(Uri.parse(widget.provider.url!));
  }

  Future<void> revoke() async {
    // await _cookiemanager.clearCookies();

    // final response1 = await http
    //     .get(Uri.parse(userrepo.UserRepository.LOGOUT_OAUTH_PROVIDER_URL));
    await _webviewController.loadRequest(Uri.parse(widget.provider.url!));
  }

  @override
  void initState() {
    super.initState();
    _webviewController = WebViewController()
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' +
            'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            this.progress.value = progress / 100;
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            context.loaderOverlay.hide();

            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            debugPrint('Page NavigationRequest: ${request.url}');

            if (request.url.startsWith("billfoldify://")) {
              Map<String, String> query =
                  Uri.parse(request.url).queryParameters;
              if (query.containsKey("code")) {
                context.loaderOverlay.show();
                // String code = request.url
                //     .substring("xcaldata://?code=".length)
                //     .replaceFirst("#", "");
                await UserRepository().signUserInWithAuthCode(query["code"]!);
                Navigator.pop(context);
                widget.onSignInComplete();
              } else if (query.containsKey("error")) {
                Navigator.pop(context);
                if (widget.onError != null) {
                  widget.onError!(query["error"]!, query["error_description"]);
                }
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    if (_webviewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_webviewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    authorise();
  }

  Widget get _alertdialog {
    return AlertDialog(
        title: Text(
          "Confirm",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        content: Text(
          "Are you sure do you want exit before login..!",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    AppLocalizations.of(context).translate("Yes"),
                  )),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context).translate("No"),
                ),
              ),
            ],
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool? returnvalue = await showDialog(
              context: context,
              builder: (_) {
                return _alertdialog;
              },
              barrierDismissible: false);
          if (returnvalue == true) {
            Navigator.pop(context);
          }
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              )),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Stack(
                    children: [
                      WebViewWidget(
                        controller: _webviewController,
                      ),
                      ValueListenableBuilder<double>(
                        valueListenable: progress,
                        builder: (context, value, _) => value < 1.0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: LinearProgressIndicator(
                                  value: progress.value,
                                  color: Colors.grey[400],
                                ),
                              )
                            : Container(),
                      )
                    ],
                  )),
                ],
              ),
            )));
  }
}
