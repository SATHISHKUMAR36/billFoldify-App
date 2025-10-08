import 'package:billfold/add_expenses/Invoicedata/Invoicebasemodel.dart';
import 'package:billfold/add_expenses/Invoicedata/Invoicemodel.dart';
import 'package:billfold/add_expenses/Invoicedata/getinvoicemodel.dart';
import 'package:billfold/add_expenses/bankstatement/bankstatementbasemodel.dart';
import 'package:billfold/add_expenses/expensebasemodel.dart';
import 'package:billfold/add_expenses/expensedailybase.dart';
import 'package:billfold/add_expenses/expensemodel.dart';
import 'package:billfold/add_expenses/expensesumbase.dart';
import 'package:billfold/add_family/familybasemodel.dart';
import 'package:billfold/add_family/familymodel.dart';
import 'package:billfold/add_family/familyviewbasemodel.dart';
import 'package:billfold/bank_details/bankbasemodel.dart';
import 'package:billfold/bank_details/interbankbasemodel.dart';
import 'package:billfold/budget/budgetbasemodel.dart';
import 'package:billfold/budget/budgetsum.base.dart';
import 'package:billfold/categories/catbasemodel.dart';
import 'package:billfold/categories/incomecatbasemodel.dart';
import 'package:billfold/categories/subcatbasemodel.dart';
import 'package:billfold/goal/goalbasemodel.dart';
import 'package:billfold/recurring_payments/recurringbasemodel.dart';
import 'package:billfold/servises/bilfoldifyApi.dart';
import 'package:billfold/servises/user_model.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserAPIDetails? userdata;
  Bankbase? bankdata;
  Interbankbase? interbankdata;
  Goalbase? goaldata;
  Catbase? categorydata;
  Incomecatbase? incomecatdata;
  Subcatbase? subcategorydata;
  Budgetbase? budgetdata;
  Expensebase? expensedata;
  Familybase? familydata;
  Familyviewbase? familyviewdata;
  Expensesumbase? expensesumdata;
  Expensedailybase? expensedailydata;
  Invoice? invoicedata;
  Invoicebase? getinvoicedata;
  BudgetSumbase? budgetsumdata;
  Recurringbase? recurringpaymentsdata;
   BankStatementbase? bankstatementdata;
  String? userid;
  String? oauthname;
  String? mainusername;
  String? email;
  String? familyid;
  String? parentuserid;
  String? currency;
  String? versionnum;
  num? totalbudget;
  num? spent;
  double? percent;
  num? left;
  num? totalexpense;
  num? totalincome;
  Map<String, double> expensdatachart = {};
  Map<String, double> incomedatachart = {};
  bool userdataloding = false;
  bool getbanking = false;
  bool getinterbanking = false;
  bool getrecurringing = false;
  bool getgoaling = false;
  bool getcat = false;
  bool getinccat = false;
  bool getsubcat = false;
  bool getbudgeting = false;
  bool getexpensing = false;
  bool imageuploading = false;
  bool getinvoicing = false;
  bool addinvoiceitems = false;
  bool getfamiling = false;
  bool viewfamiling = false;
  bool getbankstatementing = false;

  Map<String, dynamic>? data;
  Map<String, dynamic>? update;


  loading() async {
    data = await UserRepository().usertoken;
    userid = data?["username"];
    parentuserid = userid;
    oauthname = data?["oauthname"];
    email = data?["email"];
    await getdata();
    if(userdata!=null && userdata?.userid != null &&userdata?.familylogin != null && userdata?.userid != userdata?.familylogin){
        userid=userdata?.familylogin;
        await getdata();
    }
  update= await BillfoldifyAPI.update();
  versionnum=update?['VersionNumber'];
  }

  family(USerID) {
    userid = USerID;
  }

  loadalldata() {
    getfamily();
    alltransactions();
    getbankdata();
    getbudget();
    getgoaldata();
    getincomecategory();
    getcategory();
    expensesum();
    getsubcategory();
    expensedaily();
    getinterbankdata();
    getrecurringpayments();
    getinvoiceitems();
  }

  Future<dynamic> updateuser(
      email, name, language, cur, notificaton, facelogin, logout,familylogin) async {
    try {
      UserAPIDetails? out;
      out = await BillfoldifyAPI.userupdate(
          parentuserid, email, name, language, cur, notificaton, facelogin, logout,familylogin);
      userdata = out;
      currency = userdata?.currency?.split(' - ')[0];
      notifyListeners();
    } catch (e) {
      print("Error on user update in provider");
    }
  }

  Future<dynamic> deleteuser(userid, email, name) async {
    try {
      await BillfoldifyAPI.deleteuser(userid, email, name);

      notifyListeners();
    } catch (e) {
      print("Error on user delete in provider");
    }
  }

  Future<void> getdata() async {
    userdataloding = true;
    // final data = await UserRepository().usertoken;
    // userid = data!["sub"];
    UserAPIDetails? out;
    try {
      if (userid != null) {
        print(userid);
        out = (await BillfoldifyAPI.getuser(userid));
      } else {
        print("no user id");
      }
    } catch (e) {
      print("fetch to user data error");
    }
    userdata = out;
    if (userdata != null) {
      if ((!userdata!.userid!.contains('S_')) &&
          (!userdata!.userid!.contains('F_'))) {
        mainusername = userdata?.name;
      }
    }
    currency = userdata?.currency?.split(' - ')[0];
    print("fetch to user data success");
    userdataloding = false;
    notifyListeners();
  }

  Future<void> insertbank(acname, actype, bankname, acno, bal, share) async {
    getbanking = true;

    Bankbase? bank;
    try {
      bank = (await BillfoldifyAPI.createBank(
          userid, acname, actype, bankname, acno, bal, share));
    } catch (e) {
      print(e);
      print("fetch to user data error");
    }
    bankdata = bank;
    getbanking = false;
    notifyListeners();
  }

  Future<void> updatebank(
      acid, acname, actype, bankname, acno, bal, share) async {
    getbanking = true;

    Bankbase? bank;
    try {
      bank = (await BillfoldifyAPI.updatebank(
          acid, userid, acname, actype, bankname, acno, bal, share));
    } catch (e) {
      print(e);

      print("fetch to update bank data error");
    }
    bankdata = bank;
    getbanking = false;
    notifyListeners();
  }

  Future<void> deletebank(acid) async {
    getbanking = true;

    Bankbase? bank;
    try {
      bank = (await BillfoldifyAPI.deletebank(acid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete bank data error");
    }
    bankdata = bank;
    getbanking = false;
    notifyListeners();
  }

  Future<void> getbankdata() async {
    Bankbase? bank;
    getbanking = true;
    try {
      bank = (await BillfoldifyAPI.getbank(userid));
    } catch (e) {
      print("fetch to bank data error");
    }
    bankdata = bank;
    getbanking = false;
    print("bank data fetched");

    notifyListeners();
  }

  Future<void> insertgoal(goalname, targetamt, currentamt, dueamt, startdate,
      duedate, description) async {
    getgoaling = true;

    Goalbase? goal;
    try {
      goal = (await BillfoldifyAPI.creategoal(userid, goalname, targetamt,
          currentamt, dueamt, startdate, duedate, description));
    } catch (e) {
      print(e);
      print("create goal data error");
    }
    goaldata = goal;
    getgoaling = false;
    notifyListeners();
  }

  Future<void> updategoal(goalid, goalname, targetamt, currentamt, dueamt,
      startdate, duedate, description) async {
    getgoaling = true;

    // int? goalid;
    // goalid = goaldata!.goalid;
    Goalbase? goal;
    try {
      goal = (await BillfoldifyAPI.updategoal(goalid, userid, goalname,
          targetamt, currentamt, dueamt, startdate, duedate, description));
    } catch (e) {
      print(e);

      print("fetch to update goal data error");
    }
    goaldata = goal;
    getgoaling = false;
    notifyListeners();
  }

  Future<void> deletegoal(goalid) async {
    getgoaling = true;

    Goalbase? goal;
    try {
      goal = (await BillfoldifyAPI.deletegoal(goalid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete goal data error");
    }
    goaldata = goal;
    getgoaling = false;
    notifyListeners();
  }

  Future<void> getgoaldata() async {
    Goalbase? goal;
    getgoaling = true;
    try {
      goal = (await BillfoldifyAPI.getgoal(userid));
    } catch (e) {
      print("fetch to goal data error in provider");
    }
    goaldata = goal;
    getgoaling = false;
    print("goal data fetched");

    notifyListeners();
  }

  Future<void> insertexpensecategory(categoryname, description) async {
    getcat = true;
    Catbase? category;
    try {
      category = (await BillfoldifyAPI.createexpensecategory(
          userid, categoryname, description));
    } catch (e) {
      print(e);
      print("create category data error");
    }
    categorydata = category;
    getcat = false;
    notifyListeners();
  }

  Future<void> insertincomecategory(categoryname, description) async {
    getinccat = true;
    Incomecatbase? categy;
    try {
      categy = (await BillfoldifyAPI.createincomecategory(
          userid, categoryname, description));
    } catch (e) {
      print(e);
      print("create category data error");
    }
    incomecatdata = categy;
    getinccat = false;
    notifyListeners();
  }

  Future<void> updatecategory(categoryid, categoryname, description) async {
    getcat = true;

    Catbase? category;
    try {
      category = (await BillfoldifyAPI.updatecategory(
          categoryid, userid, categoryname, description));
    } catch (e) {
      print(e);

      print("fetch to update category data error");
    }
    categorydata = category;
    getcat = false;
    notifyListeners();
  }

  Future<void> deleteexpensecategory(categoryid) async {
    getcat = true;
    Catbase? category;
    try {
      category =
          (await BillfoldifyAPI.deleteexpensecategory(categoryid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete category data error");
    }
    categorydata = category;
    getcat = false;
    notifyListeners();
  }

  Future<void> deleteincomecategory(categoryid) async {
    getinccat = true;
    Incomecatbase? categy;
    try {
      categy = (await BillfoldifyAPI.deleteincmecategory(categoryid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete category data error");
    }
    incomecatdata = categy;
    getinccat = false;
    notifyListeners();
  }

  Future<void> getcategory() async {
    getcat = true;
    Catbase? category;
    try {
      category = (await BillfoldifyAPI.getexpensecategories(userid));
    } catch (e) {
      print("fetch to categories data error in provider");
    }
    categorydata = category;
    getcat = false;
    print("categories data fetched");

    notifyListeners();
  }

  Future<void> getincomecategory() async {
    getinccat = true;
    Incomecatbase? categy;
    try {
      categy = (await BillfoldifyAPI.getincomecategories(userid));
    } catch (e) {
      print("fetch to income categories data error in provider");
    }
    incomecatdata = categy;
    getinccat = false;
    print("Income categories data fetched");

    notifyListeners();
  }

  Future<void> insertsubcategory(categoryid, categoryname, description) async {
    getsubcat = true;
    Subcatbase? subcategory;
    try {
      subcategory = (await BillfoldifyAPI.createsubcategory(
          categoryid, userid, categoryname, description));
    } catch (e) {
      print(e);
      print("create subcategory data error");
    }
    subcategorydata = subcategory;
    getsubcat = false;
    notifyListeners();
  }

  Future<void> updatesubcategory(
      subcategoryid, categoryid, categoryname, description) async {
    getsubcat = true;
    Subcatbase? subcategory;
    try {
      subcategory = (await BillfoldifyAPI.updatesubcategory(
          subcategoryid, categoryid, userid, categoryname, description));
    } catch (e) {
      print(e);

      print("fetch to update subcategory data error");
    }
    subcategorydata = subcategory;
    getsubcat = false;
    notifyListeners();
  }

  Future<void> deletesubcategory(subcategoryid, categoryid) async {
    getsubcat = true;
    Subcatbase? subcategory;
    try {
      subcategory = (await BillfoldifyAPI.deletesubcategory(
          subcategoryid, categoryid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete subcategory data error");
    }
    subcategorydata = subcategory;
    getsubcat = false;
    notifyListeners();
  }

  Future<void> getsubcategory() async {
    getsubcat = true;
    Subcatbase? subcategory;
    try {
      subcategory = (await BillfoldifyAPI.getsubcategories(userid));
    } catch (e) {
      print("fetch to subcategory data error in provider");
    }
    subcategorydata = subcategory;
    getsubcat = false;
    print("subcategory data fetched");

    notifyListeners();
  }

  Future<void> insertbudget(categoryid, subcategoryid, budgetamt, startdate,
      enddate, frequency, threshold) async {
    getbudgeting = true;
    Budgetbase? budget;
    try {
      budget = (await BillfoldifyAPI.createbudget(userid, categoryid,
          subcategoryid, budgetamt, startdate, enddate, frequency, threshold));
    } catch (e) {
      print(e);
      print("create budget data error");
    }
    await getbudgetsum();
    budgetdata = budget;
    if (budgetdata?.budget == null || budgetdata!.budget!.isEmpty) {
      totalbudget = 0;
    } else {
      totalbudget = budgetdata?.budget
          ?.map((e) => e.budgetamt)
          .toList()
          .reduce((value, element) => value! + element!);
    }

    if (budgetsumdata?.budget == null || budgetsumdata!.budget!.isEmpty) {
      left = totalbudget;
      spent = 0;
      percent = 0;
    } else {
      spent = budgetsumdata?.budget
          ?.map((e) => e.amt)
          .toList()
          .reduce((value, element) => value! + element!);

      left = totalbudget! - spent!;
      double val = spent!.toDouble() / totalbudget!.toDouble();
      if (val >= 0 && val <= 1) {
        percent = val;
      } else if (val >= 1) {
        percent = 1;
      } else {
        percent = 0;
      }
    }
    getbudgeting = false;
    notifyListeners();
  }

  Future<void> updatebudget(budgeid, categoryid, subcategoryid, budgetamt,
      startdate, enddate, frequency, threshold) async {
    getbudgeting = true;
    Budgetbase? budget;
    try {
      budget = (await BillfoldifyAPI.updatebudget(budgeid, userid, categoryid,
          subcategoryid, budgetamt, startdate, enddate, frequency, threshold));
    } catch (e) {
      print(e);

      print("fetch to update budget data error");
    }
    budgetdata = budget;

    if (budgetdata?.budget == null || budgetdata!.budget!.isEmpty) {
      totalbudget = 0;
    } else {
      totalbudget = budgetdata?.budget
          ?.map((e) => e.budgetamt)
          .toList()
          .reduce((value, element) => value! + element!);
    }
    await getbudgetsum();
    if (budgetsumdata?.budget == null || budgetsumdata!.budget!.isEmpty) {
      left = totalbudget;
      spent = 0;
      percent = 0;
    } else {
      spent = budgetsumdata?.budget
          ?.map((e) => e.amt)
          .toList()
          .reduce((value, element) => value! + element!);

      left = totalbudget! - spent!;
      double val = spent!.toDouble() / totalbudget!.toDouble();
      if (val >= 0 && val <= 1) {
        percent = val;
      } else if (val >= 1) {
        percent = 1;
      } else {
        percent = 0;
      }
    }
    getbudgeting = false;
    notifyListeners();
  }

  Future<void> deletebudget(budgetid) async {
    getbudgeting = true;
    Budgetbase? budget;
    try {
      budget = (await BillfoldifyAPI.deletebudget(budgetid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete budget data error");
    }
    budgetdata = budget;
    if (budgetdata?.budget == null || budgetdata!.budget!.isEmpty) {
      totalbudget = 0;
    } else {
      totalbudget = budgetdata?.budget
          ?.map((e) => e.budgetamt)
          .toList()
          .reduce((value, element) => value! + element!);
    }
    await getbudgetsum();

    if (budgetsumdata?.budget == null || budgetsumdata!.budget!.isEmpty) {
      left = totalbudget;
      spent = 0;
      percent = 0;
    } else {
      spent = budgetsumdata?.budget
          ?.map((e) => e.amt)
          .toList()
          .reduce((value, element) => value! + element!);

      left = totalbudget! - spent!;
      double val = spent!.toDouble() / totalbudget!.toDouble();
      if (val >= 0 && val <= 1) {
        percent = val;
      } else if (val >= 1) {
        percent = 1;
      } else {
        percent = 0;
      }
    }
    getbudgeting = false;
    notifyListeners();
  }

  Future<void> getbudget() async {
    getbudgeting = true;
    Budgetbase? budget;
    try {
      budget = (await BillfoldifyAPI.getbudget(userid));
    } catch (e) {
      print("fetch to budget data error in provider");
    }
    budgetdata = budget;
    if (budgetdata?.budget == null || budgetdata!.budget!.isEmpty) {
      totalbudget = 0;
    } else {
      totalbudget = budgetdata?.budget
          ?.map((e) => e.budgetamt)
          .toList()
          .reduce((value, element) => value! + element!);
    }
    await getbudgetsum();
    if (budgetsumdata?.budget == null || budgetsumdata!.budget!.isEmpty) {
      left = totalbudget;
      spent = 0;
      percent = 0;
    } else {
      spent = budgetsumdata?.budget
          ?.map((e) => e.amt)
          .toList()
          .reduce((value, element) => value! + element!);

      left = totalbudget! - spent!;
      double val = spent!.toDouble() / totalbudget!.toDouble();
      if (val >= 0 && val <= 1) {
        percent = val;
      } else if (val >= 1) {
        percent = 1;
      } else {
        percent = 0;
      }
    }
    getbudgeting = false;
    print("budget data fetched");

    notifyListeners();
  }

  Future<void> getbudgetsum() async {
    getbudgeting = true;
    BudgetSumbase? budget;
    try {
      budget = (await BillfoldifyAPI.getbudgetsum(userid));
    } catch (e) {
      print("fetch to getbudgetsum data error in provider");
    }
    budgetsumdata = budget;
    getbudgeting = false;
    print("getbudgetsum data fetched");

    notifyListeners();
  }

  Future<void> insertexpense(
      transactiontype,
      amt,
      description,
      date,
      catid,
      subcatid,
      acid,
      merchant,
      location,
      currency,
      exchangerate,
      receptpath,
      note) async {
    getexpensing = true;
    Expensebase? expense;
    try {
      expense = (await BillfoldifyAPI.createexpense(
          userid,
          transactiontype,
          amt,
          description,
          date,
          catid,
          subcatid,
          acid,
          merchant,
          location,
          currency,
          exchangerate,
          receptpath,
          note));
    } catch (e) {
      print(e);
      print("create expense data error");
    }
    await getbudgetsum();
    if (budgetsumdata?.budget == null || budgetsumdata!.budget!.isEmpty) {
      left = totalbudget;
      spent = 0;
      percent = 0;
    } else {
      spent = budgetsumdata?.budget
          ?.map((e) => e.amt)
          .toList()
          .reduce((value, element) => value! + element!);

      left = totalbudget! - spent!;
      double val = spent!.toDouble() / totalbudget!.toDouble();
      if (val >= 0 && val <= 1) {
        percent = val;
      } else if (val >= 1) {
        percent = 1;
      } else {
        percent = 0;
      }
    }
    ;
    expensedaily();
    expensesum();
    expensedata = expense;

    getexpensing = false;
    notifyListeners();
  }

  Future<void> updateexpense(
      transactionid,
      transactiontype,
      amt,
      description,
      date,
      catid,
      subcatid,
      acid,
      merchant,
      location,
      currency,
      exchangerate,
      receptpath,
      note) async {
    getexpensing = true;
    Expensebase? expense;
    try {
      expense = (await BillfoldifyAPI.updateexpense(
          transactionid,
          userid,
          transactiontype,
          amt,
          description,
          date,
          catid,
          subcatid,
          acid,
          merchant,
          location,
          currency,
          exchangerate,
          receptpath,
          note));
    } catch (e) {
      print(e);

      print("fetch to update expense data error");
    }
    await getbudgetsum();
    if (budgetsumdata?.budget == null || budgetsumdata!.budget!.isEmpty) {
      left = totalbudget;
      spent = 0;
      percent = 0;
    } else {
      spent = budgetsumdata?.budget
          ?.map((e) => e.amt)
          .toList()
          .reduce((value, element) => value! + element!);

      left = totalbudget! - spent!;
      double val = spent!.toDouble() / totalbudget!.toDouble();
      if (val >= 0 && val <= 1) {
        percent = val;
      } else if (val >= 1) {
        percent = 1;
      } else {
        percent = 0;
      }
    }
    expensesum();
    expensedaily();
    expensedata = expense;
    getexpensing = false;
    notifyListeners();
  }

  Future<void> deleteexpense(transactionid) async {
    getexpensing = true;
    Expensebase? expense;
    try {
      expense = (await BillfoldifyAPI.deleteexpense(transactionid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete expense data error");
    }

    await getbudgetsum();
    if (budgetsumdata?.budget == null || budgetsumdata!.budget!.isEmpty) {
      left = totalbudget;
      spent = 0;
      percent = 0;
    } else {
      spent = budgetsumdata?.budget
          ?.map((e) => e.amt)
          .toList()
          .reduce((value, element) => value! + element!);

      left = totalbudget! - spent!;
      double val = spent!.toDouble() / totalbudget!.toDouble();
      if (val >= 0 && val <= 1) {
        percent = val;
      } else if (val >= 1) {
        percent = 1;
      } else {
        percent = 0;
      }
    }
    expensesum();
    expensedaily();
    expensedata = expense;
    getexpensing = false;
    notifyListeners();
  }

  Future<void> alltransactions() async {
    getexpensing = true;
    Expensebase? expense;
    try {
      expense = (await BillfoldifyAPI.alltransactions(userid));
    } catch (e) {
      print("fetch to alltransactions error in provider");
    }
    expensedata = expense;

    getexpensing = false;
    print("alltransactions data fetched");

    notifyListeners();
  }

  Future<void> expensesum() async {
    getexpensing = true;
    Expensesumbase? expense;
    try {
      expense = (await BillfoldifyAPI.expensesum(userid));
    } catch (e) {
      print("fetch to expensesumdata error in provider");
    }
    expensesumdata = expense;
    getexpensing = false;
    print("expensesumdata data fetched");

    notifyListeners();
  }

  Future<void> expensedaily() async {
    getexpensing = true;
    Expensedailybase? expense;
    try {
      expense = (await BillfoldifyAPI.getexpensedaily(userid));
    } catch (e) {
      print("fetch to expensedailydata error in provider");
    }
    expensedailydata = expense;
    getexpensing = false;
    print("expensedailydata data fetched");

    notifyListeners();
  }

  Future<void> uploadimage(filename, ImageDecode) async {
    imageuploading = true;

    try {
      await BillfoldifyAPI.uploadimage(filename, userid, ImageDecode);
    } catch (e) {
      print("fetch to imageuploading data error in provider");
    }

    imageuploading = false;
    print("imageuploading data fetched");

    notifyListeners();
  }

  Future<void> getinvoice(image_path) async {
    getinvoicing = true;
    Invoice? invoice;
    try {
      invoice = (await BillfoldifyAPI.getinvoice(userid, image_path));
      print("invoice data fetched");
    } catch (e) {
      print(e);
      print("fetch to invoice data error in provider");
    }
    invoicedata = invoice;
    getinvoicing = false;

    notifyListeners();
  }

    Future<void> getinvoiceitems() async {
    getinvoicing = true;
    Invoicebase? invoice;
    try {
      invoice = (await BillfoldifyAPI.getinvoiceitems(userid));
      print("invoice data fetched");
    } catch (e) {
      print(e);
      print("fetch to invoice data error in provider");
    }
    getinvoicedata = invoice;
    getinvoicing = false;

    notifyListeners();
  }

  Future<void> insertinvoiceitems(transactionid, items) async {
    addinvoiceitems = true;

    try {
      bool invoiceitems =
          await BillfoldifyAPI.insertinvoiveitems(userid, transactionid, items);
      print("invoice items data inserted $invoiceitems");
    } catch (e) {
      print(e);
      print("fetch to invoice items error in provider");
    }

    addinvoiceitems = false;

    notifyListeners();
  }

  Future<void> insertfamily(FamilyID, email, name, relationship, gender,
      yearofbirth, allowlogin, Language, Currency, username) async {
    getfamiling = true;
    Familybase? family;
    try {
      family = (await BillfoldifyAPI.insertfamilymember(
          userid,
          FamilyID,
          email,
          name,
          relationship,
          gender,
          yearofbirth,
          allowlogin,
          Language,
          Currency,
          username));
    } catch (e) {
      print(e);
      print("create insertfamilymember data error");
    }
    familydata = family;
  if (familydata?.Familes != null && familydata!.Familes!.isNotEmpty) {
      List<Family> sort = familydata!.Familes!.where((element) {
        return element.familyid!.contains("S_");
      }).toList();
      if (sort.isNotEmpty) {
        familyid = sort.first.familyid;
      } else {
        familyid = "Null";
      }
    } else {
      familyid = "Null";
    }
    await viewfamily(familyid);
    getfamiling = false;
    notifyListeners();
  }

  Future<void> updatefamily(
    memberid,
    familyid,
    userid,
    name,
    relationship,
    gender,
    yearofbirth,
    allowlogin,
  ) async {
    getfamiling = true;
    Familybase? family;
    try {
      family = (await BillfoldifyAPI.updatefamily(memberid, familyid, userid,
          name, relationship, gender, yearofbirth, allowlogin));
    } catch (e) {
      print(e);

      print("fetch to update expense data error");
    }
    familydata = family;
    if (familydata?.Familes != null && familydata!.Familes!.isNotEmpty) {
      List<Family> sort = familydata!.Familes!.where((element) {
        return element.familyid!.contains("S_");
      }).toList();
      if (sort.isNotEmpty) {
        familyid = sort.first.familyid;
      } else {
        familyid = "Null";
      }
    } else {
      familyid = "Null";
    }
    await  viewfamily(familyid);
    getfamiling = false;
    notifyListeners();
  }

  Future<void> deletefamily(memberid, childid) async {
    getfamiling = true;
    Familybase? family;
    try {
      family = (await BillfoldifyAPI.deletefamily(memberid, userid, childid));
    } catch (e) {
      print(e);
      print("fetch to delete getfamily data error");
    }
    familydata = family;
    if (familydata?.Familes != null && familydata!.Familes!.isNotEmpty) {
      List<Family> sort = familydata!.Familes!.where((element) {
        return element.familyid!.contains("S_");
      }).toList();
      if (sort.isNotEmpty) {
        familyid = sort.first.familyid;
      } else {
        familyid = "Null";
      }
    } else {
      familyid = "Null";
    }
    await  viewfamily(familyid);
    getfamiling = false;
    notifyListeners();
  }

  Future<void> getfamily() async {
    getfamiling = true;
    Familybase? family;
    try {
      family = (await BillfoldifyAPI.getfamily(parentuserid));
    } catch (e) {
      print("fetch to getfamily data error in provider");
    }
    familydata = family;
    if (familydata?.Familes != null && familydata!.Familes!.isNotEmpty) {
      List<Family> sort = familydata!.Familes!.where((element) {
        return element.familyid!.contains("S_");
      }).toList();
      if (sort.isNotEmpty) {
        familyid = sort.first.familyid;
      } else {
        familyid = "Null";
      }
    } else {
      familyid = "Null";
    }
    await viewfamily(familyid);
    getfamiling = false;
    print("getfamily data fetched");
    notifyListeners();
  }

  Future<void> viewfamily(familyid) async {
    getfamiling = true;
    Familyviewbase? family;
    try {
      family = (await BillfoldifyAPI.viewfamily(familyid, parentuserid));
    } catch (e) {
      print("fetch to viewfamily data error in provider");
    }
    familyviewdata = family;
    getfamiling = false;
    print("viewfamily data fetched");
    notifyListeners();
  }

  Future<void> insertinterbank(
      sendacid, sendbank, receiveacid, receivebank, amt, date) async {
    getinterbanking = true;

    Interbankbase? interbank;
    try {
      interbank = (await BillfoldifyAPI.createInterBank(
          userid, sendacid, sendbank, receiveacid, receivebank, amt, date));
    } catch (e) {
      print(e);
      print("fetch to inser inter bank data error");
    }
    interbankdata = interbank;
    getinterbanking = false;
    notifyListeners();
  }

  Future<void> updateinterbank(
      transid, sendacid, sendbank, receiveacid, receivebank, amt, date) async {
    getinterbanking = true;

    Interbankbase? interbank;
    try {
      interbank = (await BillfoldifyAPI.updateinterbank(transid, userid,
          sendacid, sendbank, receiveacid, receivebank, amt, date));
    } catch (e) {
      print(e);

      print("fetch to update inter bank data error");
    }
    interbankdata = interbank;
    getinterbanking = false;
    notifyListeners();
  }

  Future<void> deleteinterbank(acid) async {
    getinterbanking = true;

    Interbankbase? interbank;
    try {
      interbank = (await BillfoldifyAPI.deleteinterbank(acid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete inter bank data error");
    }
    interbankdata = interbank;
    getinterbanking = false;
    notifyListeners();
  }

  Future<void> getinterbankdata() async {
    getinterbanking = true;
    Interbankbase? interbank;
    try {
      interbank = (await BillfoldifyAPI.getinterbank(userid));
    } catch (e) {
      print("fetch to inter bank data error");
    }
    interbankdata = interbank;
    getinterbanking = false;
    print("inter bank data fetched");
    notifyListeners();
  }

  Future<void> insertrecurringpayments(amount, acid, catid, subcatid, frequency,
      startdate, enddate, nextoccurance, status, note) async {
    getrecurringing = true;
    Recurringbase? recurringpayments;
    try {
      recurringpayments = (await BillfoldifyAPI.createrecurringpayments(
          userid,
          amount,
          acid,
          catid,
          subcatid,
          frequency,
          startdate,
          enddate,
          nextoccurance,
          status,
          note));
    } catch (e) {
      print(e);
      print("fetch to createrecurringpayments data error");
    }
    recurringpaymentsdata = recurringpayments;
    getrecurringing = false;
    notifyListeners();
  }

  Future<void> updaterecurringpayments(
      recurringid,
      amount,
      acid,
      catid,
      subcatid,
      frequency,
      startdate,
      enddate,
      nextoccurance,
      status,
      note) async {
    getrecurringing = true;

    Recurringbase? recurringpayments;
    try {
      recurringpayments = (await BillfoldifyAPI.updaterecurringpayments(
          recurringid,
          userid,
          amount,
          acid,
          catid,
          subcatid,
          frequency,
          startdate,
          enddate,
          nextoccurance,
          status,
          note));
    } catch (e) {
      print(e);

      print("fetch to updaterecurringpayments data error");
    }
    recurringpaymentsdata = recurringpayments;
    getrecurringing = false;
    notifyListeners();
  }

  Future<void> deleterecurringpayments(recurringid) async {
    getrecurringing = true;
    Recurringbase? recurringpayments;
    try {
      recurringpayments =
          (await BillfoldifyAPI.deleterecurringpayments(recurringid, userid));
    } catch (e) {
      print(e);
      print("fetch to delete recurringpayments data error");
    }
    recurringpaymentsdata = recurringpayments;
    getrecurringing = false;
    notifyListeners();
  }

  Future<void> getrecurringpayments() async {
    getrecurringing = true;
    Recurringbase? recurringpayments;
    try {
      recurringpayments = (await BillfoldifyAPI.getrecurringpayments(userid));
    } catch (e) {
      print("fetch to Recurringbase error");
    }
    recurringpaymentsdata = recurringpayments;
    getrecurringing = false;
    print("Recurringbase data fetched");
    notifyListeners();
  }

   Future<void> uploadbankstatement(filename, PdfDecode) async {
    imageuploading = true;

    try {
      await BillfoldifyAPI.uploadbankstatement(filename, userid, PdfDecode);
    } catch (e) {
      print("fetch to uploadbankstatement data error in provider");
    }

    imageuploading = false;
    print("uploadbankstatement data fetched");

    notifyListeners();
  }

    Future<void> getbankstatement(image_path) async {
    getbankstatementing = true;
    BankStatementbase? bankstatement;
    try {
      bankstatement = (await BillfoldifyAPI.getbankstatement(userid, image_path));
      print("invoice data fetched");
    } catch (e) {
      print(e);
      print("fetch to invoice data error in provider");
    }
    bankstatementdata = bankstatement;
    getbankstatementing = false;

    notifyListeners();
  }

}
