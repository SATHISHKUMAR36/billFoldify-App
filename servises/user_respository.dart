import 'dart:convert';
import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

import 'package:billfold/servises/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'storage.dart';

final String _GOOGLE_PROVIDER_URL =
// "https://authbillfoldify-dev.auth.ap-southeast-1.amazoncognito.com/login?redirect_uri=billfoldify%3A%2F%2Flogin%2F&response_type=code&client_id=7ceccigdmr48r1hnjnjn4efsvm";
    "https://$COGNITO_POOL_URL/oauth2/authorize?identity_provider=Google&redirect_uri=billfoldify://login/&response_type=CODE&client_id=$COGNITO_APP_CLIENTID&scope=email%20openid%20profile%20aws.cognito.signin.user.admin";
// https://$COGNITO_POOL_URL/login?redirect_uri=billfoldify%3A%2F%2Flogin%2F&response_type=code&client_id=7ceccigdmr48r1hnjnjn4efsvm
final String _FACEBOOK_PROVIDER_URL =
    "https://$COGNITO_POOL_URL/oauth2/authorize?identity_provider=Facebook&redirect_uri=billfoldify://login/&response_type=CODE&client_id=$COGNITO_APP_CLIENTID&scope=email%20openid%20profile%20aws.cognito.signin.user.admin";

final String _APPLE_PROVIDER_URL =
    "https://$COGNITO_POOL_URL/oauth2/authorize?identity_provider=SignInWithApple&redirect_uri=billfoldify://login/&response_type=CODE&client_id=$COGNITO_APP_CLIENTID&scope=email%20openid%20profile%20aws.cognito.signin.user.admin";

// final String _AMAZON_PROVIDER_URL =
//     "https://$COGNITO_POOL_URL/oauth2/authorize?identity_provider=LoginWithAmazon&redirect_uri=xcaldata://&response_type=CODE&client_id=$COGNITO_APP_CLIENTID&scope=profile";

enum IdentityProvider {
  GOOGLE,
  APPLE,
  FACEBOOK,
  // AMAZON,
}

extension IdentityProviderExtension on IdentityProvider {

  bool get enabled {
    switch (this) {
      case IdentityProvider.GOOGLE:
      case IdentityProvider.APPLE:
        return true;
      default:
        return false;
    }
  }

  String? get provider {
    switch (this) {
      case IdentityProvider.GOOGLE:
        return "Google";
      case IdentityProvider.FACEBOOK:
        return "Facebook";
      case IdentityProvider.APPLE:
        return "SignInWithApple";
      // case IdentityProvider.AMAZON:
      //   return "LoginWithAmazon";
      default:
        return null;
    }
  }

  String? get _imageassetPath {
    switch (this) {
      case IdentityProvider.GOOGLE:
        return "assets/images/google.png";
      case IdentityProvider.FACEBOOK:
        return "assets/images/f_logo_RGB-Blue_58.png";
      case IdentityProvider.APPLE:
        return "assets/images/apple.png";
      // case IdentityProvider.AMAZON:
      //   return "";
      default:
        return null;
    }
  }

  Widget? get imageAsset {
    switch (this) {
      case IdentityProvider.GOOGLE:
        return Image.asset(
          this._imageassetPath!,
           height: 60.0,
        );
      case IdentityProvider.APPLE:
      case IdentityProvider.FACEBOOK:
        return Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              this._imageassetPath!,
              height: 30.0,
            ));

      default:
        return null;
    }
  }

  String? get url {
    switch (this) {
      case IdentityProvider.GOOGLE:
        return _GOOGLE_PROVIDER_URL;
      case IdentityProvider.FACEBOOK:
        return _FACEBOOK_PROVIDER_URL;
      case IdentityProvider.APPLE:
        return _APPLE_PROVIDER_URL;
      // case IdentityProvider.AMAZON:
      //   return _AMAZON_PROVIDER_URL;
      default:
        return null;
    }
  }

  String? get revokeurl {
    switch (this) {
      case IdentityProvider.GOOGLE:
        return _GOOGLE_PROVIDER_URL;
      case IdentityProvider.FACEBOOK:
        return _FACEBOOK_PROVIDER_URL;
      case IdentityProvider.APPLE:
        return _APPLE_PROVIDER_URL;
      // case IdentityProvider.AMAZON:
      //   return _AMAZON_PROVIDER_URL;
      default:
        return null;
    }
  }
}

