import 'dart:io';

import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/servises/constants.dart';
import 'package:billfold/settings/contextextension.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Updateapp extends StatefulWidget {
  final void Function(Locale)  onLanguageChanged;

  const Updateapp({super.key, required this.onLanguageChanged,});

  @override
  State<Updateapp> createState() => _UpdateappState();
}

class _UpdateappState extends State<Updateapp> {
  late UserProvider _userProvider;
  @override
  Widget build(BuildContext context) {
    _userProvider = context.watchuser;
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
        backgroundColor: currentTheme.canvasColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                SizedBox(
                  height: 300,
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "App Update available",
                    style: currentTheme.textTheme.displayLarge!
                        // .copyWith(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("To use this app, download the latest version.",
                      style: currentTheme.textTheme.displayLarge!
                          // .copyWith(color: Colors.white),
                )),
                   SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.lightBlue, // This is what you need!
                      ),
                      onPressed: () {
                        if (Platform.isAndroid)
                          launchUrlString(
                            PLAYSTORELINK,
                            mode: LaunchMode.externalApplication,
                          );
                        if (Platform.isIOS)
                          launchUrlString(
                            APPSTORELINK,
                            mode: LaunchMode.externalApplication,
                          );
                      },
                      child: Text("UPDATE NOW")),
                )
              ],
            ),
          ),
        ));
  }
}
