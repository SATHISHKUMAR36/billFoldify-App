import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:billfold/choose_language.dart';
import 'package:billfold/landingpage.dart';
import 'package:billfold/provider/connectivity_provider.dart';
import 'package:billfold/servises/storage.dart';
import 'package:billfold/servises/user_model.dart';
import 'package:billfold/servises/user_respository.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/signinpage.dart';
import 'package:billfold/updateapp.dart';
import 'package:billfold/widget/nointernetpage.dart';
import 'package:flutter/foundation.dart';
//import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'provider/user_provider.dart';
import 'theme_provider.dart';

class AppLocalizations {
  Map<String, String> _localizedStrings = {};

  Future<void> load(Locale locale) async {
    String jsonContent = await rootBundle
        .loadString('assets/locales/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonContent);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static AppLocalizations of(BuildContext context) {
    // assert(debugCheckHasMaterialLocalizations(context));
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(
    String key,
  ) {
    return _localizedStrings[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();
  static final Map<Locale, Future<AppLocalizations>> _loadedTranslations =
      <Locale, Future<AppLocalizations>>{};

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ta', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    assert(isSupported(locale));

    return _loadedTranslations.putIfAbsent(locale, () async {
      final localizations = AppLocalizations();

      await localizations.load(locale);
      // print("hi2");
      // print("hekll" + localizations.translate("title"));
      return localizations;
    });
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService().initNotification();

  // tz.initializeTimeZones();
  final UserProvider _userProvider = UserProvider();
  final ThemeProvider _themeProvider = ThemeProvider();
  final ConnectivityProvider _connectivityProvider = ConnectivityProvider();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeProvider>.value(value: _themeProvider),
    ChangeNotifierProvider<UserProvider>.value(
      value: _userProvider,
    ),
    ChangeNotifierProvider<ConnectivityProvider>.value(
      value: _connectivityProvider,
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  UserAPIDetails? userdata;

  // Default locale is English
  late Future<void> _localeFuture;
  @override
  void initState() {
    _localeFuture = localechange();
    // _userProvider = UserProvider();
    // _themeProvider = ThemeProvider();
    // Future.delayed(Duration(seconds: 1), () {

    // });
    super.initState();
  }

  Future<void> localechange() async {
    await UserRepository().checkforuser();
    await context.read<UserProvider>().loading();

    userdata = context.read<UserProvider>().userdata;

    if (userdata != null) {
      if (userdata!.language! == 'Tamil') {
        _locale = Locale('ta', '');
      } else if (userdata!.language! == 'Hindi') {
        _locale = Locale('hi', '');
      } else {
        _locale = Locale('en', '');
      }

      if (userdata?.notificaton == 1) {
        //     final cron = Cron();
        // cron.schedule(
        //   Schedule.parse('0 21 * * *'),
        //   () => NotificationService().showNotification(
        //       title: "REMINDER.!",
        //       body: "Please enter your today transactions..!"));
      }
    } else {
      _locale = Locale('en', '');
    }
  }

  void _changeLanguage(Locale locale) {
    _locale = locale;
    print(_locale);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _localeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                  body: Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: Colors.blue,
                  size: 40,
                ),
              )),
            );
          } else {
            return GlobalLoaderOverlay(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                // routeInformationParser:
                //     MyAppRouter().router.routeInformationParser,
                // routeInformationProvider:
                //     MyAppRouter().router.routeInformationProvider,
                // routerDelegate: MyAppRouter().router.routerDelegate,
                theme: Provider.of<ThemeProvider>(context).currentTheme,

                localizationsDelegates: const [
                  AppLocalizationsDelegate.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''),
                  Locale('ta', ''),
                  Locale('hi', ''),
                ],
                locale: _locale,
                home: SplashPage(
                  onLanguageChanged: _changeLanguage,
                ),
                // home: MyHomePage(onLanguageChanged: _changeLanguage),
              ),
            );
          }
        });
  }
}

class SplashPage extends StatefulWidget {
  final void Function(Locale) onLanguageChanged;
  const SplashPage({super.key, required this.onLanguageChanged});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late LocalAuthentication auth;

