import 'package:billfold/add_expenses/expense.dart';
import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/bank_details/transferedit.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Interbankview extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  Interbankview({super.key, required this.onLanguageChanged});

  @override
  State<Interbankview> createState() => _InterbankviewState();
}

late UserProvider _userProvider;
late ThemeData currentTheme;

class _InterbankviewState extends State<Interbankview> {
  deleteinterbank(transid) async {
    await context.readuser.deleteinterbank(transid);
  }

  List<Bank> frombank = [];
  List<Bank> tobank = [];
  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("Delete_this_transaction"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(
              AppLocalizations.of(context).translate("transactrion_delete"),
              style: currentTheme.textTheme.bodyMedium),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text(AppLocalizations.of(context).translate('No')),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context).translate('Yes')),
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
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;
    currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          elevation: 0.2,
          centerTitle: true,
          title: Text(
              AppLocalizations.of(context).translate("view_bank_transfers"),
              style: TextStyle(
                  color: currentTheme.canvasColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          backgroundColor: currentTheme.primaryColor,
        ),
        body: SingleChildScrollView(
            child: context.watchuser.getinterbanking
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
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_userProvider.interbankdata?.banks != null)
                        ..._userProvider.interbankdata!.banks!.map((e) =>
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // height: 140,
                                decoration: BoxDecoration(
                                    color: currentTheme.canvasColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Image.asset(
                                            "assets/images/bans.jpg",
                                            height: 40,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TransferEdit(
                                                                amount: e.amount
                                                                    .toString(),
                                                                date: e.date!,
                                                                fromdropdownvalue:
                                                                    e.sendbank!,
                                                                todropdownvalue:
                                                                    e.receivebank!,
                                                                transid:
                                                                    e.transid!,
                                                              )));
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate("edit"),
                                                  style: TextStyle(
                                                      fontSize: _userProvider
                                                                  .userdata!
                                                                  .language ==
                                                              'Tamil'
                                                          ? 8
                                                          : 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueGrey),
                                                )),
                                            IconButton(
                                              onPressed: () async {
                                                bool returnvale =
                                                    await _showMyDialog(
                                                        context, currentTheme);

                                                if (returnvale) {
                                                  deleteinterbank(e.transid!);
                                                  frombank = _userProvider
                                                      .bankdata!.banks!
                                                      .where((element) {
                                                    return element.acid ==
                                                        e.Sendacid;
                                                  }).toList();

                                                  tobank = _userProvider
                                                      .bankdata!.banks!
                                                      .where((element) {
                                                    return element.acid ==
                                                        e.receiveacid;
                                                  }).toList();

                                                  updatebank(
                                                      frombank.first.acid,
                                                      "${frombank.first.actype} account",
                                                      frombank.first.actype,
                                                      frombank.first.bankname,
                                                      num.parse(frombank
                                                          .first.acnumber!),
                                                      frombank.first
                                                              .acbalance! +
                                                          e.amount!,
                                                      frombank.first.ishidden);

                                                  updatebank(
                                                      tobank.first.acid,
                                                      "${tobank.first.actype} account",
                                                      tobank.first.actype,
                                                      tobank.first.bankname,
                                                      num.parse(tobank
                                                          .first.acnumber!),
                                                      tobank.first.acbalance! -
                                                          e.amount!,
                                                      tobank.first.ishidden);

                                                  // asc();
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
                                    ),
                                    _userProvider.userdata!.language == 'Tamil'
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(e.sendbank!),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 177, 106, 173)),
                                              ),
                                              Icon(
                                                size: 15,
                                                Icons.arrow_forward_sharp,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(e.receivebank!),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 124, 206, 245)),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(e.sendbank!),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 177, 106, 173)),
                                              ),
                                              Icon(
                                                size: 15,
                                                Icons.arrow_forward_sharp,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate(e.receivebank!),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 124, 206, 245)),
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("total_amt"),
                                              style: currentTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              '${_userProvider.currency} ${commaSepartor(e.amount ?? 0)}',
                                              style: currentTheme
                                                  .textTheme.displayMedium,
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("Createdate"),
                                              style: currentTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              '${DateFormat("dd-MM-yyyy").format(DateTime.parse(e.date.toString()))}',
                                              style: currentTheme
                                                  .textTheme.displayMedium,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 40, bottom: 10),
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
                                      .translate("Create_new_transaction"),
                                  style: TextStyle(
                                      color: currentTheme.canvasColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => (ExpensePage(
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
                            left: 10, right: 10, top: 0, bottom: 40),
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
                                      .translate("goto_dashboard"),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
