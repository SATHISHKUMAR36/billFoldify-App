import 'dart:convert';
import 'dart:io';
import 'package:billfold/add_expenses/Invoicedata/invoice.dart';
import 'package:billfold/add_expenses/submitpage.dart';
import 'package:billfold/bank_details/bankmodel.dart';
import 'package:billfold/bank_details/choosebank.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ExpensePage extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  ExpensePage({super.key, required this.onLanguageChanged});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage>
    with SingleTickerProviderStateMixin {
  final expensecontroller = TextEditingController();

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
    'Rent': "assets/images/rent.png",
    'BankStatement':"assets/images/bankstatement.png"
  };

  bool uploading = false;

  late TabController tabController;
  late UserProvider _userProvider;

  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 1,
    );

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    balance.dispose();
    if (image != null) {
      image = null;
    }
    super.dispose();
  }

  insertinterbank(
      sendacid, sendbank, receiveacid, receivebank, amt, date) async {
    await context.readuser.insertinterbank(
        sendacid, sendbank, receiveacid, receivebank, amt, date);
  }

  updatebank(acid, acname, actype, bankname, acno, bal, share) async {
    await context.readuser
        .updatebank(acid, acname, actype, bankname, acno, bal, share);
  }

  Future<void> uploadimage(filename, ImageDecode) async {
    await context.read<UserProvider>().uploadimage(filename, ImageDecode);
  }

  Future<void> uploadbankstatement(filename, PdfDecode) async {
    await context.read<UserProvider>().uploadbankstatement(filename, PdfDecode);
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
                  height: 180,
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
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf'],);


                                      if (result  != null && result.files.single.extension == 'pdf' && result.files.single.size <= 1024 * 1024) {
                                        PlatformFile  filename = result.files.first;
                                        _onLoading();
                                        File file = File(result.files.single.path!);
                                        image = await file.readAsBytes();
                                        print(image!.length);
                                        if (image != null) {
                                          setState(() {
                                            imagename = filename.name;
                                          });
                                          // imagepath=file.path;
                                          final base64Image =
                                              base64Encode(image!);
                                          await uploadbankstatement(
                                              imagename, base64Image);
                                          setState(() {
                                            uploading = true;
                                          });
                                        }
                                      } else {
                                        Navigator.of(context).pop();
                                          final snackBar = SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(AppLocalizations.of(context)
                                        .translate(
                                            "Upload PDF only with size less than 1 Mb")),
                                    backgroundColor: Colors.red);

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                        print("no file chosen");
                                        uploading = false;
                                      }

                                      if (uploading) {
                                        Future.delayed(Duration.zero, () {
                                         
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
                                                            .file_upload,
                                                        color: Colors.black,
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("BankStatement"),
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

  Future<bool> selectImage() async {
    // Uint8List? img = await pickImage(ImageSource.gallery);
    XFile? file = await _imagepicker.pickImage(source: ImageSource.camera);

    if (file != null) {
      image = await file.readAsBytes();
      if (image != null) {
        setState(() {
          imagename = file.name;
        });
        // imagepath=file.path;
        final base64Image = base64Encode(image!);
        await uploadimage(imagename, base64Image);
        return true;
      }
    } else {
      print("no file chosen");
    }
    return false;
  }

  List<Bank> frombank = [];
  List<Bank> tobank = [];
  List<String>? list;
  String? fromdropdownvalue;
  TextEditingController balance = TextEditingController();
  String? todropdownvalue;
  int? fromacid;
  int? toacid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? currentdate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;

    if (_userProvider.bankdata?.banks == null ||
        _userProvider.bankdata!.banks!.isEmpty) {
      Navigator.pop(context);
      Future.delayed(
          Duration(seconds: 0),
          () => (Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChooseBank(
                        onLanguageChanged: widget.onLanguageChanged,
                      )))));
    }

    list = _userProvider.bankdata!.banks!.map((e) => e.bankname!).toList();

    if (_userProvider.bankdata != null &&
        _userProvider.bankdata!.banks!.isNotEmpty) {
      if (fromdropdownvalue == null) {
        fromdropdownvalue = list?.first;
      }
      if (todropdownvalue == null) {
        todropdownvalue = list?.last;
      }

      frombank = _userProvider.bankdata!.banks!.where((element) {
        return element.bankname == fromdropdownvalue;
      }).toList();
      fromacid = frombank.first.acid;
      tobank = _userProvider.bankdata!.banks!.where((element) {
        return element.bankname == todropdownvalue;
      }).toList();
      toacid = tobank.first.acid;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.canvasColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LandingPage(
                                onLanguageChanged: widget.onLanguageChanged,
                              )),
                      (route) => false,
                    );
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context).translate("Add"),
                  style: currentTheme.textTheme.displayMedium,
                ),
                backgroundColor: currentTheme.canvasColor,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                // floating: true,
                bottom: TabBar(controller: tabController, tabs: [
                  Tab(
                      child: Text(
                    AppLocalizations.of(context).translate("Income"),
                    style: currentTheme.textTheme.displayMedium,
                  )),
                  Tab(
                      child: Text(
                    AppLocalizations.of(context).translate("Expense"),
                    style: currentTheme.textTheme.displayMedium,
                  )),
                  Tab(
                      child: Text(
                    AppLocalizations.of(context).translate("Transfer"),
                    style: currentTheme.textTheme.displayMedium,
                  ))
                ]),
              ),
            ];
          },
          body: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: [
                  SingleChildScrollView(
                    child: Column(children: [
                      if (_userProvider.incomecatdata != null &&
                          _userProvider.incomecatdata!.categories!.isNotEmpty)
                        ..._userProvider.incomecatdata!.categories!.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              catimages[e.categoryname] ??
                                                  "assets/images/category.png",
                                              width: _userProvider
                                                          .userdata!.language ==
                                                      'Tamil'
                                                  ? 30
                                                  : 40,
                                              height: _userProvider
                                                          .userdata!.language ==
                                                      'Tamil'
                                                  ? 40
                                                  : 50,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      '${e.categoryname}'),
                                              style: _userProvider
                                                          .userdata!.language ==
                                                      'Tamil'
                                                  ? currentTheme
                                                      .textTheme.displayMedium
                                                  : currentTheme
                                                      .textTheme.displayLarge,
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubcatExpensepage(
                                            catname: e.categoryname!,
                                            catid: e.categoryid!,
                                            transactiontype: 'Income',
                                            onLanguageChanged:
                                                widget.onLanguageChanged,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                    ]),
                  ),
                  SingleChildScrollView(
                    child: Column(children: [
                      if (_userProvider.categorydata != null &&
                          _userProvider.categorydata!.categories!.isNotEmpty)
                        ..._userProvider.categorydata!.categories!.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              catimages[e.categoryname] ??
                                                  "assets/images/category.png",
                                              width: _userProvider
                                                          .userdata!.language ==
                                                      'Tamil'
                                                  ? 30
                                                  : 40,
                                              height: _userProvider
                                                          .userdata!.language ==
                                                      'Tamil'
                                                  ? 40
                                                  : 50,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      '${e.categoryname}'),
                                              style: _userProvider
                                                          .userdata!.language ==
                                                      'Tamil'
                                                  ? currentTheme
                                                      .textTheme.displayMedium
                                                  : currentTheme
                                                      .textTheme.displayLarge,
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubcatExpensepage(
                                            catname: e.categoryname!,
                                            catid: e.categoryid!,
                                            transactiontype: 'Expense',
                                            onLanguageChanged:
                                                widget.onLanguageChanged,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                    ]),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 55,
                              // width: 100,
                              child: Image.asset(
                                "assets/images/bans.jpg",
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "₹ " +
                                    AppLocalizations.of(context)
                                        .translate("Amount"),
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
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                                          ],
                                          validator: (value) {
                                            var availableValue = value ?? '';
                                            if (availableValue.isEmpty ||
                                                availableValue == '0') {
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
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (list != null) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: DropdownButton(
                                    // Initial Value
                                    value: fromdropdownvalue,

                                    // Down Arrow Icon
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                    ),

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
                                     if(newValue!=todropdownvalue){ setState(() {
                                        fromdropdownvalue = newValue!;
                                      });}
                                    },
                                  ),
                                ),
                              ),
                              Center(
                                  child: SizedBox(
                                height: 25,
                                width: 25,
                                child: Image.asset(
                                  "assets/images/curveright.png",
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: DropdownButton(
                                    // Initial Value
                                    value: todropdownvalue,

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
                                      if (newValue != fromdropdownvalue) {
                                        setState(() {
                                          todropdownvalue = newValue!;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SizedBox(
                                    width: 35,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          currentTheme.primaryColor,
                                      radius: 20,
                                      child: CircleAvatar(
                                          backgroundColor:
                                              currentTheme.canvasColor,
                                          radius: 15,
                                          child: Icon(
                                            Icons.calendar_month,
                                            color: Colors.black,
                                            size: 25,
                                          )),
                                    ),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("Date"),
                                  style: currentTheme.textTheme.displayMedium,
                                ),
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  selectDate(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(currentdate ?? DateTime.now())
                                        .toString(),
                                    style: TextStyle(
                                        color: currentTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 25, bottom: 0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: currentTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("Submit"),
                                    style: TextStyle(
                                      color: currentTheme.canvasColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (_formKey.currentState!.validate() &&
                                      fromdropdownvalue != todropdownvalue) {
                                    insertinterbank(
                                      fromacid,
                                      fromdropdownvalue,
                                      toacid,
                                      todropdownvalue,
                                      num.parse(
                                        balance.text,
                                      ),
                                      DateFormat('yyyy-MM-dd')
                                          .format(currentdate!)
                                          .toString(),
                                    );
                                    updatebank(
                                        frombank.first.acid,
                                        '${frombank.first.actype} account',
                                        frombank.first.actype,
                                        frombank.first.bankname,
                                        num.parse(frombank.first.acnumber!),
                                        (frombank.first.acbalance! -
                                            num.parse(balance.text)),
                                        frombank.first.ishidden);
                                    updatebank(
                                        tobank.first.acid,
                                        '${tobank.first.actype} account',
                                        tobank.first.actype,
                                        tobank.first.bankname,
                                        num.parse(tobank.first.acnumber!),
                                        (tobank.first.acbalance! +
                                            num.parse(balance.text)),
                                        tobank.first.ishidden);

                                    final snackBar = SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text(AppLocalizations.of(
                                                context)
                                            .translate(
                                                "expense_validation_success")),
                                        backgroundColor: Colors.green);
                                    Navigator.pop(context);
                                    // Find the ScaffoldMessenger in the widget tree
                                    // and use it to show a SnackBar.
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (fromdropdownvalue ==
                                      todropdownvalue) {
                                    final snackBar = SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    "cant_transfer_samebank")),
                                        backgroundColor: Colors.red);

                                    // Find the ScaffoldMessenger in the widget tree
                                    // and use it to show a SnackBar.
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ],
          ),
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
      ),
    );
  }
}