  bool? checkuser;
  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: "Subscribe or you will never get this app",
          options:
              AuthenticationOptions(stickyAuth: true, biometricOnly: true));
      print("Authenticated : $authenticated");

      if (authenticated) {
        context.read<UserProvider>().loadalldata();
        if (_userProvider.userdata?.name != null &&
            _userProvider.userdata?.logout == 0) {
          // context.go('/home');
          // context.pushNamed('/home');
          // context.go('/home');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(
                      onLanguageChanged: widget.onLanguageChanged)));

          // else {
          //   UserDetails signinuser = UserDetails(
          //     name:signInUser.name,
          //               currency:signInUser.currency,
          //               language: signInUser.language,
          //               notificaton: signInUser.notificaton,
          //               logout: false
          //             );
          //              Map<String, dynamic> userJson = signinuser.toJson();
          //                   final prefs = await SharedPreferences.getInstance();
          //                   prefs.setString('signinuser', jsonEncode(userJson));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                language: _userProvider.userdata?.language ?? 'English',
                onLanguageChanged: widget.onLanguageChanged,
              ),
            ));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
  }

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  checkForVersionUpdate() async {
    try {
      if (kReleaseMode) {
        var data = await PackageInfo.fromPlatform();

        String? _storeInfo;
        if (Platform.isAndroid) {
          _storeInfo = _userProvider.versionnum;
        } else if (Platform.isIOS) {
          _storeInfo = _userProvider.versionnum;
        }
        packageInfo = data;

        if (_storeInfo != null && packageInfo.version.isNotEmpty) {
          var storeversion = _storeInfo.split("+")[0].split(".");
          var storebuild = _storeInfo.split("+")[1];
          var deviceversion = packageInfo.version.split(".");
          var devicebuild = packageInfo.buildNumber;

          if ((num.parse(deviceversion[0]) < num.parse(storeversion[0])) ||
              (num.parse(deviceversion[1]) < num.parse(storeversion[1])) ||
              (num.parse(deviceversion[2]) < num.parse(storeversion[2])) ||
              (num.parse(devicebuild) < num.parse(storebuild))) {
            CommonLocalStorage prefs = await CommonLocalStorage.getInstance();
            await prefs.clear();
            // clear cache
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Updateapp(
                    onLanguageChanged: widget.onLanguageChanged,
                  ),
                ));
            return true;
          }
        }
      }
      return false;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  api(BuildContext context) async {
    if (checkuser!) {
      auth = LocalAuthentication();
      auth.isDeviceSupported().then((bool isSupported) {
        if (isSupported && _userProvider.userdata != null) {
          if (_userProvider.userdata?.logout == 0 &&
              _userProvider.userdata?.name != null &&
              _userProvider.userdata?.facelogin == 1) {
            _authenticate();
          } else {
            if (_userProvider.userdata?.name != null &&
                _userProvider.userdata?.logout == 0) {
              context.read<UserProvider>().loadalldata();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LandingPage(
                      onLanguageChanged: widget.onLanguageChanged,
                    ),
                  ));
            } else if (_userProvider.userdata?.logout != 0) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(
                            language:
                                _userProvider.userdata?.language ?? 'English',
                            onLanguageChanged: widget.onLanguageChanged,
                          )));
            }
          }
        } else if (_userProvider.userdata != null) {
          if (_userProvider.userdata?.name != null &&
              _userProvider.userdata?.logout == 0) {
            context.read<UserProvider>().loadalldata();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LandingPage(
                    onLanguageChanged: widget.onLanguageChanged,
                  ),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                          language:
                              _userProvider.userdata?.language ?? 'English',
                          onLanguageChanged: widget.onLanguageChanged,
                        )));
          }
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseLanguage(
                  onLanguageChanged: widget.onLanguageChanged,
                ),
              ));
        }
      });
    } else {
      if (_userProvider.userdata != null) {
        if (_userProvider.userdata?.name != null &&
            _userProvider.userdata?.logout == 0) {
          context.read<UserProvider>().loadalldata();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPage(
                  onLanguageChanged: widget.onLanguageChanged,
                ),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(
                  onLanguageChanged: widget.onLanguageChanged,
                  language: _userProvider.userdata?.language ?? 'English',
                ),
              ));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseLanguage(
                onLanguageChanged: widget.onLanguageChanged,
              ),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    print("builder" + isOnline.toString());
    _userProvider = context.watchuser;
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    if (isOnline) {
      Future.delayed(Duration(seconds: 1), () async {
        final prefs = await CommonLocalStorage.getInstance();
        try {
          checkuser = await UserRepository().checkforuser();
          bool upd = await checkForVersionUpdate();
          if (!upd) {
            await api(context);
          }
        } on Exception catch (e) {
          ScaffoldMessengerState scaffoldMessenger =
              ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              elevation: 5,
              content: Text('Something went wrong , Try Agian'),
            ),
          );
          print(e);
          try {
            await prefs.clear();
            UserRepository().logOut();
          } catch (_) {}
          UserRepository().clearuser();
          // return HomeScreen();
        }
      });
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.canvasColor,
        body: isOnline
            ? Center(
                child: SizedBox(
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
              )
            : NoInternetPage(onLanguageChanged: widget.onLanguageChanged),
      ),
    );
  }
}
