import 'dart:convert';
import 'package:billfold/amplifyconfiguration.dart';
import 'package:flutter/foundation.dart';

const PLAYSTORE_PACKAGE_NAME = "com.billfoldify.apps";
const APPSTORE_PACKAGE_NAME = "com.billfoldify.apps";
const APPSTORE_PACKAGE_ID = "6711352498";

// const LONG_REFER_LINK = "https://www.xcaldata.com/refer?code=";
// const SHORT_REFER_LINK = "https://devlink.xcaldata.com/referral";

const PLAYSTORELINK =
    "https://play.google.com/store/apps/details?id=$PLAYSTORE_PACKAGE_NAME";
const APPSTORELINK =
    "https://apps.apple.com/in/app/billfoldify/id$APPSTORE_PACKAGE_ID";

final String APIGATEWAYBASEURL = jsonDecode(amplifyconfig)["api"]["plugins"]
    ["awsAPIPlugin"]["xcaldataAPIService"]["endpoint"];

// Auth
final String COGNITO_POOL_URL = jsonDecode(amplifyconfig)["auth"]["plugins"]
    ["awsCognitoAuthPlugin"]["Auth"]["Default"]["OAuth"]["WebDomain"]!;

final String COGNITO_USERPOOL_ID = jsonDecode(amplifyconfig)["auth"]["plugins"]
    ["awsCognitoAuthPlugin"]["CognitoUserPool"]["Default"]["PoolId"]!;

final String COGNITO_APP_CLIENTID = jsonDecode(amplifyconfig)["auth"]["plugins"]
    ["awsCognitoAuthPlugin"]["CognitoUserPool"]["Default"]["AppClientId"]!;

final String? COGNITO_APP_CLIENTSECRET = jsonDecode(amplifyconfig)?["auth"]
        ?["plugins"]["awsCognitoAuthPlugin"]["CognitoUserPool"]["Default"]
    ["AppClientSecret"];

final String COGNITOIDENTITY_ID = jsonDecode(amplifyconfig)["auth"]["plugins"]
        ["awsCognitoAuthPlugin"]["CredentialsProvider"]["CognitoIdentity"]
    ["Default"]["PoolId"]!;
final String COGNITOIDENTITY_REGION = jsonDecode(amplifyconfig)["auth"]
        ["plugins"]["awsCognitoAuthPlugin"]["CredentialsProvider"]
    ["CognitoIdentity"]["Default"]["Region"]!;

// final String XCALDATA_JSON_API_PATH =
//     "https://d1wlgf9b9idzvt.cloudfront.net/api";

final String SETTINGSURL = "$APIGATEWAYBASEURL/user/settings";
final String VERSION_CHECK_URL = "$APIGATEWAYBASEURL/user/storeversion";

const GLOBAL_INDICES_PRICE_FETCH_FREQUENCY = 60; //SECONDS
const GLOBAL_INDICES_PRICE_RETRY_FETCH_FREQUENCY = 10; //SECONDS

const ANGEL_LTP_FETCH_FREQUENCY = 2; //SECONDS

const ZERODHA_DEPTH_FETCH_FREQUENCY = 2; //SECONDS

const ICICIDIRECT_LTP_FETCH_FREQUENCY = 2; //SECONDS

const KOTAK_LTP_FETCH_FREQUENCY = 2;
const IST_TIMEZONE = "Asia/Calcutta";
const UTC_TIMEZONE = "Etc/UTC";
// final UserProfileModel GUEST_USER_Model = UserProfileModel(
//     givenName: 'Guest',
//     familyName: 'user',
//     email: 'guestuser@gmail.com',
//     phoneNumber: '+919999999999',
//     subscriptionpolicy: 'Guest');
const Map<String, dynamic> GUEST_USER = {
  'profile': {
    'given_name': 'Guest',
    'family_name': 'user',
    'email': 'guestuser@gmail.com',
    'phone_number': '+919999999999',
    'subscriptionpolicy': 'Guest',
    'subscription': {
      'IND': {
        "subscribeddata": [
          {"name": "1", "data": []},
          {"name": "2", "data": []},
          {"name": "3", "data": []},
          {"name": "4", "data": []},
          {"name": "5", "data": []}
        ],
        "subscriptiontype": "Guest"
      }
    }
  }
};

enum PreferenceKey {
  loginvia,
  settingskey,
  refererkey,
  userprofileinfo,
  seclistinfo,
  consolidatedinfo,
  sechistaccuracy,
  economiccalenderinfo,
  screenerinfo,
  financialscreenerinfo,
  isnewnotify,
  subscribedcountrycode,
  selectedcountrycode,
  countrylist,
  optionslist,
  isreferraldialogshown,
  isnewuser,
  buysellperformance,
  stratiges,
  strategybuysellperformance,
  baskets,
}

extension PreferenceKeyExtension on PreferenceKey {
  String get name => describeEnum(this);
  get datekey {
    return this.name + "_date";
  }
}

// class PreferenceKey {
//   static final settingskey = "settingskey";
//   static final refererkey = "referercode";
//   static final userprofileinfo = "userprofileinfo";
//   static final seclistinfo = "seclistinfo";
//   static final seclistinfodate = "seclistinfo";
//   static final sechistaccuracy = "sechistaccuracy";
//   static final economiccalenderinfo = "economiccalenderinfo";
//   static final screenerinfo = "screenerinfo";
//   static final isnewnotify = "isnewnotify";
//   static final subscribedcountrycode = "subscribedcountrycode";
//   static final selectedcountrycode = "selectedcountrycode";
//   static final countrylist = "countrylist";
//   static final optionslist = "optionslist";
// }

enum xCalDataLoadType { API, CACHE, NONE }
