import 'package:billfold/add_family/Familyviewmodel.dart';
import 'package:billfold/add_family/addfamily.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class FamilyView extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  String? Familyid;
  bool admin;
  FamilyView(
      {super.key,
      required this.onLanguageChanged,
      required this.admin});

  @override
  State<FamilyView> createState() => _FamilyViewState();
}

class _FamilyViewState extends State<FamilyView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Familyview> myfamily=[];
  List<Familyview> mybusiness=[];


  late UserProvider _userProvider;
  api() async {
    // _userProvider.userdata!.userid!.contains('S_') ? fam = true : fam = false;
    if (_userProvider.familyviewdata!=null) {
  if ( _userProvider.familyviewdata!.Familes!.isNotEmpty) {
    myfamily =  _userProvider.familyviewdata!.Familes!.where((element) {
      return element.actype != 'Business';
    }).toList();
    mybusiness =  _userProvider.familyviewdata!.Familes!.where((element) {
      return element.actype == 'Business';
    }).toList();
  } else {
    myfamily = [];
    mybusiness = [];
  }
}else {
    myfamily = [];
    mybusiness = [];
  }
  }

  Future<List> _showMyDialog1(context, currentTheme, title, content) async {
    //  userdata = await context.read<UserProvider>().userdata;
    String? username = _userProvider.userdata?.name;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
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
            height: title == "DoyouwantBusiness_Account" ? 155 : 75,
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
                ]
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child:  Text(AppLocalizations.of(context).translate('No')),
                  onPressed: () {
                    Navigator.of(context).pop(lst = [false]);
                  },
                ),
                TextButton(
                  child:  Text(AppLocalizations.of(context).translate('Yes')),
                  onPressed: () {
                    if (title == "DoyouwantBusiness_Account") {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(lst = [true, name.text]);
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

  void deletefamily(memberid, childid) async {
    await _userProvider.deletefamily(memberid, childid);
    await  api();
    context.loaderOverlay.hide();
  }

  businessuser(FamilyID, email, name, relationship, gender, yearofbirth,
      allowlogin, Language, Currency, username) async {
    await _userProvider.insertfamily(FamilyID, email, name, relationship,
        gender, yearofbirth, allowlogin, Language, Currency, username);
  }


  Future<bool> _showMyDialog(context, currentTheme) async {
    final TextEditingController name = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool? exitApp = await showDialog(
      context: context,

      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("Delete_this_account"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: SizedBox(
            height: 175,
            child: Column(
              children: [
                Text(AppLocalizations.of(context).translate("Delete_account"),
                    style: currentTheme.textTheme.bodyMedium),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('delete'),
                        labelStyle: currentTheme.textTheme.displaySmall,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      var availableValue = value ?? '';
                      if (availableValue.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate("delete_is_required");
                      } else if (availableValue != "delete") {
                        return AppLocalizations.of(context)
                            .translate("type_delete");
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('delete'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return exitApp!;
  }

String? familyid;
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
    bool? loading = _userProvider.getfamiling;
      if (familyid==null) {
  api();
}
    
    return loading 
        ? Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  ListTile(
                    title: ShimmerWidget.rectangular(
                      width: 100,
                      height: 120,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(height: 40),
                  ListTile(
                    title: ShimmerWidget.rectangular(
                      width: 100,
                      height: 120,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              centerTitle: true,
              title: Text(
                  AppLocalizations.of(context).translate("Linked_Accounts"),
                  style: TextStyle(
                      color: currentTheme.canvasColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              backgroundColor: currentTheme.primaryColor,
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                onPressed: () async {
                   Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LandingPage(onLanguageChanged: widget.onLanguageChanged,selectedIndex: 3),
                                          ),(route) => false,);
                },
              ),
            ),
            body: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: Colors.grey.withOpacity(0.1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("MyFamily") +
                                    ":",
                                style: currentTheme.textTheme.displayLarge,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (myfamily.isNotEmpty) ...[
                      ...myfamily.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(
                              top: 12, left: 15, right: 15),
                          child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: currentTheme.canvasColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
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
                                                        currentTheme
                                                            .canvasColor,
                                                    radius: 17,
                                                    child: const Icon(
                                                      Icons.group,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                              e.name ?? "",
                                            ),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    if(widget.admin) ... [IconButton(
                                        onPressed: () async {
                                          bool returnvale = await _showMyDialog(
                                              context, currentTheme);

                                          if (returnvale) {
                                            context.loaderOverlay.show();
                                            deletefamily(
                                                e.memberid, e.familyid);

                                            // asc();
                                          }
                                        },
                                        icon: Icon(
                                          size: 17,
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),]
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                            e.relationship ?? "",
                                          ),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
                    ] else ...[
                      Center(child: Text("No Family Found..."))
                    ],
                    if ((_userProvider.familyviewdata!=null&& (!_userProvider.userdata!.userid!.contains('S_')&&!_userProvider.userdata!.userid!.contains('F_'))) ||
                        (widget.admin && !_userProvider.userdata!.userid!.contains('S_'))) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 30, bottom: 10),
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
                                  AppLocalizations.of(context)
                                      .translate("Add_Family_member"),
                                  style: TextStyle(
                                      color: currentTheme.canvasColor,
                                      fontSize:_userProvider. userdata?.language == "Tamil"
                                          ? 12
                                          : 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => (Addfamily(
                                            onLanguageChanged:
                                                widget.onLanguageChanged,
                                          ))),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("MyBusiness") +
                                    ":",
                                style: currentTheme.textTheme.displayLarge,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (mybusiness.isNotEmpty) ...[
                      ...mybusiness.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(
                              top: 12, left: 15, right: 15),
                          child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: currentTheme.canvasColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
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
                                                        currentTheme
                                                            .canvasColor,
                                                    radius: 17,
                                                    child: const Icon(
                                                      Icons.card_travel,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                              e.name ?? "",
                                            ),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                     if(widget.admin)...[ IconButton(
                                        onPressed: () async {
                                          bool returnvale = await _showMyDialog(
                                              context, currentTheme);

                                          if (returnvale) {
                                            context.loaderOverlay.show();
                                            deletefamily(
                                                e.memberid, e.familyid);

                                            // asc();
                                          }
                                        },
                                        icon: Icon(
                                           size: 17,
                                                Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),]
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                            e.relationship ?? "",
                                          ),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
                    ] else ...[
                      Center(child: Text("No business accounts Found..."))
                    ],
                    if (mybusiness.length <= 3 &&!_userProvider.userdata!.userid!.contains('S_')&& !_userProvider.userdata!.userid!.contains('F_')) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 30, bottom: 10),
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
                                  AppLocalizations.of(context)
                                      .translate("Create_Business_Account"),
                                  style: TextStyle(
                                      color: currentTheme.canvasColor,
                                      fontSize: _userProvider.userdata?.language == "Tamil"
                                          ? 12
                                          : 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () async {
                                List returnvale = await _showMyDialog1(
                                    context,
                                    currentTheme,
                                    "DoyouwantBusiness_Account",
                                    "Business_Account_alert");

                                if (returnvale[0]) {
                                  context.loaderOverlay.show();
                                  await businessuser(
                                      "Null",
                                      "Null",
                                      returnvale[1],
                                      "Null",
                                      "Null",
                                      0,
                                      0,
                                      _userProvider.userdata?.language,
                                      _userProvider.userdata?.currency,
                                      "Business");
                                      context.loaderOverlay.show();
                                     Future.delayed(Duration(seconds:0),(){
                                      api();});
                                  context.loaderOverlay.hide();
                                  ScaffoldMessengerState scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green[400],
                                      elevation: 5,
                                      content: Text(
                                          "Your Business account created successfully..!"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ));
  }
}
