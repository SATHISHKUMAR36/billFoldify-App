// import 'package:billfold/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:provider/provider.dart';

// import 'dashboardpage.dart';
// import 'face_finger_lock.dart';
// import 'main.dart';

// class BiometricAuth extends StatefulWidget {
//   const BiometricAuth({super.key});

//   @override
//   State<BiometricAuth> createState() => _BiometricAuthState();
// }

// class _BiometricAuthState extends State<BiometricAuth> {
//   late final LocalAuthentication auth;
//   bool _supportState = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     auth = LocalAuthentication();
//     auth.isDeviceSupported().then((bool isSupported) => setState(
//           () {
//             _supportState = isSupported;
//           },
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
//     return Scaffold(
//       body: SafeArea(
//           child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             if (_supportState)
//               Text("This Devise is Supported")
//             else
//               Text("This Devise is Not Supported"),
//             InkWell(
//                 onTap: _getAvailableBiometrics,
//                 child: Text("Get Availabele Biometrics")),
//             Container(
//               height: 40,
//               width: 120,
//               decoration: BoxDecoration(
//                 color: currentTheme.primaryColor,
//               ),
//               child: InkWell(
//                 onTap: () {
//                   _authenticate();
//                 },
//                 child: Center(
//                     child: Text(
//                   AppLocalizations.of(context).translate("authenticate"),
//                   style: TextStyle(color: currentTheme.canvasColor),
//                 )),
//               ),
//             )
//           ],
//         ),
//       )),
//     );
//   }

//   Future<void> _authenticate() async {
//     try {
//       bool authenticated = await auth.authenticate(
//           localizedReason: "Subscribe or you will never get this app",
//           options:
//               AuthenticationOptions(stickyAuth: true, biometricOnly: true));
//       print("Authenticated : $authenticated");

//       if (authenticated) {
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => DashboardPage()));
//       }
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _getAvailableBiometrics() async {
//     List<BiometricType> availablebiometric =
//         await auth.getAvailableBiometrics();
//     print("Availabe Biomtrics $availablebiometric");
//     if (!mounted) {
//       return;
//     }
//   }
// }
