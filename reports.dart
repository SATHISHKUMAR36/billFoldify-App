import 'package:billfold/add_expenses/expense.dart';
import 'package:billfold/add_expenses/expensesum.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class Reports extends StatefulWidget {
   final void Function(Locale) onLanguageChanged;
  Reports({super.key,required this.onLanguageChanged});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void initState() {
    // TODO: implement initState
 

    super.initState();
  }

  List<Expensesum>? incomedata;
  List<Expensesum>? expensedata;
  late UserProvider _userProvider;


  @override
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;

    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    if (_userProvider.expensesumdata?.expenses != null) {
  if(_userProvider.expensesumdata!.expenses!.isNotEmpty){
    
  expensedata=_userProvider.expensesumdata!.expenses!..sort((a, b) => a.date!.compareTo(b.date!));
    }
     if(_userProvider.expensesumdata!.incomes!.isNotEmpty){
  incomedata=_userProvider.expensesumdata!.incomes!..sort((a, b) => a.date!.compareTo(b.date!));
    }
}

    return  SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  shape: RoundedRectangleBorder(),
                  elevation: 0.2,
                  centerTitle: true,
                  title: Text(AppLocalizations.of(context).translate("Reports"),
                      style: TextStyle(
                          color: currentTheme.canvasColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  backgroundColor: currentTheme.primaryColor,
                ),
                body: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Container(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 9,
                      decoration:
                          BoxDecoration(color: currentTheme.primaryColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Text(
                            //   AppLocalizations.of(context)
                            //       .translate("Your_Profit")
                            //       +' :',
                            //   style: TextStyle(
                            //     color: currentTheme.canvasColor.withOpacity(0.7),fontSize: 13
                            //   ),
                            // ),
                            // const SizedBox(
                            //   width: 15,
                            // ),
                            // Text('0',
                            //     style: TextStyle(
                            //         color: currentTheme.canvasColor,
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width / 1.1,
                                decoration: BoxDecoration(
                                    color: currentTheme.canvasColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("Income"),
                                      style:
                                          currentTheme.textTheme.displayLarge,
                                    ),
                                    VerticalDivider(
                                      thickness: 3,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("Expense"),
                                      style:
                                          currentTheme.textTheme.displayLarge,
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2.3,
                              width: MediaQuery.of(context).size.width / 1.1,
                              decoration: BoxDecoration(
                                  color: currentTheme.canvasColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: SfCartesianChart(
                                enableAxisAnimation: true,
                                tooltipBehavior: TooltipBehavior(enable: true),
                                legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom,
                                ),
                                primaryXAxis: DateTimeCategoryAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                  // minorGridLines: MinorGridLines(width: 0),
                                  labelRotation: 90,
                                  isVisible: true,
                                  labelAlignment: LabelAlignment.center,
                                  labelPosition:
                                      ChartDataLabelPosition.outside,
                                  rangePadding: ChartRangePadding.none,
                                  axisLine: AxisLine(
                                      width: 2, dashArray: <double>[5, 5]),
                                  labelStyle: context.watchtheme.currentTheme
                                      .textTheme.headlineSmall,
                                  dateFormat: DateFormat('MMM-yyyy'),
                                ),
                                primaryYAxis: NumericAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                  minorGridLines: MinorGridLines(width: 0),
                                  majorTickLines:
                                      const MajorTickLines(size: 0),
                                ),
                                series: <CartesianSeries>[
                                  ColumnSeries<Expensesum, DateTime>(
                                    width: 0.5,
                                    spacing: 0.2,
                                    emptyPointSettings: EmptyPointSettings(
                                        mode: EmptyPointMode.drop),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    animationDuration: 1000,
                                    animationDelay: 1000,
                                    name: 'Income',
                                    color: currentTheme.primaryColor,
                                    dataSource:
                                         incomedata??[],
                                    xValueMapper:
                                        (Expensesum data, _) =>
                                            data.datetimedata,
                                    yValueMapper:
                                        (Expensesum incomedata, _) =>
                                            incomedata.amt,
                                            
                                    enableTooltip: true,
                                  ),
                                  ColumnSeries<Expensesum, DateTime>(
                                    width: 0.5,
                                    spacing: 0.2,
                                    emptyPointSettings: EmptyPointSettings(
                                        mode: EmptyPointMode.drop),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    animationDuration: 1000,
                                    animationDelay: 1000,
                                    name: 'Expense',
                                    color: currentTheme.disabledColor,
                                    dataSource:
                                        expensedata??[],
                                     xValueMapper:
                                        (Expensesum data, _) =>
                                            data.datetimedata,
                                        yValueMapper:
                                        (Expensesum data, _) =>
                                            data.amt,
                                    enableTooltip: true,
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.1,
                              decoration: BoxDecoration(
                                  color: currentTheme.canvasColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LandingPage(onLanguageChanged: widget.onLanguageChanged,selectedIndex: 2),
                                          ),(route) => false,);
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SizedBox(
                                        width: 40,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              currentTheme.primaryColor,
                                          radius: 20,
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  currentTheme.canvasColor,
                                              radius: 16,
                                              child: Icon(
                                                Icons.restore,
                                                color: Colors.black,
                                              )),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("Trasnsaction_History"),
                                      style:
                                          currentTheme.textTheme.displayMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 40,
                         width: MediaQuery.of(context).size.width / 1.1,

                 
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
                                  builder: (context) => (ExpensePage(onLanguageChanged: widget.onLanguageChanged,))),
                            );
                          },
                        ),
                      ),
                    ),
                 
                             SizedBox(
                              height: 40,
                            ),
                            
                          ],
                        ),
                      ),
                    ), ],
                )),
          );
  }
}
