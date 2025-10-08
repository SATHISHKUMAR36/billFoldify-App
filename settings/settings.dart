import 'package:billfold/accounts.dart';
import 'package:billfold/add_family/FamilyView.dart';
import 'package:billfold/add_family/familymodel.dart';
import 'package:billfold/categories/catrgories.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/storage.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/settings/username_change.dart';
import 'package:billfold/signinpage.dart';
import 'package:billfold/signuppage.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class Settingspage extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  Settingspage({super.key, required this.onLanguageChanged});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  late UserProvider _userProvider;
  @override
  void initState() {
    // api();
    //   family();
    // TODO: implement initState
    super.initState();
  }

  Future<List> _showMyDialog(context, currentTheme, title, content) async {
    //  userdata = await context.read<UserProvider>().userdata;
    String? username = _userProvider.userdata?.name;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    TextEditingController delete = TextEditingController();
    List? lst;
    lst = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate(title),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: SizedBox(
            height: _userProvider.userdata?.language == "Tamil"
                ? title == "DoyouwantBusiness_Account" ||
                        title == "Doyouwantdelete_account"
                    ? 200
                    : 110
                : title == "DoyouwantBusiness_Account" ||
                        title == "Doyouwantdelete_account"
                    ? 155
                    : 75,
            child: Column(
              children: [
                Text(AppLocalizations.of(context).translate(content),
                    style: currentTheme.textTheme.bodyMedium),
                if (title == "DoyouwantBusiness_Account") ...[
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).translate('Name'),
                          labelStyle: currentTheme.textTheme.displaySmall,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        var availableValue = value ?? '';
                        if (availableValue.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("Name_is_required");
                        } else if (availableValue == username) {
                          return AppLocalizations.of(context).translate(
                              "business_name_should_not_be_yourname");
                        }
                        return null;
                      },
                    ),
                  ),
                ],
                if (title == "Doyouwantdelete_account") ...[
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _formKey1,
                    child: TextFormField(
                      controller: delete,
                      decoration: InputDecoration(
                          labelText: "delete",
                          labelStyle: currentTheme.textTheme.displaySmall,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        var availableValue = value ?? '';
                        if (availableValue.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("type_delete_isreq");
                        } else if (availableValue != 'delete') {
                          return AppLocalizations.of(context)
                              .translate("enter_corr");
                        }
                        return null;
                      },
                    ),
                  ),
                ]
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(AppLocalizations.of(context).translate('No')),
                  onPressed: () {
                    Navigator.of(context).pop(lst = [false]);
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context).translate('Yes')),
                  onPressed: () {
                    if (title == "DoyouwantBusiness_Account") {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(lst = [true, name.text]);
                      }
                    } else if (title == "Doyouwantdelete_account") {
                      if (_formKey1.currentState!.validate()) {
                        Navigator.of(context).pop(lst = [true, delete.text]);
                      }
                    } else {
                      Navigator.of(context).pop(lst = [true, name.text]);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return lst!;
  }

  String? currecydefault;
  bool admin = true;

  family() async {
    familylist.clear();

    if (_userProvider.familydata != null &&
        _userProvider.familydata!.Familes!.isNotEmpty) {
      List <Family>? lst = _userProvider.familydata?.Familes?.where((element) {
        return element.actype != "Business";
      }).toList();

      _userProvider.familydata?.Familes
          ?.map((e) => familylist.add(e.name!))
          .toList();
      if (lst!=null&&lst.isNotEmpty) {
  lst.map((e) => familylist.add(e.familyname!)).toList();
}

      if (!familylist.contains(_userProvider.mainusername)) {
        familylist.add(_userProvider.mainusername!);
      }

      var lst1 = _userProvider.familydata?.Familes?.where((element) {
        return element.actype == 'Business';
      }).toList();

      var lst2 = _userProvider.familydata?.Familes?.where((element) {
        return element.actype == 'Parent';
      }).toList();

      var lst3 = _userProvider.familydata?.Familes?.where((element) {
        return element.actype == 'Child';
      }).toList();
      if (lst1!.isNotEmpty) {
        _userProvider.userdata?.userid == lst1.first.userid
            ? admin = true
            : admin = false;
      }
      if (lst2!.isNotEmpty) {
        _userProvider.userdata?.userid == lst2.first.userid
            ? admin = true
            : admin = false;
      }
      if (lst3!.isNotEmpty) {
        _userProvider.userdata?.userid == lst3.first.userid
            ? admin = false
            : admin = true;
      }
    }
  }

  List<String> languagelist = ['English', 'Tamil', 'Hindi'];
  List<String> currencylist = [
    "₹ - Indian Rupee",
    "\$ -  Singapore dollar (SGD)",
    "€ - Euro",
    "\$ - US Dollar",
    "£ - British Pound",
    "¥ - Japanese Yen",
  ];

  String? languagedefault;
  List<String> familylist = [];

  String? familydefault;

  api() async {
    try {
      currecydefault = _userProvider.userdata?.currency!.trim();
      languagedefault = _userProvider.userdata?.language;
      familydefault = _userProvider.userdata?.name!.trim();
      print(familydefault);
    } catch (e) {
      print("print error");
    }
  }

  signOutAction(BuildContext context, notificaton, face) async {
    try {
      context.loaderOverlay.show();
      // await BillfoldifyAPI.settoken("", "remove");
      // await UserRepository().logOut();

      await fetchuser(currecydefault, languagedefault, 1, notificaton, face);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    language: _userProvider.userdata?.language ?? 'English',
                    onLanguageChanged: widget.onLanguageChanged,
                  )));
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
    } on AuthException catch (e) {
      if (e.message!.contains('Your session has expired')) {
        // prefs.clear();
        // while (GoRouter.of(context).canPop()) {
        //   GoRouter.of(context).pop();
        // }
        // while (context.canPop()) {
        //   print("canpop");
        //   context.pop();
        // }
        // context.replaceNamed('homeapp');
      }
      // ignore: use_build_context_synchronously
      context.loaderOverlay.hide();
      print(e);
    } on Exception catch (e) {
      context.loaderOverlay.hide();
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  fetchuser(currecydefault, languagedefault, logout, notificaton, face) async {
    await context.readuser.updateuser(
        _userProvider.email,
        _userProvider.userdata?.name,
        languagedefault,
        currecydefault,
        notificaton ? 1 : 0,
        face ? 1 : 0,
        logout, _userProvider.userdata?.familylogin);

    return true;
  }

  userchange(userid) async {
   
    await _userProvider.updateuser(
        _userProvider.email,
        _userProvider.userdata?.name,
        _userProvider.userdata?.language,
        _userProvider.userdata?.currency,
        _userProvider.userdata?.notificaton ,
        _userProvider.userdata?.facelogin ,
        _userProvider.userdata?.logout, userid);


     await _userProvider.family(userid);
await _userProvider.getdata();
         await _userProvider.loadalldata();
    return true;
  }

  onpressed(
      currecydefault, languagedefault, familydefault, notificaton, face) async {
    if (currecydefault == _userProvider.userdata?.currency &&
        languagedefault == _userProvider.userdata?.language &&
        familydefault == _userProvider.userdata?.name &&
        notificaton ==
            (_userProvider.userdata?.notificaton == 1 ? true : false) &&
        face == (_userProvider.userdata?.facelogin == 1 ? true : false)) {
      final snackBar = SnackBar(
          duration: Duration(seconds: 1),
          content:
              Text(AppLocalizations.of(context).translate("save_validation")),
          backgroundColor: Colors.red);

      // Find the ScaffoldMessenger in the widget tree.
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      context.loaderOverlay.show();
      String? userid;
      if (familydefault != _userProvider.userdata?.name) {
        if (familydefault == 'My Family') {
          var lst = _userProvider.familydata?.Familes?.where((element) {
            return element.actype != 'Business';
          }).toList();
          userid = lst?.first.familyid;
        } else if (familydefault != 'My Family') {
          var lst = _userProvider.familydata?.Familes?.where((element) {
            return element.actype == 'Business' &&
                element.name == familydefault;
          }).toList();
          if (lst!.isNotEmpty) {
            userid = lst.first.familyid;
          } else {
            userid = _userProvider.familydata!.Familes!.first.userid;
          }
        } else {
          userid = _userProvider.familydata!.Familes!.first.userid;
        }
        try {
          if (userid != null) {
            print(userid);
            await userchange(userid);
          }
          print("Start");
          // Future.delayed(Duration(seconds: 2), () {
          await api();
          await family();

          // });
          print("End");
          context.loaderOverlay.hide();
        } catch (e) {
          context.loaderOverlay.hide();
          print("err");
        }
      } else {
        context.loaderOverlay.show();
        await fetchuser(currecydefault, languagedefault, 0, notificaton, face);
        if (languagedefault == 'Tamil') {
          widget.onLanguageChanged(const Locale('ta', ''));
        } else if (languagedefault == 'Hindi') {
          widget.onLanguageChanged(const Locale('hi', ''));
        } else {
          widget.onLanguageChanged(const Locale('en', ''));
        }
        context.loaderOverlay.hide();
      }
      final snackBar = SnackBar(
          duration: Duration(seconds: 1),
          content:
              Text(AppLocalizations.of(context).translate("save_snackbar")),
          backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  bool? notificaton;
  bool? face;
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
    if ((currecydefault != _userProvider.userdata?.currency &&
        languagedefault != _userProvider.userdata?.language &&
        familydefault != _userProvider.userdata?.name)) {
      api();
      family();
    }

    if (notificaton == null) {
      notificaton = _userProvider.userdata?.notificaton == 1 ? true : false;

      face = _userProvider.userdata?.facelogin == 1 ? true : false;
    }
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate("Settings"),
            style: TextStyle(
                color: currentTheme.canvasColor,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        backgroundColor: currentTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                // height: 50,
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () async {
                          List returnvale = await _showMyDialog(context,
                              currentTheme, "DoyouwantLogout", "logout_alert");
                          if (returnvale[0]) {
                            // final prefs = await SharedPreferences.getInstance();
                            // String? signinuser1 = prefs.getString('signinuser');
                            try {
                              signOutAction(context, notificaton, face);
                            } catch (_) {} // BillfoldifyAPI.stratigescreener(apiurl, selectedcountrycode)
                            // if (signinuser1 != null) {
                            //   Map<String, dynamic> signin =
                            //       jsonDecode(signinuser1);
                            //   UserDetails signInUser =
                            //       UserDetails.fromJson(signin);
                            //   UserDetails signinuser = UserDetails(
                            //       name: signInUser.name,
                            //       currency: signInUser.currency,
                            //       language: signInUser.language,
                            //       notificaton: signInUser.notificaton,
                            //       logout: true);
                            //   Map<String, dynamic> userJson =
                            //       signinuser.toJson();
                            //   final prefs =
                            //       await SharedPreferences.getInstance();
                            //   prefs.setString(
                            //       'signinuser', jsonEncode(userJson));
                            // }
                          }
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                width: 40,
                                child: CircleAvatar(
                                  backgroundColor: currentTheme.primaryColor,
                                  radius: 20,
                                  child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 16,
                                      child: const Icon(
                                        Icons.logout_outlined,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context).translate("Logout"),
                              style: currentTheme.textTheme.displayMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0.3,
                    ),
                    if ((!_userProvider.userdata!.userid!.contains('S_') &&
                        !_userProvider.userdata!.userid!.contains('F_'))) ...[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder:(context) => (UsernameChange(onLanguageChanged: widget.onLanguageChanged))));
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: currentTheme.primaryColor,
                                    radius: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            currentTheme.canvasColor,
                                        radius: 16,
                                        child: const Icon(
                                          Icons.person_2_outlined,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("UserDetails"),
                                style: currentTheme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 70,
              ),
              Container(
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                // height: _userProvider.userdata?.language == 'Tamil'
                //     ? MediaQuery.of(context).size.height / 1.2
                //     : MediaQuery.of(context).size.height / 1.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),

                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FamilyView(
                                  onLanguageChanged: widget.onLanguageChanged,
                                  admin: admin,
                                ),
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: currentTheme.primaryColor,
                                    radius: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            currentTheme.canvasColor,
                                        radius: 16,
                                        child: const Icon(
                                          Icons.group,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("Linked_Accounts"),
                                style: currentTheme.textTheme.bodyMedium,
                              ),
                            ]),
                            Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: currentTheme.primaryColor,
                            )
                          ],
                        )),
                    Divider(
                      thickness: 0.1,
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Accounts(
                                  onLanguageChanged: widget.onLanguageChanged),
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: currentTheme.primaryColor,
                                    radius: 20,
                                    child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 16,
                                      child: Image.asset(
                                        height: 23,
                                        "assets/images/bank.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("Connected_banks"),
                                style: currentTheme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: currentTheme.primaryColor,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.1,
                    ),
                    ////
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Usercategories(
                                  onLanguageChanged: widget.onLanguageChanged),
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: currentTheme.primaryColor,
                                    radius: 20,
                                    child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 16,
                                      child: Icon(
                                        Icons.category,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("Categories"),
                                style: currentTheme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: currentTheme.primaryColor,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.1,
                    ),
                    Column(
                      children: [
                        _userProvider.userdata?.language == 'Tamil'
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: SizedBox(
                                          width: 40,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                currentTheme.primaryColor,
                                            radius: 20,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  currentTheme.canvasColor,
                                              radius: 16,
                                              child: Image.asset(
                                                height: 23,
                                                "assets/images/dollar.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate("Currency"),
                                        style:
                                            currentTheme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  DropdownButton(
                                    // Initial Value
                                    alignment: Alignment.centerRight,
                                    value: currecydefault,

                                    // Down Arrow Icon
                                    icon: Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: currencylist.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                        ),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        currecydefault = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: SizedBox(
                                          width: 40,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                currentTheme.primaryColor,
                                            radius: 20,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  currentTheme.canvasColor,
                                              radius: 16,
                                              child: Image.asset(
                                                height: 23,
                                                "assets/images/dollar.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate("Currency"),
                                        style:
                                            currentTheme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  DropdownButton(
                                    // Initial Value
                                    alignment: Alignment.centerRight,
                                    value: currecydefault,

                                    // Down Arrow Icon
                                    icon: Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: currencylist.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                        ),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        currecydefault = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                      ],
                    ),
                    Divider(
                      thickness: 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                width: 40,
                                child: CircleAvatar(
                                  backgroundColor: currentTheme.primaryColor,
                                  radius: 20,
                                  child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 16,
                                      child: Icon(
                                        Icons.language,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("Language"),
                              style: currentTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        DropdownButton(
                          // Initial Value
                          //  alignment: Alignment.centerRight,
                          value: languagedefault,

                          // Down Arrow Icon
                          icon: Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: languagelist.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              languagedefault = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.1,
                    ),
                    if(_userProvider.familydata != null)...[if (_userProvider.familydata!.Familes!.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SizedBox(
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: currentTheme.primaryColor,
                                    radius: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            currentTheme.canvasColor,
                                        radius: 16,
                                        child: Icon(
                                          Icons.family_restroom_outlined,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("Switch_account"),
                                style: currentTheme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          DropdownButton(
                            // Initial Value
                            //  alignment: Alignment.centerRight,
                            value: familydefault,

                            // Down Arrow Icon
                            icon: Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: familylist.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                ),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                familydefault = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                    ],
                    Divider(
                      thickness: 0.1,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Padding(
                    //           padding:
                    //               const EdgeInsets.symmetric(horizontal: 10.0),
                    //           child: SizedBox(
                    //             width: 40,
                    //             child: CircleAvatar(
                    //               backgroundColor: currentTheme.primaryColor,
                    //               radius: 20,
                    //               child: CircleAvatar(
                    //                   backgroundColor: currentTheme.canvasColor,
                    //                   radius: 16,
                    //                   child: Icon(
                    //                     Icons.notifications_outlined,
                    //                     color: Colors.black,
                    //                   )),
                    //             ),
                    //           ),
                    //         ),
                    //         Text(
                    //           AppLocalizations.of(context)
                    //               .translate("Notifications"),
                    //           style: currentTheme.textTheme.bodyMedium,
                    //         ),
                    //       ],
                    //     ),
                    //     Switch(
                    //         value: notificaton??true,
                    //         activeColor: currentTheme.primaryColor,
                    //         onChanged: (bool value) {
                    //           setState(() {
                    //             notificaton = value;
                    //           });
                    //         })
                    //   ],
                    // ),
                    // Divider(
                    //   thickness: 0.1,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                width: 40,
                                child: CircleAvatar(
                                  backgroundColor: currentTheme.primaryColor,
                                  radius: 20,
                                  child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 16,
                                      child: Icon(
                                        Icons.fingerprint,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("Biometric_auth"),
                              style: currentTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Switch(
                            value: face ?? true,
                            activeColor: currentTheme.primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                face = value;
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color:  (currecydefault == _userProvider.userdata?.currency &&
        languagedefault == _userProvider.userdata?.language &&
        familydefault == _userProvider.userdata?.name &&
        notificaton ==
            (_userProvider.userdata?.notificaton == 1 ? true : false) &&
        face == (_userProvider.userdata?.facelogin == 1 ? true : false))?currentTheme.primaryColor.withOpacity(0.5):currentTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            onpressed(currecydefault, languagedefault,
                                familydefault, notificaton, face);
                          },
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context).translate("Save"),
                            style: TextStyle(
                                color: currentTheme.canvasColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
