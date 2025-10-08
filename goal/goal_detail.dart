import 'package:billfold/goal/goal_finish.dart';
import 'package:billfold/image_picker.dart';
import 'package:billfold/main.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class GoalDetails extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  int? goalid;
  String? goalname;
  String? goalamt;
  String? currentamt;
  String? dueamt;
  String? startdate;
  String? enddate;
  String? note;

  GoalDetails(
      {super.key,
      this.goalid,
      this.goalname,
      this.goalamt,
      this.currentamt,
      this.dueamt,
      this.startdate,
      this.enddate,
      this.note,
      required this.onLanguageChanged});

  @override
  State<GoalDetails> createState() => _GoalDetailsState();
}

class _GoalDetailsState extends State<GoalDetails> {
  bool? update;
  var _goalname = TextEditingController();
  var _goalnote = TextEditingController();
  var _goalamt = TextEditingController();
  var dueamount = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? currentdate = DateTime.now();
  // bool week = false;
  // bool month = true;
  // bool sixmonth = false;
  // bool year = false;

  bool notificaton = true;

  DateTime? duedate = DateTime.now().add(Duration(days: 183));

  insertgoal(goalname, targetamt, currentamt, dueamt, startdate, duedate,
      description) async {
    await context.readuser.insertgoal(goalname, targetamt, currentamt, dueamt,
        startdate, duedate, description);
  }

