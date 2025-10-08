import 'package:billfold/add_family/familymodel.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/storage.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/signuppage.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UsernameChange extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  const UsernameChange({super.key, required this.onLanguageChanged});

  @override
  State<UsernameChange> createState() => _UsernameChangeState();
}

class _UsernameChangeState extends State<UsernameChange> {
  late UserProvider _userProvider;
  int? memberid;
  Future<List> _showMyDialog(context, currentTheme, title, content) async {
    //  userdata = await context.read<UserProvider>().userdata;
    String? username = _userProvider.userdata?.name;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    name.text = username ?? '';
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
                ? title == "Doyouwantchangeyourname" ||
                        title == "Doyouwantdelete_account"
                    ? 200
                    : 110
                : title == "Doyouwantchangeyourname" ||
                        title == "Doyouwantdelete_account"
                    ? 155
                    : 75,
            child: Column(
              children: [
                Text(AppLocalizations.of(context).translate(content),
                    style: currentTheme.textTheme.bodyMedium),
                if (title == "Doyouwantchangeyourname") ...[
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
                          return AppLocalizations.of(context)
                              .translate("please change your name");
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
                    if (title == "Doyouwantchangeyourname") {
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

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
    List<Family>? famlst;
    if (memberid == null) {
      famlst = _userProvider.familydata?.Familes?.where((element) {
        return element.actype == "Parent" &&
            element.userid == _userProvider.parentuserid;
      }).toList();
      if (famlst != null) {
        memberid = famlst.first.memberid;
      }
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPage(
                    onLanguageChanged: widget.onLanguageChanged,
                    selectedIndex: 3),
              ),
              (route) => false,
            );
          },
        ),
        title: Text(AppLocalizations.of(context).translate("UserDetails"),
            style: TextStyle(
                color: currentTheme.canvasColor,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        backgroundColor: currentTheme.primaryColor,
      ),
      body: SingleChildScrollView(
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
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CircleAvatar(
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
                                  // selectImage();
                                },
                                icon: Icon(
                                  Icons.person_rounded,
                                )),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
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
                                      child: const Icon(
                                        Icons.person_2_outlined,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Text(
                              _userProvider.userdata?.name ?? '',
                              style: currentTheme.textTheme.displayLarge,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            List returnvale = await _showMyDialog(
                                context,
                                currentTheme,
                                "Doyouwantchangeyourname",
                                "name_alert");
                            if (returnvale[0]) {
                              context.loaderOverlay.show();
                              await context.readuser.updateuser(
                                  _userProvider.email,
                                  returnvale[1],
                                  _userProvider.userdata?.language,
                                  _userProvider.userdata?.currency,
                                  _userProvider.userdata?.notificaton,
                                  _userProvider.userdata?.facelogin,
                                  _userProvider.userdata?.logout,
                                  _userProvider.userdata?.familylogin
                                  );
                              context.loaderOverlay.hide();

                              if (memberid != null && famlst != null) {
                                await context.readuser.updatefamily(
                                    memberid,
                                    famlst.first.familyid,
                                    famlst.first.userid,
                                    returnvale[1],
                                    famlst.first.relationship,
                                    famlst.first.gender,
                                    famlst.first.yob,
                                    1);
                              }
                              final snackBar = SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text(AppLocalizations.of(context)
                                      .translate("save_snackbar")),
                                  backgroundColor: Colors.green);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context).translate("edit"),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      launchUrlString(
                        "https://www.billfoldify.com/#AboutUs",
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: currentTheme.primaryColor,
                              radius: 20,
                              child: CircleAvatar(
                                  backgroundColor: currentTheme.canvasColor,
                                  radius: 16,
                                  child: const Icon(
                                    Icons.list_outlined,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("About_us"),
                          style: currentTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            if ((!_userProvider.userdata!.userid!.contains('S_') &&
                !_userProvider.userdata!.userid!.contains('F_'))) ...[
              Container(
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      List returnvale = await _showMyDialog(
                          context,
                          currentTheme,
                          "Doyouwantdelete_account",
                          "delete_alert");
                      if (returnvale[0]) {
                        context.loaderOverlay.show();
                        try {
                          await UserProvider().deleteuser(
                              _userProvider.userdata?.userid,
                              _userProvider.userdata?.email,
                              _userProvider.userdata?.name);
                          Future.delayed(Duration(seconds: 1), () async {
                            await UserRepository().removeUser();
                            CommonLocalStorage prefs =
                                await CommonLocalStorage.getInstance();
                            await prefs.clear();
                          });
                          context.loaderOverlay.hide();
                          final snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(AppLocalizations.of(context)
                                  .translate(
                                      "your account deleteed successfully...!")),
                              backgroundColor: Colors.green);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          Future.delayed(Duration(seconds: 1), () {
                            // SystemNavigator.pop();

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(
                                    language: "English",
                                    onLanguageChanged: widget.onLanguageChanged,
                                  ),
                                ),
                                (route) => false);
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: currentTheme.primaryColor,
                              radius: 20,
                              child: CircleAvatar(
                                  backgroundColor: currentTheme.canvasColor,
                                  radius: 16,
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("delete_account"),
                          style: currentTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      launchUrlString(
                        "https://billfoldify.com/privacy-policy.html",
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: currentTheme.primaryColor,
                              radius: 20,
                              child: CircleAvatar(
                                  backgroundColor: currentTheme.canvasColor,
                                  radius: 16,
                                  child: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("Privacy_policy"),
                          style: currentTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      launchUrlString(
                        "https://billfoldify.com/end-user-license-agreement.html",
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: currentTheme.primaryColor,
                              radius: 20,
                              child: CircleAvatar(
                                  backgroundColor: currentTheme.canvasColor,
                                  radius: 16,
                                  child: const Icon(
                                    Icons.document_scanner,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translate("EULA"),
                          style: currentTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      launchUrlString(
                        "https://billfoldify.com/cancellationandrefundpolicy.html",
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: currentTheme.primaryColor,
                              radius: 20,
                              child: CircleAvatar(
                                  backgroundColor: currentTheme.canvasColor,
                                  radius: 16,
                                  child: const Icon(
                                    Icons.cancel_presentation,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("cancellation_policy"),
                          style: currentTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: currentTheme.canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      launchUrlString(
                        "https://billfoldify.com/#Contact",
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: currentTheme.primaryColor,
                              radius: 20,
                              child: CircleAvatar(
                                  backgroundColor: currentTheme.canvasColor,
                                  radius: 16,
                                  child: const Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translate("Contactus"),
                          style: currentTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 20),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "visit our website ",
                        style: currentTheme.textTheme.headlineMedium),
                    WidgetSpan(
                        child: InkWell(
                            onTap: () =>
                                launchUrlString('https://billfoldify.com/'),
                            child: Text("www.billfoldify.com",
                                style: currentTheme.textTheme.headlineMedium!
                                    .copyWith(
                                        color: currentTheme.primaryColor)))),
                    TextSpan(
                        text: " for latest updates",
                        style: currentTheme.textTheme.headlineMedium),
                  ]),
                ),
              ),
            ]
          ],
        ),
      ),
    ));
  }
}
