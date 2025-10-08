import 'dart:convert';
import 'package:billfold/add_expenses/Invoicedata/Invoicebasemodel.dart';
import 'package:billfold/add_expenses/bankstatement/bankstatementbasemodel.dart';
import 'package:billfold/add_expenses/expensebasemodel.dart';
import 'package:billfold/add_expenses/expensedailybase.dart';
import 'package:billfold/add_expenses/expensesumbase.dart';
import 'package:billfold/add_family/familybasemodel.dart';
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
import 'package:billfold/servises/user_model.dart';
import 'package:http/http.dart' as http;

import '../add_expenses/Invoicedata/Invoicemodel.dart';

import 'package:billfold/config.dart';

class BillfoldifyAPI {
  static Future<UserAPIDetails> userupdate(
      String? UserID,
      String? Email,
      String Name,
      String Language,
      String currency,
      int notification,
      int FaceFingerLogin,
      int UserLogout,
      String FamilyLogin) async {
    final url;
    url = Uri.parse('${URL}userdetails');
    print(url);

    Map<String, dynamic> body = {
      "UserID": UserID,
      "Email": Email,
      "Name": Name,
      "Language": Language,
      "Currency": currency,
      "Notification": notification,
      "FaceFingerLogin": FaceFingerLogin,
      "UserLogout": UserLogout,
      "FamilyLogin": FamilyLogin
    };

    print(body);
    try {
      var response = await http.patch(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        return getuser(UserID);
      }
      return Future.error("Error in user update method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on user update method");
    }
  }