  updategoal(goalid, goalname, targetamt, currentamt, dueamt, startdate,
      duedate, description) async {
    await context.readuser.updategoal(goalid, goalname, targetamt, currentamt,
        dueamt, startdate, duedate, description);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.goalid != null) {
      update = true;
      _goalname.text = widget.goalname!;
      _goalamt.text = widget.goalamt!;
      dueamount.text = widget.dueamt!;
      _goalnote.text = widget.note!;
      currentdate = DateTime.parse(widget.startdate!);
      duedate = DateTime.parse(widget.enddate!);
    } else {
      update = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    Uint8List? image;
    void selectImage() async {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        image = img;
      });
    }

    Future<void> selectDate(BuildContext context, date, startdate) async {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
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
        if (startdate) {
          currentdate = selectedDate ?? DateTime.now();
        } else {
          duedate = selectedDate ?? DateTime.now().add(Duration(days: 183));
        }
      });
    }

    void dispose() {
      // TODO: implement dispose
      super.dispose();
      _goalname.dispose();
      _goalnote.dispose();
      dueamount.dispose();
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: currentTheme.canvasColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left ,color: Colors.black,)),
        flexibleSpace: Center(
            child: Text(
          AppLocalizations.of(context).translate("New_Goal"),
          style: currentTheme.textTheme.displayMedium,
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context).translate("add_photo"),
                  style: currentTheme.textTheme.bodySmall,
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: image != null
                      ? CircleAvatar(
                          radius: 30, backgroundImage: MemoryImage(image!))
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
                                      Icons.add_a_photo,
                                    )),
                              )),
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppLocalizations.of(context).translate("Goal_name"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15),
                    child: TextFormField(
                      controller: _goalname,
                      decoration: InputDecoration(
                          // hintText: AppLocalizations.of(context).translate(''),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        var availableValue = value ?? '';
                        if (availableValue.isEmpty) {
                          return ("Goal Name is required");
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppLocalizations.of(context).translate("Note"),
                        style: currentTheme.textTheme.displayMedium,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: TextFormField(
                      controller: _goalnote,
                      decoration: InputDecoration(
                          // hintText: AppLocalizations.of(context).translate(''),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      //                    validator: (value) {
                      // var availableValue = value ?? '';
                      // if (availableValue.isEmpty) {
                      //   return ("Goal Name is required");
                      // }
                      // return null;
                      //                    },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: 40,
                              child: CircleAvatar(
                                backgroundColor: currentTheme.primaryColor,
                                radius: 20,
                                child: CircleAvatar(
                                    backgroundColor: currentTheme.canvasColor,
                                    radius: 17,
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate("starting_on"),
                            style: currentTheme.textTheme.displayMedium,
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            selectDate(context, currentdate, true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              DateFormat('dd-MMM-yyyy')
                                  .format(currentdate!)
                                  .toString(),
                              style: TextStyle(
                                  color: currentTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("Req_amt"),
                    style: currentTheme.textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: currentTheme.primaryColor, width: 3))),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            // width: MediaQuery.of(context).size.width / 4,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _goalamt,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: "0"),
                              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                              ],
                              validator: (value) {
                                var availableValue = value ?? '';
                                if (availableValue.isEmpty) {
                                  return ("Enter Valid Amount!");
                                }else if(availableValue=='0'){
return ("Enter Valid Amount!");
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Text(
                      AppLocalizations.of(context).translate("save_amount"),
                      style: currentTheme.textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: currentTheme.primaryColor, width: 3))),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            // width: MediaQuery.of(context).size.width / 4,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: dueamount,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: "0"),
                              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d{0,8}(\.\d{0,2})?')), // Allow digits with optional decimal point and up to two decimal places
                              ],
                              validator: (value) {
                                var availableValue = value ?? '';
                                if (availableValue.isEmpty) {
                                  return ("Enter Valid Amount!");
                                }
                                else if (int.tryParse(availableValue) == int.tryParse(_goalamt.text)){
                                  return ("Both amount is equal");

                                }
                                else if (int.tryParse(availableValue)! > int.tryParse(_goalamt.text)!){
                                  return ("Must be less to target amount");

                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Slider(
                      activeColor: currentTheme.primaryColor,
                      inactiveColor: Colors.grey,
                      value: (double.parse(dueamount.text.isNotEmpty
                              ? dueamount.text
                              : '0')) /
                          (double.parse(
                              _goalamt.text.isNotEmpty ? _goalamt.text : '1')) *
                          100>100?100:(double.parse(dueamount.text.isNotEmpty
                              ? dueamount.text
                              : '0')) /
                          (double.parse(
                              _goalamt.text.isNotEmpty ? _goalamt.text : '1')) *
                          100,
                      max: 100,
                      label: dueamount.text.isNotEmpty ? dueamount.text : '0',
                      onChanged: (double value) {
                        //           setState(() {
                        //             _currentSliderValue = value;
                        //           });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Expanded(
                  //       child: InkWell(
                  //         child: Chip(
                  //           backgroundColor:
                  //               week ? currentTheme.primaryColor : Colors.grey[300],
                  //           side: BorderSide.none,
                  //           label: SizedBox(
                  //               width: 120,
                  //               height: 20,
                  //               child: Center(
                  //                   child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("Once_a_week"),
                  //                       style: TextStyle(
                  //                           fontSize: 12,
                  //                           color:
                  //                               week ? Colors.white : Colors.black)))),
                  //         ),
                  //         onTap: () {
                  //           setState(() {
                  //             week = true;
                  //             month = false;
                  //             year = false;
                  //             sixmonth = false;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: InkWell(
                  //         child: Chip(
                  //           backgroundColor:
                  //               month ? currentTheme.primaryColor : Colors.grey[300],
                  //           side: BorderSide.none,
                  //           label: SizedBox(
                  //               width: 120,
                  //               height: 20,
                  //               child: Center(
                  //                   child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("Once_a_month"),
                  //                       style: TextStyle(
                  //                           fontSize: 12,
                  //                           color:
                  //                               month ? Colors.white : Colors.black)))),
                  //         ),
                  //         onTap: () {
                  //           setState(() {
                  //             week = false;
                  //             month = true;
                  //             year = false;
                  //             sixmonth = false;
                  //           });
                  //         },
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 25,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Expanded(
                  //       child: InkWell(
                  //         child: Chip(
                  //           backgroundColor:
                  //               sixmonth ? currentTheme.primaryColor : Colors.grey[300],
                  //           side: BorderSide.none,
                  //           label: SizedBox(
                  //               width: 120,
                  //               height: 20,
                  //               child: Center(
                  //                   child: Text(
                  //                 AppLocalizations.of(context)
                  //                     .translate("once_in_6_months"),
                  //                 style: TextStyle(
                  //                     fontSize: 12,
                  //                     color: sixmonth ? Colors.white : Colors.black),
                  //               ))),
                  //         ),
                  //         onTap: () {
                  //           setState(() {
                  //             week = false;
                  //             month = false;
                  //             year = false;
                  //             sixmonth = true;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: InkWell(
                  //         child: Chip(
                  //           backgroundColor:
                  //               year ? currentTheme.primaryColor : Colors.grey[300],
                  //           side: BorderSide.none,
                  //           label: SizedBox(
                  //               width: 120,
                  //               height: 20,
                  //               child: Center(
                  //                   child: Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate("Once_a_year"),
                  //                       style: TextStyle(
                  //                           fontSize: 12,
                  //                           color:
                  //                               year ? Colors.white : Colors.black)))),
                  //         ),
                  //         onTap: () {
                  //           setState(() {
                  //             week = false;
                  //             month = false;
                  //             year = true;
                  //             sixmonth = false;
                  //           });
                  //         },
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      radius: 17,
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("Achieve_date"),
                              style: currentTheme.textTheme.displayMedium,
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () {
                              selectDate(context, duedate, false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                DateFormat('dd-MMM-yyyy')
                                    .format(duedate!)
                                    .toString(),
                                style: TextStyle(
                                    color: currentTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate("Receive_alerts"),
                          style: currentTheme.textTheme.displayMedium,
                        ),
                        Switch(
                            value: notificaton,
                            activeColor: currentTheme.primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                notificaton = value;
                              });
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
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
                        AppLocalizations.of(context).translate("Submit"),
                        style: TextStyle(
                            color: currentTheme.canvasColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // context.loaderOverlay.show();
                          if (widget.goalid == null) {
                            insertgoal(
                                _goalname.text,
                                int.parse(_goalamt.text),
                                int.parse(dueamount.text),
                                int.parse(dueamount.text),
                                DateFormat('yyyy-MM-dd')
                                    .format(currentdate!)
                                    .toString(),
                                DateFormat('yyyy-MM-dd')
                                    .format(duedate!)
                                    .toString(),
                                _goalnote.text);
                          } else {
                            updategoal(
                                widget.goalid,
                                _goalname.text,
                                num.parse(_goalamt.text),
                                num.parse(widget.currentamt!),
                                num.parse(dueamount.text),
                                DateFormat('yyyy-MM-dd')
                                    .format(currentdate ?? DateTime.now())
                                    .toString(),
                                DateFormat('yyyy-MM-dd')
                                    .format(duedate ?? DateTime.now())
                                    .toString(),
                                _goalnote.text);
                          }
                          context.loaderOverlay.hide();
                        } catch (e) {
                          print("error in goal insert page");
                        } finally {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (GoalFinish(
                                      update: update!,
                                      onLanguageChanged:
                                          widget.onLanguageChanged,
                                    ))),
                          );
                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => (GoalFinish(
                        //             // goalname: _goalname.text,
                        //             // note: _goalnote.text,
                        //             // startdate: DateFormat('yyyy-MM-dd')
                        //             //     .format(currentdate!)
                        //             //     .toString(),
                        //           ))),
                        // );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
