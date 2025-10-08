import 'package:billfold/add_family/familybasemodel.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/main.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/user_model.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class Addfamily extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  const Addfamily({super.key, required this.onLanguageChanged});

  @override
  State<Addfamily> createState() => _AddfamilyState();
}

class _AddfamilyState extends State<Addfamily> {
  Familybase? familydata;
    UserAPIDetails? userdata;
      String? languagedefault;

  String? currecydefault;
  String? username;

    @override
  void initState() {
    // TODO: implement initState
  
    
    super.initState();
  }
  

api()async{
  userdata =  await context.watchuser.userdata;
      currecydefault = userdata?.currency;
      languagedefault = userdata?.language;
        username = userdata?.name;
}

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController name = TextEditingController();
    TextEditingController yob = TextEditingController();
  bool face = false;

  List<String> relationitems = [
    'Parent',
    'Child',
    'Sibling',
    'Spouse/Partner',
    'In-law',
    'Roommate'
  ];
  String relationdefault = 'Child';

    List<String> genderitems = [
    'Male',
    'Female',
    'Other'
  ];
  String genderdefault = 'Male';

  fetchuser( FamilyID,email,
          name,
          relationship,
          gender,
          yearofbirth,
          allowlogin,  Language,
          Currency,username) async {
    await context.readuser.insertfamily(FamilyID, email,
          name,
          relationship,
          gender,
          yearofbirth,
          allowlogin , Language,
          Currency,username);
  }

  late UserProvider _userProvider;
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    _userProvider = context.watchuser;
api();
    return SafeArea(
        child: Scaffold(
          backgroundColor: currentTheme.canvasColor,

      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate("Add_Family_member"),
          style: currentTheme.textTheme.displayMedium,
        ),
        backgroundColor: currentTheme.canvasColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate('Name'),
                      labelStyle: currentTheme.textTheme.displaySmall,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    var availableValue = value ?? '';
                    if (availableValue.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate("Name_is_required");
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate('Email'),
                      labelStyle: currentTheme.textTheme.displaySmall,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    var availableValue = value ?? '';
                    if (availableValue.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate("email_requierd");
                    } else if (!availableValue.contains('@')) {
                      return AppLocalizations.of(context).translate("valid_mail");
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate("Choose_relationship"),
                      style: currentTheme.textTheme.displayLarge,
                    ),
                    DropdownButton(
                      // Initial Value
                      value: relationdefault,
          
                      // Down Arrow Icon
                      icon: Icon(Icons.keyboard_arrow_down),
          
                      // Array list of items
                      items: relationitems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          relationdefault = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: yob,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('Year_Of_Birth'),
                      labelStyle: currentTheme.textTheme.displaySmall,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d{0,4}()?')), // Allow digits with optional decimal point and up to two decimal places
                  ],
                  validator: (value) {
                    var availableValue = value ?? '';
                    if (availableValue.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate("yob_requierd");
                    } else if (int.tryParse(availableValue)! >
                        DateTime.now().year ||int.tryParse(availableValue)! <
                        DateTime.now().year-100) {
                      return AppLocalizations.of(context).translate("valid_yob");
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate("Choose_gender"),
                      style: currentTheme.textTheme.displayLarge,
                    ),
                    DropdownButton(
                      // Initial Value
                      value: genderdefault,
          
                      // Down Arrow Icon
                      icon: Icon(Icons.keyboard_arrow_down),
          
                      // Array list of items
                      items: genderitems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          genderdefault = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: currentTheme.primaryColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: InkWell(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("Add_Family_member"),
                            style: TextStyle(
                                color: currentTheme.canvasColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
            try {
              context.loaderOverlay.show();
              
  await fetchuser(  _userProvider.familyid??"Null",_emailcontroller.text.trim(),name.text.trim(),relationdefault,genderdefault,int.tryParse(yob.text),1,languagedefault,currecydefault,username);
 context.loaderOverlay.hide();
              ScaffoldMessengerState scaffoldMessenger =
            ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[400],
            elevation: 5,
            content: Text("Your Family account created successfully..!"),
          ),
          
        );
        context.loaderOverlay.hide();
              Navigator.pop(context);

} on Exception catch (e) {
 context.loaderOverlay.hide();
              ScaffoldMessengerState scaffoldMessenger =
            ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[400],
            elevation: 5,
            content: Text(e.toString()),
          ),
        );
}
          
             
          
              
            }
          
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
