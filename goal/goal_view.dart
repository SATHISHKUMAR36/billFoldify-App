import 'package:billfold/goal/goal_detail.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/common_function.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class GoalsView extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  const GoalsView({super.key,required this.onLanguageChanged});

  @override
  State<GoalsView> createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("Delete_this_goal"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(AppLocalizations.of(context).translate("goal_delete"),
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

  @override
  void initState() {
    // TODO: implement initState
   
    super.initState();

  }


  void deleteapi(goalid) async {
    await context.read<UserProvider>().deletegoal(goalid);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
    late UserProvider _userProvider; 

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;


  _userProvider=context.watchuser;

    return  SafeArea(
            child: Scaffold(
          backgroundColor: Colors.grey[200],

              appBar: AppBar(
                 leading: IconButton( icon: Icon(Icons.keyboard_arrow_left ,color: Colors.black,),onPressed:() {
          Navigator.pop(
                                context,
          );
        }, ),
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
                backgroundColor: currentTheme.canvasColor,
                automaticallyImplyLeading: false,
                flexibleSpace: Center(
                    child: Text(
                  AppLocalizations.of(context).translate("my_goals"),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
              ),
              
              body: _userProvider.getgoaling? Column(children: [
                      Padding(
                        padding: const EdgeInsets.only( top: 12, left: 15, right: 15),
                        child: ListTile(
                            title: ShimmerWidget.rectangular(
                              height: 180,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),),
                      ),
                     Padding(
                        padding: const EdgeInsets.only( top: 12, left: 15, right: 15),
                        child: ListTile(
                            title: ShimmerWidget.rectangular(
                              height: 180,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),),
                      ),
                     Padding(
                        padding: const EdgeInsets.only( top: 12, left: 15, right: 15),
                        child: ListTile(
                            title: ShimmerWidget.rectangular(
                              height: 180,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),),
                      ),
                    ],): SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    if (_userProvider.goaldata != null && _userProvider.goaldata!.goals!.isNotEmpty)
                      ..._userProvider.goaldata!.goals!.map((e) => Padding(
                            padding: const EdgeInsets.only(
                                top: 12, left: 15, right: 15),
                            child: Container(
                                height: 180,
                                decoration: BoxDecoration(
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
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Text(
                                            e.goalname ?? "",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            (GoalDetails(
                                                              goalname:
                                                                  e.goalname,
                                                              goalid:
                                                                  e.goalid,
                                                              currentamt: e
                                                                  .currentamt
                                                                  .toString(),
                                                              goalamt: e
                                                                  .targetamt
                                                                  .toString(),
                                                              dueamt: e.dueamt
                                                                  .toString(),
                                                              enddate:
                                                                  e.duedate,
                                                              startdate:
                                                                  e.startdate,
                                                              note: e
                                                                  .description,
                                                           onLanguageChanged: widget.onLanguageChanged, ))),
                                                  );
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate("edit"),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueGrey),
                                                )),
                                            IconButton(
                                              onPressed: () async {
                                                bool returnvale =
                                                    await _showMyDialog(
                                                        context,
                                                        currentTheme);
              
                                                if (returnvale) {
                                                  deleteapi(e.goalid);
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
                                              '${_userProvider.currency} ${commaSepartor(e.targetamt ?? 0)}',
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
                                                  .translate("deadline"),
                                              style: currentTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              '${DateFormat("dd-MM-yyyy").format(DateTime.parse(e.duedate.toString()))}',
                                              style: currentTheme
                                                  .textTheme.displayMedium,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Expanded(
                                      child: LinearPercentIndicator(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width /
                                            1.1,
                                        barRadius: const Radius.circular(8),
                                        backgroundColor: Colors.grey,
                                        lineHeight: 6.0,
                                        percent:
                                            (e.currentamt! / e.targetamt!),
                                        progressColor:
                                            currentTheme.primaryColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context).translate("spent")}:${_userProvider.currency} ${commaSepartor(e.currentamt??0)}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            width:  _userProvider.userdata?.language! =='Tamil'?MediaQuery.of(context)
                                                    .size
                                                    .width /
                                              9:MediaQuery.of(context)
                                                    .size
                                                    .width /
                                              6,
                                          ),
                                          Text(
                                              '${AppLocalizations.of(context).translate("left")}:${_userProvider.currency}  ${commaSepartor(e.targetamt! - e.currentamt!)}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ))
                    else ...[Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100),
                      child: Center(child: Text(AppLocalizations.of(context).translate("no data found"))),
                    )],
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10,right:10, top: 100,bottom: 40),
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
                                    .translate("add_new_goal"),
                                style: TextStyle(
                                    color: currentTheme.canvasColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (GoalDetails(onLanguageChanged: widget.onLanguageChanged,))),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ])),
            ),
          );
  }
}
