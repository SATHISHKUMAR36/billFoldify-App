import 'dart:typed_data';

import 'package:billfold/add_family/familybasemodel.dart';
import 'package:billfold/add_family/familymodel.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'image_picker.dart';
import 'main.dart';

class UserInfo extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  String language;
  UserInfo(
      {super.key, required this.language, required this.onLanguageChanged});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  void initState() {
    family();
    // TODO: implement initState
    super.initState();
  }

  final name = TextEditingController();
  List<String> items = [
    "₹ - Indian Rupee",
    "\$ -  Singapore dollar (SGD)",
    "€ - Euro",
    "\$ - US Dollar",
    "£ - British Pound",
    "¥ - Japanese Yen",
  ];
  String currecydefault = '₹ - Indian Rupee';

  Uint8List? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Family? fam;

  Familybase? familydata;
  family() {
    familydata = context.readuser.familydata;
    if (familydata != null && familydata!.Familes!.isNotEmpty) {
      name.text = familydata!.Familes!.first.name!;
      fam = familydata?.Familes?.first;
    }
  }

  bool face = true;
  bool notificaton = true;

  fetchuser() async {
    await context.readuser.updateuser(_userProvider.email,name.text.trim(), widget.language,
        currecydefault, notificaton ? 1 : 0, face ? 1 : 0, 0   ,_userProvider.userdata?.userid);
  }

  familyupdate(memberid, familyid, userid, name, relationship, gender,
      yearofbirth, allowlogin) async {
    await context.readuser.updatefamily(memberid, familyid, userid, name,
        relationship, gender, yearofbirth, allowlogin);
  }
late UserProvider _userProvider;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
        if (_userProvider.oauthname!=null) {
  name.text=_userProvider.oauthname!;
}
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.canvasColor,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: currentTheme.primaryColor,
          title: Text(
            AppLocalizations.of(context).translate("UserDetails"),
            style: TextStyle(
                color: currentTheme.canvasColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  AppLocalizations.of(context).translate("add_your_photo"),
                  style: currentTheme.textTheme.bodySmall,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: _image != null
                      ? CircleAvatar(
                          radius: 30, backgroundImage: MemoryImage(_image!))
                      : CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              currentTheme.primaryColor.withOpacity(0.5),
                          child: CircleAvatar(
                              radius: 25,
                              backgroundColor: currentTheme.primaryColor,
                              child: Center(
                                child: IconButton(
                                    color: currentTheme.canvasColor,
                                    onPressed: () {
                                      selectImage();
                                    },
                                    icon: Icon(
                                      Icons.person_add_alt_1_rounded,
                                    )),
                              )),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context).translate("what_is_your_name"),
                    style: currentTheme.textTheme.displayLarge,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                      key: _formKey,
                      child:context.watchuser.oauthname!=null ?Text(context.watchuser.oauthname!,style: TextStyle(color:Colors.blue,fontSize: 16,fontWeight: FontWeight.bold),): TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context).translate('Name'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          var availableValue = value ?? '';
                          if (availableValue.isEmpty) {
                            return ("Name is required");
                          }
                          return null;
                        },
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate("choose_currency"),
                    style: currentTheme.textTheme.displayLarge,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButton(
                  // Initial Value
                  value: currecydefault,

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
                      currecydefault = newValue!;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate("Login_with_face"),
                      style: currentTheme.textTheme.displayLarge,
                    ),
                    Switch(
                        value: face,
                        activeColor: currentTheme.primaryColor,
                        onChanged: (bool value) {
                          setState(() {
                            face = value;
                            print(face);
                          });
                        })
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //         AppLocalizations.of(context)
                //             .translate("get_notifications"),
                //         style: currentTheme.textTheme.displayLarge),
                //     Switch(
                //         value: notificaton,
                //         activeColor: currentTheme.primaryColor,
                //         onChanged: (bool value) {
                //           setState(() {
                //             notificaton = value;r
                //           });
                //         })
                //   ],
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
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
                            AppLocalizations.of(context)
                                .translate("goto_dashboard"),
                            style: TextStyle(
                                color: currentTheme.canvasColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              context.loaderOverlay.show();
                              await fetchuser();
                              if (familydata != null &&
                                  familydata!.Familes!.isNotEmpty) {
                                familyupdate(
                                    fam!.memberid,
                                    fam!.familyid,
                                    fam!.userid,
                                    name.text.trim(),
                                    fam!.relationship,
                                    fam!.gender,
                                    fam!.yob,
                                    1);
                              }
                              context.loaderOverlay.hide();
                            } catch (e) {
                              print("error in face page");
                            } finally {
                              context.loaderOverlay.hide();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LandingPage(
                                          onLanguageChanged:
                                              widget.onLanguageChanged,
                                        )),
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
