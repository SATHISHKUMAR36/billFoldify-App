import 'package:billfold/provider/connectivity_provider.dart';
import 'package:billfold/provider/user_provider.dart';
import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension BuidContextExtension on BuildContext {
  // SettingsProvider get settings {
  //   return SettingsProvider();
  // }

  ConnectivityProvider get watchconnectivity {
    return this.watch<ConnectivityProvider>();
  }

  ConnectivityProvider get readconnectivity {
    return this.read<ConnectivityProvider>();
  }

  ThemeProvider get watchtheme {
    return watch<ThemeProvider>();
  }

  UserProvider get readuser {
    return read<UserProvider>();
  }

  UserProvider get watchuser {
    return watch<UserProvider>();
  }
   
}
