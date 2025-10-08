import 'package:billfold/add_family/familybasemodel.dart';
import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/bank_details/choosebank.dart';
import 'package:billfold/bank_details/choosecard.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Accounts extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  Accounts({super.key, required this.onLanguageChanged});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

late UserProvider _userProvider; 


  Map<String, String> banklogos = {
    'Bank of India': 'assets/images/banks/boi.jpg',
    'Indian Bank': "assets/images/banks/indianbank.jpg",
    'Canara Bank': "assets/images/banks/canara.jpg",
    'Indian Overseas Bank': "assets/images/banks/iob.png",
    'State Bank of India': "assets/images/banks/sbi.png",
    'Karur Vysya Bank': "assets/images/banks/kvb.png",
    'Axis Bank': "assets/images/banks/axis.jpg",
    'City Union Bank': "assets/images/banks/cub.png",
    'HDFC Bank': "assets/images/banks/hdfc.png",
    'ICICI Bank': "assets/images/banks/icici.jpg",
    'Cash':"assets/images/salary.png"
  };
  num? bankbalance;
  num? cardbalance;
  Familybase? familydata;
  bool fam = true;

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("Delete_this_ac"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(AppLocalizations.of(context).translate("bank_delete"),
              style: currentTheme.textTheme.bodyMedium),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child:  Text(AppLocalizations.of(context).translate('No')),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child:  Text(AppLocalizations.of(context).translate('Yes')),
                  onPressed: () {
                    Navigator.of(context).pop(true);
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

  @override
  void initState() {
    // apidata();
    super.initState();
  }

  List<Bank>? banks = [];
  List<Bank>? cards = [];

apidata() async {

    _userProvider.userdata!.userid!.contains('S_') ? fam = true : fam = false;

    if (_userProvider.bankdata?.banks == null || _userProvider.bankdata!.banks!.isEmpty) {
      bankbalance = 0;
      cardbalance = 0;
    } else {
      banks = _userProvider.bankdata?.banks!.where((element) {
        return element.actype != "Credit Card";
      }).toList();

      if (banks!.isNotEmpty) {
        bankbalance = banks
            ?.map((e) => e.acbalance)
            .toList()
            .reduce((value, element) => value! + element!);
      } else {
        bankbalance = 0;
      }

      cards = _userProvider.bankdata?.banks!.where((element) {
        return element.actype == "Credit Card";
      }).toList();

      if (cards!.isNotEmpty) {
        cardbalance = cards
            ?.map((e) => e.acbalance)
            .toList()
            .reduce((value, element) => value! + element!);
      } else {
        cardbalance = 0;
      }
    }
  }

  void deleteapi(acid) async {
  
    await context.read<UserProvider>().deletebank(acid);

  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

 _userProvider=context.watchuser;
        apidata();
    return  SafeArea(
            child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).translate("Accounts"),
                style: TextStyle(
                    color: currentTheme.canvasColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                onPressed: () async{
                     Navigator.pop(context);
                },
              ),
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              backgroundColor: currentTheme.primaryColor,
            ),
            body: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: Colors.grey.withOpacity(0.1),
              child: SingleChildScrollView(
                child:   _userProvider.getbanking
                  ? Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          title: ShimmerWidget.rectangular(
                            width: 100,
                            height: 130,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    )
                  :  Column(children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height / 4,
                    // width: MediaQuery.of(context).size.width / 1.05,
                    decoration: BoxDecoration(
                        color: currentTheme.canvasColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                            top: 10,
                            left: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate("Current_balance"),
                                style: currentTheme.textTheme.bodySmall,
                              ),
                              Text(
                                '${_userProvider.currency} ${commaSepartor(bankbalance ?? 0)}',
                                style: currentTheme.textTheme.displayLarge,
                              ),
                            ],
                          ),
                        ),
                        //     Divider(
                        //   thickness: 0.3,
                        // ),

                        if (banks != null && banks!.isNotEmpty)
                          ...banks!.map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Divider(
                                      thickness: 2,
                                    ),
                                    
                                   if (!_userProvider.userid!.contains('S_') && !_userProvider.userid!.contains('F_') )...[Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        (ChooseBank(
                                                          acid: e.acid,
                                                          acnumber: e.acnumber
                                                              .toString(),
                                                          actype: e.actype,
                                                          bal: e.acbalance
                                                              .toString(),
                                                          bankname: e.bankname,
                                                          share: e.ishidden,
                                                          onLanguageChanged: widget
                                                              .onLanguageChanged,
                                                        ))),
                                              );
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("edit"),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            )),
                                        IconButton(
                                          onPressed: () async {
                                            bool returnvale =
                                                await _showMyDialog(
                                                    context, currentTheme);

                                            if (returnvale) {
                                              deleteapi(e.acid);
                                            }
                                          },
                                          icon: Icon(
                                            size: 17,
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                   ],
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: SizedBox(
                                                width: _userProvider.userdata?.language ==
                                                        'Tamil'
                                                    ? 25
                                                    : 40,
                                                child: Image.asset(
                                                  banklogos[e.bankname] ??
                                                      "assets/images/bank.png",
                                                ),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate('${e.bankname}'),
                                              style:
                                                  _userProvider.userdata?.language == 'Tamil'
                                                      ? currentTheme.textTheme
                                                          .displayMedium
                                                      : currentTheme.textTheme
                                                          .displayLarge,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${_userProvider.currency} ${commaSepartor(e.acbalance??0)}',
                                          style:
                                              currentTheme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                        else ...[
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: Text(AppLocalizations.of(context)
                                  .translate("No_bank_linked"))),
                          SizedBox(
                            height: 30,
                          ),
                        ]
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //card
                  Container(
                    decoration: BoxDecoration(
                        color: currentTheme.canvasColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                            top: 10,
                            left: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate("Current_card_balance"),
                                style: currentTheme.textTheme.bodySmall,
                              ),
                              Text(
                                '${_userProvider.currency} ${commaSepartor(cardbalance ?? 0)}',
                                style: currentTheme.textTheme.displayLarge,
                              ),
                            ],
                          ),
                        ),
                        //     Divider(
                        //   thickness: 0.3,
                        // ),

                        if (cards != null && cards!.isNotEmpty)
                          ...cards!.map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Divider(
                                      thickness: 2,
                                    ),
                                   if (!_userProvider.userid!.contains('S_') && !_userProvider.userid!.contains('F_') )...[ Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        (ChooseCard(
                                                          acid: e.acid,
                                                          acnumber: e.acnumber
                                                              .toString(),
                                                          actype: e.actype,
                                                          bal: e.acbalance
                                                              .toString(),
                                                          bankname: e.bankname,
                                                          share: e.ishidden,
                                                          onLanguageChanged: widget
                                                              .onLanguageChanged,
                                                        ))),
                                              );
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("edit"),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            )),
                                        IconButton(
                                          onPressed: () async {
                                            bool returnvale =
                                                await _showMyDialog(
                                                    context, currentTheme);

                                            if (returnvale) {
                                              deleteapi(e.acid);
                                            }
                                          },
                                          icon: Icon(
                                            size: 17,
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                   ]
                                   , Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: SizedBox(
                                                width: _userProvider.userdata?.language ==
                                                        'Tamil'
                                                    ? 25
                                                    : 40,
                                                child: Image.asset(
                                                  "assets/images/credit-card.png",
                                                ),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate('${e.bankname}'),
                                              style:
                                                  _userProvider.userdata?.language == 'Tamil'
                                                      ? currentTheme.textTheme
                                                          .displayMedium
                                                      : currentTheme.textTheme
                                                          .displayMedium,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${_userProvider.currency} ${commaSepartor(e.acbalance??0)}',
                                          style:
                                              currentTheme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                        else ...[
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: Text(AppLocalizations.of(context)
                                  .translate("No_card_linked"))),
                          SizedBox(
                            height: 30,
                          ),
                        ]
                      ],
                    ),
                  ),
                  if (!fam) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 100, bottom: 10),
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
                                    .translate("add_new_account"),
                                style: TextStyle(
                                    color: currentTheme.canvasColor,
                                    fontSize:
                                        _userProvider.userdata?.language == "Tamil" ? 12 : 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (ChooseBank(
                                          onLanguageChanged:
                                              widget.onLanguageChanged,
                                        ))),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: currentTheme.canvasColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("add_new_cards"),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        _userProvider.userdata?.language == "Tamil" ? 12 : 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (ChooseCard(
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
                ]),
              ),
            ),
          ));
  }
}
