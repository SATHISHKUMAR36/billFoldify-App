import 'dart:convert';
import 'dart:typed_data';

import 'package:billfold/add_expenses/Invoicedata/getinvoicemodel.dart';
import 'package:billfold/add_expenses/Invoicedata/invoice.dart';
import 'package:billfold/add_expenses/expense.dart';
import 'package:billfold/add_expenses/expensedit.dart';
import 'package:billfold/add_expenses/expensemodel.dart';
import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Invoiceview extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  Invoiceview({super.key, required this.onLanguageChanged});

  @override
  State<Invoiceview> createState() => _InvoiceviewState();
}

class _InvoiceviewState extends State<Invoiceview> {
  late UserProvider _userProvider;
  bool _isLoading = false;
  Map<String, String> catimages = {
    "Debt": "assets/images/debts.png",
    "Education": "assets/images/education.png",
    "Entertainment": "assets/images/entertainment.png",
    "Food": "assets/images/food.png",
    "Gifts & Donations": "assets/images/gift.png",
    "Health & Wellness": "assets/images/healthcare.png",
    "Housing": "assets/images/home.png",
    "Insurance": "assets/images/insurance.png",
    "Miscellaneous": "assets/images/other.png",
    "Personal Care": "assets/images/personalcare.png",
    "Pet Care": "assets/images/pet.jfif",
    "Savings & Investments": "assets/images/salary.png",
    "Self-Improvement": "assets/images/self-awareness.png",
    "Transportation": "assets/images/shipment.png",
    "Travel": "assets/images/travel.png",
    "Salary": "assets/images/salary.png",
    'Commission': 'assets/images/commision.png',
    'Interest': 'assets/images/interest.png',
    'Scholarship': 'assets/images/scholarship.png',
    'Investments': 'assets/images/investments.png',
    'Retail': 'assets/images/shopping.png',
    'Rent': "assets/images/rent.png",  'BankStatement':"assets/images/bankstatement.png"
  };

  void expenseapi() async {
    if (_userProvider.getinvoicedata?.expenses != null ||
        _userProvider.getinvoicedata!.expenses!.isNotEmpty) {
      filterdata = _userProvider.getinvoicedata!.expenses!
        ..sort((a, b) => b.date!.compareTo(a.date!));
  
    }
  }
  
  List<Getinvoice>? filterdata;
   List<Bank> bank = [];
   List<Expense> expense=[];

  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  deleteexpenseapi(tid) async {
    await context.read<UserProvider>().deleteexpense(tid);
    await _userProvider.getinvoiceitems();
    expenseapi();
  }