List<IdentityProvider> AvailableProvider =
    IdentityProvider.values.where((e) => e.enabled).toList();

class AuthException implements Exception {
  final String? message;

  AuthException([this.message]);
}

class CognitoUserConfirmationNeeded extends AuthException {
  CognitoUserConfirmationNeeded() : super("User is not confirmed");
}
class CognitoUserNewPasswordRequired extends AuthException {
  CognitoUserNewPasswordRequired() : super("New Password required");
}


class UserRepository {
  static final String LOGOUT_OAUTH_PROVIDER_URL =
      "https://$COGNITO_POOL_URL/logout?client_id=$COGNITO_APP_CLIENTID&logout_uri=xcaldata://";

  static final UserRepository _respository = UserRepository._createInstance();
  late CognitoUserPool userPool;
  CognitoUser? cognitoUser;
  UserRepository._createInstance() {
    createuserpool();
  }
  void createuserpool() {
    userPool = CognitoUserPool(COGNITO_USERPOOL_ID, COGNITO_APP_CLIENTID,
        clientSecret: COGNITO_APP_CLIENTSECRET, storage: CognitoLocalStorage());
  }

  String? _deviceName;

  bool get hasuser => cognitoUser?.username != null;

  factory UserRepository() => _respository;

  Future<CognitoUserSession?>? get currentsession => cognitoUser?.getSession();

  Future<SigV4Request> createSignV4Request(
      {required String path,
      String method = "GET",
      Map<String, String>? headers,
      Map<String, String>? queryParams,
      dynamic body}) async {
    var session = await UserRepository().currentsession;

    final credentials = CognitoCredentials(COGNITOIDENTITY_ID, userPool);
    await credentials.getAwsCredentials(session!.getIdToken().getJwtToken());

    final awsSigV4Client = AwsSigV4Client(credentials.accessKeyId!,
        credentials.secretAccessKey!, APIGATEWAYBASEURL,
        sessionToken: credentials.sessionToken, region: COGNITOIDENTITY_REGION);

    final signedRequest = SigV4Request(awsSigV4Client,
        method: method,
        path: path,
        headers: headers,
        queryParams: queryParams,
        body: body);
    return signedRequest;
  }

//   Apicall() async {

//     SigV4.buildAuthorizationHeader(accessKey, credentialScope, headers, signature)
//    SigV4Request signedRequest = SigV4Request(
//   AwsSigV4Client,
//   method: Method.post,
//   authorizationHeader: session.idToken.jwtToken, // <---- custom authorizationHeader
//   path: '/path',
//   headers: Map<String, String>.from({
//     CONTENT_TYPE: APPLICATION_GRAPHQL,
//     ACCEPT: APPLICATION_JSON,
//   }),
//   body: Map<String, String>.from(
//     {
//       QUERY: query,
//     },
//   ),
// );
//   }

  Future<Map<String, dynamic>?> get usertoken async {
    // AuthUser user = await Amplify.Auth.getCurrentUser();
    // print(user);
    // cognitoUser = await userPool.getCurrentUser();
    try {
      var session = await currentsession;

      if (session != null) if (session.isValid()) {
        log("User signed in ");
        String? idToken = session.getIdToken().getJwtToken();
        String? username=session.accessToken.payload['username'];
        String? oauthname=session.idToken.payload['given_name'];
        String? email=session.idToken.payload['email'];
        String? sub = session.idToken.getSub();
        if(oauthname==null && username!.contains('signinwithapple')){
          oauthname=username.split('.')[0];
        }
        if (idToken != null && sub != null) {
          // log("idToken $idToken");
          // log("Sub $sub");
          return {"idToken": idToken, "sub": sub,"username":username,"oauthname":oauthname,"email":email};
        }
      } else {
        session = null;
        throw CognitoClientException("Your session has expired");
      }
    } on CognitoClientException catch (_) {
      rethrow;
    } on Exception catch (e) {
      if (e.toString().startsWith("Local storage is missing")) {
        throw AuthException("Your session has expired");
      }
    }
    return null;
  }

