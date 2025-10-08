import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:billfold/bank_details/bank_final.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ChooseCard extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  int? acid;
  String? bankname;
  String? bal;
  String? actype;
  String? acnumber;
  int? share;

  ChooseCard(
      {super.key,
      this.acid,
      this.bankname,
      this.bal,
      this.share,
      this.acnumber,
      this.actype,
      required this.onLanguageChanged});

  @override
  State<ChooseCard> createState() => _ChooseBankState();
}

bool hide = false;

late AutoCompleteTextField searchTextField;

class _ChooseBankState extends State<ChooseCard> {
  bool? update;

  String? image;

  List<String> filterbankNames = [];
  int currentStep = 0;
  final TextEditingController bankname = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  TextEditingController balance = TextEditingController();
  TextEditingController acnumber = TextEditingController();

  List<String> currencylist = ['Credit Card'];
  String acdefault = 'Credit Card';
  @override
  void initState() {
    if (widget.acid != null) {
      update = true;
      balance.text = widget.bal!;
      acdefault = widget.actype!;
      acnumber.text = widget.acnumber!;
      bankname.text = widget.bankname!;
      widget.share == 0 ? hide = true : hide = false;
    } else {
      update = false;
    }

    super.initState();
  }

  insertbank(acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .insertbank(acname, actype, bankname, acno, bal, share);
  }

  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bankname.dispose();
    balance.dispose();
    acnumber.dispose();
  }

  String No_file_chosen = "No file chosen";

  List<String> bankNames = [
    'Cashback SBI',
    'Axis Bank ACE',
    'HDFC Regalia Gold',
    'SBI Prime',
    'Club Vistara IDFC FIRST',
    'Axis Atlas',
    'HDFC Infinia',
    'HDFC Diners Club Black',
    'BPCL SBI Card Octane',
    'ICICI HPCL Super Saver'
  ];

  onSearchTextChanged(String text) {
    filterbankNames.clear();
    if (text.isEmpty) {
      return image = null;
    } else {
      var pattern = text.toLowerCase();

      filterbankNames.addAll(bankNames.where((element) {
        return element.toLowerCase().contains(pattern);
      }));
    }
    if (mounted) setState(() {});
  }

  List searchresult = [];

  final ScrollController controllerOne = ScrollController();
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
        child: Scaffold(
          backgroundColor: currentTheme.canvasColor,

            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                   
                  );
                },
                icon:  Icon(
                  Icons.keyboard_arrow_left,
                  color:currentTheme.canvasColor,
                ),
              ),
              title: Text(
                AppLocalizations.of(context).translate("Card_Sync"),
                style: TextStyle(
                    color: currentTheme.canvasColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: currentTheme.primaryColor,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // _stepper(currentStep, currentTheme, context),
                      // SizedBox(
                      //   height: 250,
                      //   width: 250,
                      //   child: Image.asset(
                      //     "assets/images/creditcard.png",
                      //   ),
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("enter_card"),
                                style: currentTheme.textTheme.displayLarge)),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Row(
                          children: [
                            if (image != null) ...[
                              Image.asset(
                                image!,
                                width: 40,
                                height: 50,
                              )
                            ],
                            SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: TextFormField(
                                onChanged: onSearchTextChanged,
                                controller: bankname,
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .translate('card_name'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  var availableValue = value ?? '';
                                  if (availableValue.isEmpty) {
                                    return ("Enter Valid Card Name!");
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          controller: controllerOne,
                          shrinkWrap: true,
                          itemCount: filterbankNames.length,
                          itemBuilder: (context, index) {
                            String? imagename =
                                // banklogos[filterbankNames[index]];
                                "assets/images/credit-card.png";
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  image = imagename;
                                  bankname.text = filterbankNames[index];
                                  filterbankNames.clear();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 30, top: 15),
                                child: Row(
                                  children: [
                                    if (imagename != null) ...[
                                      Image.asset(
                                        imagename,
                                        width: 40,
                                        height: 35,
                                      ),
                                    ],
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate(filterbankNames[index]),
                                        style: currentTheme
                                            .textTheme.displayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "₹ " +
                                AppLocalizations.of(context)
                                    .translate("card_balance"),
                            style: currentTheme.textTheme.displayLarge,
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: currentTheme.primaryColor,
                                          width: 3))),
                              width: MediaQuery.of(context).size.width / 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    // width: MediaQuery.of(context).size.width / 4,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: balance,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "0"),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                                      ],
                                      validator: (value) {
                                        var availableValue = value ?? '';
                                        if (availableValue.isEmpty) {
                                          return ("Enter Valid Amount!");
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Align(
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         AppLocalizations.of(context)
                      //             .translate("Transaction_history"),
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold, fontSize: 16),
                      //       )),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 15.0, vertical: 15),
                      //     child: Container(
                      //       height: 60,
                      //       width: MediaQuery.of(context).size.width / 1.1,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Colors.grey.withOpacity(0.2)),
                      //       child: InkWell(
                      //         onTap: () async {
                      //           FilePickerResult? result =
                      //               await FilePicker.platform.pickFiles();
                      //           if (result != null) {
                      //             setState(() {
                      //               No_file_chosen = result.names.first!;
                      //             });
                      //           }
                      //         },
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceEvenly,
                      //           children: [
                      //             Text(
                      //               No_file_chosen,
                      //               style: currentTheme.textTheme.displaySmall,
                      //             ),
                      //             const Icon(
                      //               Icons.file_upload,
                      //               color: Colors.black,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     )),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("CardNumber"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 50, top: 15, bottom: 15),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: acnumber,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: 'XXXX'),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d{0,19}')),
                                // Allow digits with optional decimal point and up to two decimal places
                              ],
                              validator: (value) {
                                var availableValue = value ?? '';
                                if (availableValue.isEmpty) {
                                  return ("Enter Valid card Number!");
                                }
                                return null;
                              },
                            ),
                          )),

                      SizedBox(
                        height: 25,
                      ),
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
                                    radius: 25,
                                    child: CircleAvatar(
                                      backgroundColor: currentTheme.canvasColor,
                                      radius: 16,
                                      child: Image.asset(
                                        height: 25,
                                        "assets/images/atm.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("CardType"),
                                style: currentTheme.textTheme.displayLarge,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:10.0),
                            child: DropdownButton(
                              // Initial Value
                              alignment: Alignment.centerRight,
                              value: acdefault,
                            
                              // Down Arrow Icon
                              icon: Icon(Icons.keyboard_arrow_down),
                            
                              // Array list of items
                              items: currencylist.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    AppLocalizations.of(context).translate(items),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  acdefault = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(15),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //           AppLocalizations.of(context)
                      //               .translate("share_account"),
                      //           style: currentTheme.textTheme.displayLarge),
                      //       Switch(
                      //           value: hide,
                      //           activeColor: currentTheme.primaryColor,
                      //           onChanged: (bool value) {
                      //             setState(() {
                      //               hide = value;
                      //             });
                      //           })
                      //     ],
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 100, bottom: 80),
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
                                      .translate("Submit"),
                                  style: TextStyle(
                                      color: currentTheme.canvasColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  // var acid =, userid=, acname=, actype=, bankname=bankname, acno= , bal=, ifsc=ifsccode.text, hidden=0;
                                  try {
                                    context.loaderOverlay.show();
                                    if (widget.acid == null) {
                                      insertbank(
                                          "$acdefault account",
                                          acdefault,
                                          bankname.text,
                                          num.parse(acnumber.text),
                                          num.parse(balance.text),
                                          hide ? 0 : 1);
                                      context.loaderOverlay.hide();
                                    } else {
                                      updatebank(
                                          widget.acid,
                                          "$acdefault account",
                                          acdefault,
                                          bankname.text,
                                          num.parse(acnumber.text),
                                          num.parse(balance.text),
                                          // hide ? 0 : 
                                          1);
                                      context.loaderOverlay.hide();
                                    }
                                  } catch (e) {
                                    print("error in card insert page");
                                  } finally {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => (BankFinal(
                                                onLanguageChanged:
                                                    widget.onLanguageChanged,
                                                update: update!,
                                              ))),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            )));
  }
}
