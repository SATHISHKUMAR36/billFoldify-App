import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bankstatement extends StatefulWidget {
  String imagepath;
  Bankstatement({
    super.key,
    required this.imagepath,
  });

  @override
  State<Bankstatement> createState() => _BankstatementState();
}

class _BankstatementState extends State<Bankstatement> {
  DateTime? selectedDate;
  DateTime? currentdate = DateTime.now();
  int? catid;
  int? subcatid;
  List<Bank> bank = [];
  List<String>? list;
  String? dropdownvalue;
  int? acid;
  late UserProvider _userProvider;

  Future<void> selectDate(BuildContext context) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // header background color
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      currentdate = selectedDate ?? DateTime.now();
    });
  }

  invoiceapi(image_path) async {
    await context.read<UserProvider>().getbankstatement(image_path);
    _userProvider.bankstatementdata = context.readuser.bankstatementdata;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
    if (dropdownvalue == null) {
      invoiceapi(widget.imagepath);
      if (_userProvider.bankdata?.banks == null ||
          _userProvider.bankdata!.banks!.isEmpty) {
        list = <String>[];
        acid = 0;
      } else {
        list = _userProvider.bankdata!.banks!.map((e) => e.bankname!).toList();

        dropdownvalue = list!.first;
      }
    }

    if (_userProvider.bankdata != null) {
      if (_userProvider.bankdata!.banks!.isNotEmpty) {
        var acts = _userProvider.bankdata!.banks!.where((element) {
          return element.bankname == dropdownvalue;
        });
        acid = acts.first.acid;
        bank = _userProvider.bankdata!.banks!.where((element) {
          return element.acid == acid;
        }).toList();
      }
    }

    return Scaffold(
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
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate("BankStatement"),
            style: currentTheme.textTheme.displayMedium,
          ),
          backgroundColor: currentTheme.canvasColor,
        ),
        body: (_userProvider.getbankstatementing)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  circleLoader(context),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: SizedBox(
                              width: 35,
                              child: CircleAvatar(
                                backgroundColor: currentTheme.primaryColor,
                                radius: 20,
                                child: CircleAvatar(
                                  backgroundColor: currentTheme.canvasColor,
                                  radius: 15,
                                  child: Image.asset(
                                    height: 20,
                                    "assets/images/bank.png",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate("Select_account"),
                            style: currentTheme.textTheme.displayMedium,
                          ),
                        ],
                      ),
                      list != null
                          ? DropdownButton(
                              // Initial Value
                              value: dropdownvalue,

                              // Down Arrow Icon
                              icon: Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: list!.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                  dropdownvalue ??
                                      AppLocalizations.of(context)
                                          .translate("Nil"),
                                  style: currentTheme.textTheme.displayMedium),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              )));
  }
}