  set devicename(String name) {
    this._deviceName = name;
  }

  void createCognito(username, {bool forcecreate = false}) {
    if (forcecreate) {
      cognitoUser = CognitoUser(username, userPool,
          deviceName: _deviceName, clientSecret: COGNITO_APP_CLIENTSECRET);
    } else {
      cognitoUser ??= CognitoUser(username, userPool,
          deviceName: _deviceName, clientSecret: COGNITO_APP_CLIENTSECRET);
    }
  }

  Future signUserInWithAuthCode(String authCode) async {

    String url = "https://$COGNITO_POOL_URL" +
        "/oauth2/token?grant_type=authorization_code&client_id=$COGNITO_APP_CLIENTID" +
        "&code=${Uri.encodeComponent(authCode)}" +
        "&client_secret=$COGNITO_APP_CLIENTSECRET" +
        "&redirect_uri=billfoldify://login/";

    final response = await http.post(Uri.parse(url),
        body: {},
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    if (response.statusCode != 200) {
      throw Exception("Received bad status code from Cognito for auth code:" +
          response.statusCode.toString() +
          "; body: " +
          response.body);
    }

    final tokenData = jsonDecode(response.body);

    final idToken = CognitoIdToken(tokenData['id_token']);
    final accessToken = CognitoAccessToken(tokenData['access_token']);
    final refreshToken = CognitoRefreshToken(tokenData['refresh_token']);
    final session =
        CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);
    final user = CognitoUser(null, userPool, signInUserSession: session);

    // NOTE: in order to get the email from the list of user attributes, make sure you select email in the list of
    // attributes in Cognito and map it to the email field in the identity provider.
    final attributes = await user.getUserAttributes() ?? [];
    for (CognitoUserAttribute attribute in attributes) {
      if (attribute.getName() == "sub") {
        user.username = attribute.getValue();
        break;
      }
    }
    cognitoUser = user;

    await Future.wait([
      CognitoLocalStorage()
          .setItem(PreferenceKey.loginvia.name, "SOCIALPROVIDER"),
      cognitoUser!.cacheTokens()
    ]);
    return user;
  }

  Future<bool> removeUser() async {
    bool isdeleted = await cognitoUser!.deleteUser();
    if (isdeleted) {
      cognitoUser = null;
    }
    return isdeleted;
  }

  Future<void> signup(String username, String password,
      {Map<String, String>? userAttributes,
      Map<String, String>? clientMetadata}) async {
    final extrasUserAttributes = userAttributes?.entries
        .map((attrib) => AttributeArg(name: attrib.key, value: attrib.value))
        .toList();

    try {
      CognitoUserPoolData? data = await userPool.signUp(
        username,
        password,
        userAttributes: extrasUserAttributes,
        // clientMetadata: clientMetadata,
      );
      cognitoUser = data.user;
      if (!(data.userConfirmed ?? false)) throw CognitoUserConfirmationNeeded();

      print(data);
    } on CognitoUserConfirmationNeeded catch (_) {
      rethrow;
    } on CognitoClientException catch (e) {
      throw AuthException(e.message);
    } on Exception catch (e) {
      print(e);
      throw AuthException(e.toString());
    }
  }

  Future<bool> checkforuser() async {
    cognitoUser = await userPool.getCurrentUser();
    if (cognitoUser != null) {
      return true;
    }
    return false;
  }