    Uint8List? image;
  String? imagename;
  final ImagePicker _imagepicker = ImagePicker();
 void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 40,
            height: 130,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Please Wait..."),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
    Future<void> uploadimage(filename, ImageDecode) async {
    await context.read<UserProvider>().uploadimage(filename, ImageDecode);
  }
  bool uploading = false;
  _showImagePickerOptions(currentTheme) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (
          BuildContext context,
        ) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            {
              bool? loading1 = context.watchuser.imageuploading;
              return SafeArea(
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      loading1
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                circleLoader(context),
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      XFile? file =
                                          await _imagepicker.pickImage(
                                              source: ImageSource.gallery);

                                      if (file != null) {
                                        _onLoading();
                                        image = await file.readAsBytes();
                                        print(image!.length);
                                        if (image != null) {
                                          setState(() {
                                            imagename = file.name;
                                            uploading = true;
                                          });
                                          // imagepath=file.path;
                                          final base64Image =
                                              base64Encode(image!);
                                          await uploadimage(
                                              imagename, base64Image);
                                        }
                                      } else {
                                        print("no file chosen");
                                        uploading = false;
                                      }
                                      if (uploading) {
                                        Future.delayed(Duration.zero, () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InvoiceData(
                                                imagepath:
                                                    '${_userProvider.userdata?.userid}/$imagename',
                                              ),
                                            ),
                                          );
                                        });
                                        Navigator.of(context).pop();
                                      }
                                      uploading = false;
                                    },
                                    child: Row(
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
                                                width: 40,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      currentTheme.primaryColor,
                                                  radius: 20,
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          currentTheme
                                                              .canvasColor,
                                                      radius: 16,
                                                      child: Icon(
                                                        Icons.photo_library,
                                                        color: Colors.black,
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("Phone_library"),
                                              style: currentTheme
                                                  .textTheme.displayLarge,
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
                                    thickness: 2,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      XFile? file =
                                          await _imagepicker.pickImage(
                                              source: ImageSource.camera);

                                      if (file != null) {
                                        _onLoading();
                                        image = await file.readAsBytes();
                                        print(image!.length);
                                        if (image != null) {
                                          setState(() {
                                            imagename = file.name;
                                          });
                                          // imagepath=file.path;
                                          final base64Image =
                                              base64Encode(image!);
                                          await uploadimage(
                                              imagename, base64Image);
                                          setState(() {
                                            uploading = true;
                                          });
                                        }
                                      } else {
                                        print("no file chosen");
                                        uploading = false;
                                      }

                                      if (uploading) {
                                        Future.delayed(Duration.zero, () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InvoiceData(
                                                imagepath:
                                                    '${_userProvider.userdata?.userid}/$imagename',
                                              ),
                                            ),
                                          );
                                        });
                                        Navigator.of(context).pop();
                                      }
                                      uploading = false;
                                    },
                                    child: Row(
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
                                                width: 40,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      currentTheme.primaryColor,
                                                  radius: 20,
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          currentTheme
                                                              .canvasColor,
                                                      radius: 16,
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_rounded,
                                                        color: Colors.black,
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("Camera"),
                                              style: currentTheme
                                                  .textTheme.displayLarge,
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: currentTheme.primaryColor,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }
          });
        });
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

  onrefrsh() async {
    await _userProvider.getinvoiceitems();
    expenseapi();
  }


  @override
  Widget build(BuildContext context) {
       ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
      if (_userProvider.expensedata?.expenses != null) {
      expenseapi();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(AppLocalizations.of(context).translate("myinvoices"),
                  style: currentTheme.textTheme.displayMedium),
              centerTitle: true,
              backgroundColor: currentTheme.canvasColor,
            ),
        body: RefreshIndicator(
            onRefresh: () async {
              {
                return onrefrsh();
              }
            },
            color: currentTheme.primaryColor,
            child: SingleChildScrollView(
                child: context.watchuser.getinvoicing
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
                          if (filterdata != null && filterdata!.isNotEmpty)
                            ...filterdata!.map((e) => Padding(
                                  padding: EdgeInsets.only(
                                      top: 12,
                                      left: _userProvider.userdata?.language ==
                                              'Tamil'
                                          ? 8
                                          : 13,
                                      right: _userProvider.userdata?.language ==
                                              'Tamil'
                                          ? 8
                                          : 13),
                                  child: Container(
                                      // height: 140,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:  Colors.redAccent)),
                                          color: currentTheme.canvasColor,
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      catimages[e.catname] ?? "assets/images/catname.png",
                                                      width: _userProvider
                                                                  .userdata
                                                                  ?.language ==
                                                              'Tamil'
                                                          ? 25
                                                          : 40,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(context)
                                                          .translate(
                                                        e.catname ?? "",
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: _userProvider
                                                                      .userdata
                                                                      ?.language ==
                                                                  'Tamil'
                                                              ? 12
                                                              : 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ExpenseEdit(
                                                                          transacionhistory:
                                                                              false,
                                                                          bankname:
                                                                              e.bankname!,
                                                                          transacionid:
                                                                              e.transactionid!,
                                                                          acid: e
                                                                              .acid!,
                                                                          currency:
                                                                              e.currency!,
                                                                          date: e
                                                                              .date!,
                                                                          description:
                                                                              e.description!,
                                                                          exrate:
                                                                              e.exchangerate!,
                                                                          location:
                                                                              e.location!,
                                                                          merchant:
                                                                              e.merchant!,
                                                                          note: e
                                                                              .note!,
                                                                          receptpath:
                                                                              e.receptpath!,
                                                                          transactiontype:
                                                                              e.transactiontype!,
                                                                          catid: e
                                                                              .catid!,
                                                                          subcatid:
                                                                              e.subcatid!,
                                                                          amt: e
                                                                              .amt!,
                                                                          catname:
                                                                              e.catname!,
                                                                          subcatname:
                                                                              e.subcatname!,
                                                                          onLanguageChanged:
                                                                              widget.onLanguageChanged,
                                                                        )));
                                                      },
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
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
                                                            color:
                                                                Colors.blueGrey),
                                                      )),
                                                  IconButton(
                                                    onPressed: () async {
                                                      bool returnvale =
                                                          await _showMyDialog(
                                                              context,
                                                              currentTheme);
      
                                                      if (returnvale) {
                                                        deleteexpenseapi(
                                                            e.transactionid);
      
                                                           await expense.clear;
      
                                                        expense=_userProvider.expensedata!.expenses!.where((element){
                                                          return element.transactionid==e.transactionid;
                                                        }).toList();
      
                                                        bank = _userProvider
                                                            .bankdata!.banks!
                                                            .where((element) {
                                                          return element.acid ==
                                                             expense.first.acid;
      
                                                        }).toList();
                                                        await updatebank(
                                                            bank.first.acid,
                                                            "${bank.first.actype} account",
                                                            bank.first.actype,
                                                            bank.first.bankname,
                                                            num.parse(bank
                                                                .first.acnumber!),
                                                            bank.first
                                                                    .acbalance! +
                                                                e.amt!,
                                                            bank.first.ishidden);
      
                                                        //////
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                    e.subcatname ?? "",
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: _userProvider
                                                                  .userdata
                                                                  ?.language ==
                                                              'Tamil'
                                                          ? 10
                                                          : 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                    e.bankname ?? "",
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: _userProvider
                                                                  .userdata
                                                                  ?.language ==
                                                              'Tamil'
                                                          ? 10
                                                          : 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black
                                                          .withOpacity(0.8)),
                                                ),
                                              ],
                                            ),
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
                                                    '${_userProvider.currency} ${commaSepartor(e.amt ?? 0)}',
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
                                                    height: 8,
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
                                            height: 10,
                                          ),
      
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:  MainAxisAlignment.start,
                                            children: [
                                                    Text(
                                                      '${e.item_name?.replaceAll('\n', ' ')}',
                                                      style: currentTheme
                                                          .textTheme.bodyMedium,
                                                    ),
                                                    
                                            ],
                                            ),
                                          )
                                        ],
      
      
                                      )),
                                ))
                          else ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 100),
                              child: Center(
                                  child: Text(AppLocalizations.of(context)
                                      .translate("no data found"))),
                            )
                          ],Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 150, bottom: 10),
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
                                left: 10, right: 10, top: 10, bottom: 40),
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
          
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 60,
          ),
          child: InkWell(
            onTap: () async {
              setState(() {
                _isLoading = true;
              });

              await _showImagePickerOptions(currentTheme);

              setState(() {
                _isLoading = false;
              });

              // if (uploading!) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => InvoiceData(
              //         imagepath: '${userdata?.userid}/$imagename',
              //         acid: acid,
              //         note: note.text,
              //       ),
              //     ),
              //   );
              // }
            },
            child: _isLoading
                ? CircularProgressIndicator()
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentTheme.primaryColor,
                    ),
                    height: 45,
                    width: 45,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: currentTheme.canvasColor,
                    )),
          ),
      ),
      
    )); }
}