  static Future<UserAPIDetails> getuser(String? UserId) async {
    final url = Uri.parse('${URL}userdetails');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        Map<String, dynamic> userdata = jsonData['userdetails'][0];

        return UserAPIDetails.fromJson(userdata);
      }
      return Future.error("Error in user post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on user post method");
    }
  }

  static Future deleteuser(
    String? userid,
    String? email,
    String? name,
  ) async {
    final url = Uri.parse('${URL}userdetails');
    final body = jsonEncode(<String, dynamic>{
      "UserID": userid,
      "Email": email,
      "Name": name,
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return true;

      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update bank.');
    }
  }

  static Future createBank(String? userid, String? acname, String? actype,
      String? bankname, int? acno, num? bal, int? hidden) async {
    final url = Uri.parse('${URL}addbank');
    final body = jsonEncode(<String, dynamic>{
      "UserID": userid,
      "AccountName": acname,
      "AccountType": actype,
      "BankName": bankname,
      "AccountNumber": acno,
      "Balance": bal,
      "Hidden": hidden
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getbank(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create bank.');
    }
  }

  static Future updatebank(
      int? acid,
      String? userid,
      String? acname,
      String? actype,
      String? bankname,
      num? acno,
      num? bal,
      int? hidden) async {
    final url = Uri.parse('${URL}bankdetails');
    final body = jsonEncode(<String, dynamic>{
      "AccountID": acid,
      "UserID": userid,
      "AccountName": acname,
      "AccountType": actype,
      "BankName": bankname,
      "AccountNumber": acno,
      "Balance": bal,
      "Hidden": hidden
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getbank(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update bank.');
    }
  }

  static Future deletebank(
    int? acid,
    String? userid,
  ) async {
    final url = Uri.parse('${URL}bankdetails');
    final body = jsonEncode(<String, dynamic>{
      "AccountID": acid,
      "UserID": userid,
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getbank(userid);

      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update bank.');
    }
  }

  static Future<Bankbase> getbank(String? UserId) async {
    final url = Uri.parse('${URL}bankdetails');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Bankbase.fromMap(jsonData);
      }
      return Future.error("Error in bank view post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on bank view method");
    }
  }

  static Future creategoal(
      String? userid,
      String? goalname,
      num? targetamt,
      num? currentamt,
      num? dueamt,
      String? startdate,
      String? duedate,
      String? description) async {
    final url = Uri.parse('${URL}addgoal');
    final body = jsonEncode(<String, dynamic>{
      'UserID': userid,
      'GoalName': goalname,
      'TargetAmount': targetamt,
      'CurrentAmount': currentamt,
      'DueAmount': dueamt,
      'StartDate': startdate,
      'DueDate': duedate,
      'Description': description
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getgoal(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create goal.');
    }
  }

  static Future<Goalbase> getgoal(String? UserId) async {
    final url = Uri.parse('${URL}goaldetails');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // List<dynamic> goaldata = jsonData['goaldetails'];

        return Goalbase.fromMap(jsonData);
      }
      return Future.error("Error in goals view post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on goal view method");
    }
  }

  static Future updategoal(
      int? goalid,
      String? userid,
      String? goalname,
      num? targetamt,
      num? currentamt,
      num? dueamt,
      String? startdate,
      String? duedate,
      String? description) async {
    final url = Uri.parse('${URL}goaldetails');
    final body = jsonEncode(<String, dynamic>{
      "GoalID": goalid,
      'UserID': userid,
      'GoalName': goalname,
      'TargetAmount': targetamt,
      'CurrentAmount': currentamt,
      'DueAmount': dueamt,
      'StartDate': startdate,
      'DueDate': duedate,
      'Description': description
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getgoal(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update goal.');
    }
  }

  static Future deletegoal(
    int? goalid,
    String? userid,
  ) async {
    final url = Uri.parse('${URL}goaldetails');
    final body = jsonEncode(<String, dynamic>{
      "GoalID": goalid,
      "UserID": userid,
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getgoal(userid);
    } else {
      throw Exception('Failed to delete bank.');
    }
  }

  static Future<Catbase> getexpensecategories(String? UserId) async {
    final url = Uri.parse('${URL}categories');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Catbase.fromMap(jsonData);
      }
      return Future.error("Error in category post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on category view method");
    }
  }

  static Future<Incomecatbase> getincomecategories(String? UserId) async {
    final url = Uri.parse('${URL}incomecategories');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Incomecatbase.fromMap(jsonData);
      }
      return Future.error("Error in income category post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on income category view method");
    }
  }

  static Future<Subcatbase> getsubcategories(String? UserId) async {
    final url = Uri.parse('${URL}subcategories');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Subcatbase.fromMap(jsonData);
      }
      return Future.error("Error in category post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on category view method");
    }
  }

  static Future createexpensecategory(
      String? userid, String? categoryname, String? description) async {
    final url = Uri.parse('${URL}addcategory');
    final body = jsonEncode(<String, dynamic>{
      'UserID': userid,
      'CategoryName': categoryname,
      'Description': description
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getexpensecategories(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create categories.');
    }
  }

  static Future createincomecategory(
      String? userid, String? categoryname, String? description) async {
    final url = Uri.parse('${URL}addcategory');
    final body = jsonEncode(<String, dynamic>{
      'UserID': userid,
      'CategoryName': categoryname,
      'Description': description
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getincomecategories(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create categories.');
    }
  }

  static Future updatecategory(int? categoryid, String? userid,
      String? categoryname, String? description) async {
    final url = Uri.parse('${URL}categories');
    final body = jsonEncode(<String, dynamic>{
      "CategoryID": categoryid,
      'UserID': userid,
      'CategoryName': categoryname,
      'Description': description
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getexpensecategories(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update category.');
    }
  }

  static Future deleteexpensecategory(int? categoryid, String? userid) async {
    final url = Uri.parse('${URL}categories');
    final body = jsonEncode(
        <String, dynamic>{"CategoryID": categoryid, 'UserID': userid});
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getexpensecategories(userid);
    } else {
      throw Exception('Failed to delete categories.');
    }
  }

  static Future deleteincmecategory(int? categoryid, String? userid) async {
    final url = Uri.parse('${URL}categories');
    final body = jsonEncode(
        <String, dynamic>{"CategoryID": categoryid, 'UserID': userid});
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getincomecategories(userid);
    } else {
      throw Exception('Failed to delete categories.');
    }
  }

  static Future createsubcategory(int? categoryid, String? userid,
      String? subcategoryname, String? description) async {
    final url = Uri.parse('${URL}addsubcategory');
    final body = jsonEncode(<String, dynamic>{
      "CategoryID": categoryid,
      'UserID': userid,
      'SubcategoryName': subcategoryname,
      'Description': description
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getsubcategories(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create subcategory.');
    }
  }

  static Future updatesubcategory(int? subcategoryid, int? categoryid,
      String? userid, String? subcategoryname, String? description) async {
    final url = Uri.parse('${URL}subcategories');
    final body = jsonEncode(<String, dynamic>{
      "SubcategoryID": subcategoryid,
      "CategoryID": categoryid,
      'UserID': userid,
      'SubcategoryName': subcategoryname,
      'Description': description
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getsubcategories(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update sub category.');
    }
  }

  static Future deletesubcategory(
      int? subcategoryid, int? categoryid, String? userid) async {
    final url = Uri.parse('${URL}subcategories');
    final body = jsonEncode(
        <String, dynamic>{"SubcategoryID": subcategoryid, 'UserID': userid});
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getsubcategories(userid);
    } else {
      throw Exception('Failed to delete subcategories.');
    }
  }

  static Future<Budgetbase> getbudget(String? UserId) async {
    final url = Uri.parse('${URL}budgetdetails');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Budgetbase.fromMap(jsonData);
      }
      return Future.error("Error in budgetdetails post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on budgetdetails view method");
    }
  }

  static Future<BudgetSumbase> getbudgetsum(String? UserId) async {
    final url = Uri.parse('${URL}budgetview');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return BudgetSumbase.fromMap(jsonData);
      }
      return Future.error("Error in budgetview post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on budgetview view method");
    }
  }

  static Future createbudget(
      String? userid,
      int? categoryid,
      int? subcategoryid,
      num? budgetamt,
      String? startdate,
      String? enddate,
      String? frequency,
      int? alertThreshold) async {
    final url = Uri.parse('${URL}addbudget');
    final body = jsonEncode(<String, dynamic>{
      'UserID': userid,
      'CategoryID': categoryid,
      'SubcategoryID': subcategoryid,
      'BudgetAmount': budgetamt,
      'StartDate': startdate,
      'EndDate': enddate,
      'Frequency': frequency,
      'AlertThreshold': alertThreshold
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      getbudgetsum(userid);
      return getbudget(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create budget.');
    }
  }

  static Future updatebudget(
      int? budgeid,
      String? userid,
      int? categoryid,
      int? subcategoryid,
      num? budgetamt,
      String? startdate,
      String? enddate,
      String? frequency,
      num? alertThreshold) async {
    final url = Uri.parse('${URL}budgetdetails');
    final body = jsonEncode(<String, dynamic>{
      'BudgetID': budgeid,
      'UserID': userid,
      'CategoryID': categoryid,
      'SubcategoryID': subcategoryid,
      'BudgetAmount': budgetamt,
      'StartDate': startdate,
      'EndDate': enddate,
      'Frequency': frequency,
      'AlertThreshold': alertThreshold
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      getbudgetsum(userid);
      return getbudget(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update  budgetdetails.');
    }
  }

  static Future deletebudget(int? budgetid, String? userid) async {
    final url = Uri.parse('${URL}budgetdetails');
    final body = jsonEncode(<String, dynamic>{
      'BudgetID': budgetid,
      'UserID': userid,
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      getbudgetsum(userid);
      return getbudget(userid);
    } else {
      throw Exception('Failed to delete budgetdetails.');
    }
  }

  static Future<Expensebase> alltransactions(String? UserId) async {
    final url = Uri.parse('${URL}alltransactions');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Expensebase.fromMap(jsonData);
      }
      return Future.error("Error in expensedetails post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on expensedetails view method");
    }
  }

  static Future<Expensedailybase> getexpensedaily(String? UserId) async {
    final url = Uri.parse('${URL}expensedetails');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Expensedailybase.fromMap(jsonData);
      }
      return Future.error("Error in Expensedailybase post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on Expensedailybase view method");
    }
  }

  static Future<Expensesumbase> expensesum(String? UserId) async {
    final url = Uri.parse('${URL}expensesum');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Expensesumbase.fromMap(jsonData);
      }
      return Future.error("Error in expensesum post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on expensesum view method");
    }
  }

  static Future createexpense(
      String? userid,
      String? transactiontype,
      num? amt,
      String? description,
      String? date,
      int? catid,
      int? subcatid,
      int? acid,
      String? merchant,
      String? location,
      String? currency,
      num? exchangerate,
      String? receptpath,
      String? note) async {
    final url = Uri.parse('${URL}addexpense');
    final body = jsonEncode(<String, dynamic>{
      'UserID': userid,
      'TransactionType': transactiontype,
      'Amount': amt,
      'Description': description,
      'Date': date,
      'CategoryID': catid,
      'SubcategoryID': subcatid,
      'AccountID': acid,
      'Merchant': merchant,
      'Location': location,
      'Currency': currency,
      'ExchangeRate': exchangerate,
      'ReceiptPath': receptpath,
      'Note': note
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return alltransactions(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create expense.');
    }
  }

  static Future updateexpense(
      int? transactionid,
      String? userid,
      String? transactiontype,
      num? amt,
      String? description,
      String? date,
      int? catid,
      int? subcatid,
      int? acid,
      String? merchant,
      String? location,
      String? currency,
      num? exchangerate,
      String? receptpath,
      String? note) async {
    final url = Uri.parse('${URL}expensedetails');
    final body = jsonEncode(<String, dynamic>{
      'TransactionID': transactionid,
      'UserID': userid,
      'TransactionType': transactiontype,
      'Amount': amt,
      'Description': description,
      'Date': date,
      'CategoryID': catid,
      'SubcategoryID': subcatid,
      'AccountID': acid,
      'Merchant': merchant,
      'Location': location,
      'Currency': currency,
      'ExchangeRate': exchangerate,
      'ReceiptPath': receptpath,
      'Note': note
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return alltransactions(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update  expensedetails.');
    }
  }

  static Future deleteexpense(int? transactionid, String? userid) async {
    final url = Uri.parse('${URL}expensedetails');
    final body = jsonEncode(<String, dynamic>{
      'TransactionID': transactionid,
      'UserID': userid,
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return alltransactions(userid);
    } else {
      throw Exception('Failed to delete expensedetails.');
    }
  }

  static Future uploadimage(
      String? FileName, String? userid, String? ImageDecode) async {
    final url = Uri.parse('${URL}invoiceimageupload');
    final body = jsonEncode(<String, dynamic>{
      'FileName': FileName,
      'UserID': userid,
      'ImageDecode': ImageDecode
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return true;
    } else {
      print(response.body);
      throw Exception('Failed to upload images in S3.');
    }
  }

  static Future<Invoice> getinvoice(String? UserId, String? image_path) async {
    final url = Uri.parse('${URL}invoicedataextraction');
    final body = {'UserID': UserId, 'image_path': image_path};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Invoice.fromJson(jsonData['extracted_data']);
      }
      return Future.error("Error in Invoicebase post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on Invoicebase view method");
    }
  }

  static Future<Invoicebase> getinvoiceitems(String? UserId) async {
    final url = Uri.parse('${URL}getinvoiceitems');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Invoicebase.fromMap(jsonData);
      }
      return Future.error("Error in getinvoiceitems post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on getinvoiceitems view method");
    }
  }

  static Future insertinvoiveitems(
      String? UserId, num? transactionid, Invoice? items) async {
    final url = Uri.parse('${URL}invoiceitems');

    final body = {
      'UserID': UserId,
      'TransactionID': transactionid,
      'Items': {
        'items': [items?.tojon()]
      }
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        print(jsonData);
        return true;
      } else {
        return Future.error("Error in Invoice items post method");
      }
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on Invoice items  method");
    }
  }

  static Future insertfamilymember(
      String? UserId,
      String? FamilyID,
      String? Email,
      String? Name,
      String? Relationship,
      String? Gender,
      num? YearOfBirth,
      int MemberAllowedLogin,
      String? Language,
      String? Currency,
      String? UserName) async {
    final url = Uri.parse('${URL}addfamilymember');

    final body = {
      'UserID': UserId,
      'FamilyID': FamilyID,
      'Email': Email,
      'Name': Name,
      'Relationship': Relationship,
      'Gender': Gender,
      'YearOfBirth': YearOfBirth,
      'MemberAllowedLogin': MemberAllowedLogin,
      "Language": Language,
      "Currency": Currency,
      "UserName": UserName
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        print(jsonData);
        return getfamily(UserId);
      } else {
        return Future.error("Error in addfamilymember post method");
      }
    } on Exception catch (e) {
      print("addfamilymember" + e.toString());

      throw Exception("Error on addfamilymember method");
    }
  }

  static Future<Familybase> getfamily(String? UserId) async {
    final url = Uri.parse('${URL}familydetails');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Familybase.fromMap(jsonData);
      }
      return Future.error("Error in Familybase post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on Familybase view method");
    }
  }

  static Future updatefamily(
      int? memberid,
      String? FamilyID,
      String? UserId,
      String? Name,
      String? Relationship,
      String? Gender,
      num? YearOfBirth,
      int MemberAllowedLogin) async {
    final url = Uri.parse('${URL}familydetails');
    final body = jsonEncode(<String, dynamic>{
      'MemberID': memberid,
      'UserID': UserId,
      'FamilyID': FamilyID,
      'Name': Name,
      'Relationship': Relationship,
      'Gender': Gender,
      'YearOfBirth': YearOfBirth,
      'MemberAllowedLogin': MemberAllowedLogin
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getfamily(UserId);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update  getfamily.');
    }
  }

  static Future deletefamily(
      int? memberid, String? userid, String? childid) async {
    final url = Uri.parse('${URL}familydetails');
    final body = jsonEncode(<String, dynamic>{
      'MemberID': memberid,
      'UserID': userid,
      'ChildID': childid
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getfamily(userid);
    } else {
      throw Exception('Failed to delete Family.');
    }
  }

  static Future<Familyviewbase> viewfamily(
      String? FamilyID, String? UserId) async {
    final url = Uri.parse('${URL}familyview');
    final body = {
      'FamilyID': FamilyID,
      'UserID': UserId,
    };
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Familyviewbase.fromMap(jsonData);
      }
      return Future.error("Error in Familybase post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on Familybase view method");
    }
  }

  static Future createInterBank(String? userid, int? sendacno, String? sendbank,
      int? receiveacno, String? receviebank, num? amt, String? date) async {
    final url = Uri.parse('${URL}addinterbank');
    final body = jsonEncode(<String, dynamic>{
      "UserID": userid,
      "SendAccountID": sendacno,
      "ReciveBankName": receviebank,
      "SendBankName": sendbank,
      "ReceiveAccountID": receiveacno,
      "Amount": amt,
      "Date": date
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getinterbank(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create inter bank.');
    }
  }

  static Future updateinterbank(
      int? transid,
      String? userid,
      int? sendacno,
      String? sendbank,
      int? receiveacno,
      String? receviebank,
      num? amt,
      String? date) async {
    final url = Uri.parse('${URL}interbankdetails');
    final body = jsonEncode(<String, dynamic>{
      "TransID": transid,
      "UserID": userid,
      "SendAccountID": sendacno,
      "ReciveBankName": receviebank,
      "SendBankName": sendbank,
      "ReceiveAccountID": receiveacno,
      "Amount": amt,
      "Date": date
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getinterbank(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update inter bank.');
    }
  }

  static Future deleteinterbank(
    int? transid,
    String? userid,
  ) async {
    final url = Uri.parse('${URL}interbankdetails');
    final body = jsonEncode(<String, dynamic>{
      "TransID": transid,
      "UserID": userid,
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getinterbank(userid);

      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update inter bank.');
    }
  }

  static Future<Interbankbase> getinterbank(String? UserId) async {
    final url = Uri.parse('${URL}interbankdetails');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Interbankbase.fromMap(jsonData);
      }
      return Future.error("Error in inter bank view post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on inter bank view method");
    }
  }

  static Future createrecurringpayments(
    String? userid,
    num? amount,
    int? acid,
    int? catid,
    int? subcatid,
    String? frequency,
    String? startdate,
    String? enddate,
    String? nextoccurance,
    String? status,
    String? note,
  ) async {
    final url = Uri.parse('${URL}addrecurringpayments');
    final body = jsonEncode(<String, dynamic>{
      'UserID': userid,
      'Amount': amount,
      'AccountID': acid,
      'CategoryID': catid,
      'SubCategoryID': subcatid,
      'Frequency': frequency,
      'StartDate': startdate,
      'EndDate': enddate,
      'NextOccurance': nextoccurance,
      'Status': status,
      'Note': note
    });

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getrecurringpayments(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create recurringpayments.');
    }
  }

  static Future updaterecurringpayments(
    int? recurringid,
    String? userid,
    num? amount,
    int? acid,
    int? catid,
    int? subcatid,
    String? frequency,
    String? startdate,
    String? enddate,
    String? nextoccurance,
    String? status,
    String? note,
  ) async {
    final url = Uri.parse('${URL}recurringpayments');
    final body = jsonEncode(<String, dynamic>{
      "RecurringID": recurringid,
      'UserID': userid,
      'Amount': amount,
      'AccountID': acid,
      'CategoryID': catid,
      'SubCategoryID': subcatid,
      'Frequency': frequency,
      'StartDate': startdate,
      'EndDate': enddate,
      'NextOccurance': nextoccurance,
      'Status': status,
      'Note': note
    });
    final response = await http.patch(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return getrecurringpayments(userid);
      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to update recurringpayments.');
    }
  }

  static Future deleterecurringpayments(
    int? recurringid,
    String? userid,
  ) async {
    final url = Uri.parse('${URL}recurringpayments');
    final body = jsonEncode(<String, dynamic>{
      "RecurringID": recurringid,
      'UserID': userid,
    });
    final response = await http.delete(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);

      return getrecurringpayments(userid);

      // return Bank.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to delete recurringpayments .');
    }
  }

  static Future<Recurringbase> getrecurringpayments(String? UserId) async {
    final url = Uri.parse('${URL}recurringpayments');
    final body = {'UserID': UserId};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return Recurringbase.fromMap(jsonData);
      }
      return Future.error("Error in recurringpayments post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on  recurringpayments method");
    }
  }

  static Future uploadbankstatement(
      String? FileName, String? userid, String? PdfDecode) async {
    final url = Uri.parse('${URL}bankstatementupload');
    final body = jsonEncode(<String, dynamic>{
      'FileName': FileName,
      'UserID': userid,
      'PdfDecode': PdfDecode
    });
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return true;
    } else {
      print(response.body);
      throw Exception('Failed to upload images in S3.');
    }
  }

  static Future<BankStatementbase> getbankstatement(
      String? UserId, String? filepath) async {
    final url = Uri.parse('${URL}bankstatement');
    final body = {'UserID': UserId, 'filepath': filepath};
    try {
      var response = await http.post(url, body: json.encode(body));
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return BankStatementbase.fromMap(jsonData);
      }
      return Future.error("Error in bankstatement post method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on bankstatement view method");
    }
  }

  static update() async {
    final url = Uri.parse('${URL}settings');

    try {
      var response = await http.get(url);
      // var instance = await CommonLocalStorage.getInstance();
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Map<String, dynamic> bankdata = jsonData['bankdetails'][0];

        return jsonData;
      }
      return Future.error("Error in settings  method");
    } on Exception catch (e) {
      print("User" + e.toString());

      throw Exception("Error on settings view method");
    }
  }
}