  Future<void> revoke() async {
    try {
      var session = await currentsession;
      if (session != null) if (session.isValid()) {
        String? token = session.getRefreshToken()?.getToken();
        String? sub = session.idToken.getSub();
        if (token != null) {
          String url = "https://$COGNITO_POOL_URL" +
              "/oauth2/revoke?&token=${Uri.encodeComponent(token)}";
          String encodedcode = base64.encode(
              utf8.encode("$COGNITO_APP_CLIENTID:$COGNITO_APP_CLIENTSECRET"));

          final response = await http.post(Uri.parse(url), body: {}, headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            "Authorization": "Basic $encodedcode"
          });
          if (response.statusCode != 200) {
            throw Exception(
                "Received bad status code from Cognito for auth code:" +
                    response.statusCode.toString() +
                    "; body: " +
                    response.body);
          }
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }




  logOut() async {
    var isviaoauth =
        await CognitoLocalStorage().getItem(PreferenceKey.loginvia.name);
    if (isviaoauth == "SOCIALPROVIDER") {
      await revoke();
      await CognitoLocalStorage().removeItem(PreferenceKey.loginvia.name);
    }
    await cognitoUser?.signOut();
    await Future.wait([
      CognitoLocalStorage().removeItem(PreferenceKey.selectedcountrycode.name),
      CognitoLocalStorage()
          .removeItem(PreferenceKey.subscribedcountrycode.name),
      CognitoLocalStorage().removeItem(PreferenceKey.userprofileinfo.name)
    ]);

    // _session = null;
    // cognitoUser.getSession();
  }

  clearuser() {
    cognitoUser = null;
  }

  Future<CognitoUserSession> signIn(String username, String password,
      {Map<String, String>? extrasAttributes, String? devicename}) async {
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    createuserpool();
    createCognito(username, forcecreate: true);
    CognitoUserSession? _session;
    try {
      _session = await cognitoUser!.authenticateUser(authDetails);
      cognitoUser!.cacheTokens();
      if (_session == null) {
        throw CognitoClientException("No session found");
      }
      print(_session.getAccessToken().getJwtToken());
      return _session;
      // cognitoUser!.cacheTokens();
    } on CognitoUserNewPasswordRequiredException catch (e) {
      throw CognitoUserNewPasswordRequired();

      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      throw AuthException(e.message);

      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      throw AuthException(e.message);

      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      throw AuthException(e.message);

      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      throw AuthException(e.message);

      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      throw AuthException(e.message);

      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      throw CognitoUserConfirmationNeeded();
      // handle User Confirmation Necessary
    } on CognitoClientException catch (e) {
      inspect(e);
      throw AuthException(e.message);

      // handle Wrong Username and Password and Cognito Client
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> confirmRegistration(
      {required String username, required String confirmationCode}) async {
    createCognito(username);
    bool registrationConfirmed = false;
    try {
      registrationConfirmed =
          await cognitoUser!.confirmRegistration(confirmationCode);
    } on CognitoClientException catch (e) {
      print(e);
      throw AuthException(e.message);
    } catch (e) {
      print(e);
      throw AuthException(e.toString());
    }
    return registrationConfirmed;
  }

  Future<void> resendConfirmationCode({required String username}) async {
    createCognito(username);

    final dynamic status;
    try {
      status = await cognitoUser!.resendConfirmationCode();
      print(status);
    } on CognitoClientException catch (e) {
      print(e);
      throw AuthException(e.message);
    } catch (e) {
      print(e);
      throw AuthException(e.toString());
    }
  }

  Future<void> forgotPassword({required String username}) async {
    createCognito(username, forcecreate: true);

    final dynamic status;
    try {
      status = await cognitoUser!.forgotPassword();
      print(status);
    } on CognitoClientException catch (e) {
      print(e);
      throw AuthException(e.message);
    } catch (e) {
      print(e);
      throw AuthException(e.toString());
    }
  }

  Future<void> confirmPassword(
      {required String username,
      required String confirmationCode,
      required String newPassword}) async {
    createCognito(username);

    final dynamic status;
    try {
      status =
          await cognitoUser!.confirmPassword(confirmationCode, newPassword);
      print(status);
    } on CognitoClientException catch (e) {
      print(e);
      throw AuthException(e.message);
    } catch (e) {
      print(e);
      throw AuthException(e.toString());
    }
  }

Future<void> createNewPassword({
    required String username,
    required String newPassword,
  }) async {
    // await createCognito(username);
    // await createCognito(username, forcecreate: true);
 
    final dynamic status;
    try {
      status = await cognitoUser!.sendNewPasswordRequiredAnswer(newPassword);
      print(status);
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoClientException catch (e) {
      print(e);
      throw AuthException(e.message);
    } catch (e) {
      print(e);
      throw AuthException(e.toString());
    }
  }
}


