import 'package:billfold/add_expenses/expense.dart';
import 'package:billfold/dashboardpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/reports.dart';
import 'package:billfold/settings/settings.dart';
import 'package:billfold/theme_provider.dart';
import 'package:billfold/transactionhistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  int? selectedIndex;

  LandingPage({super.key, required this.onLanguageChanged,this.selectedIndex});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
   PageController controller=PageController();
   
  late List<Widget> pages = [
    DashboardPage(onLanguageChanged: widget.onLanguageChanged),
    Reports(onLanguageChanged: widget.onLanguageChanged),
    TransactionHstory(onLanguageChanged: widget.onLanguageChanged),
    Settingspage(onLanguageChanged: widget.onLanguageChanged)
  ];

  late int _selectedIndex;

  @override
  void initState() {
    if(widget.selectedIndex!=null){
      _selectedIndex=widget.selectedIndex!;
        controller=  PageController(initialPage:_selectedIndex);
    }
    else{
      _selectedIndex = 0;
    }

    super.initState();
  }

  Future<bool> _showMyDialog(context, currentTheme) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate("Exit_app"),
            style: currentTheme.textTheme.displayLarge,
          ),
          content: Text(AppLocalizations.of(context).translate("exitapp_now"),
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
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return PopScope(
       canPop: false,
            onPopInvoked: (bool didPop) async {
              if (didPop) {
                return;
              }
              bool returvalue = await _showMyDialog(context, currentTheme);
              if (returvalue) {
               SystemNavigator.pop();
              }
            },
      child: Scaffold(
body: PageView(
        children: 
          pages,
          scrollDirection: Axis.horizontal,
         
          // reverse: true,
          // physics: BouncingScrollPhysics(),
          controller: controller,
          onPageChanged: (num){
          setState(() {
            _selectedIndex=num;
          });
        },
      ),
        // body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          // shape: const CircularNotchedRectangle(),
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: AppLocalizations.of(context).translate('Dashboard'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
             label: AppLocalizations.of(context).translate('Reports'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: AppLocalizations.of(context).translate('Trasnsactions'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context).translate('Settings'),
            )
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
      
          onTap: (value) {
            
              controller.jumpToPage(value);
              
            
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AnimatedContainer(
            height: 35,
            duration: Duration(milliseconds: 100),
            curve: Curves.bounceIn,
            child: FloatingActionButton(
              elevation: 10,
              autofocus: true,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExpensePage(
                            onLanguageChanged: widget.onLanguageChanged)));
              },
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 22,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}
