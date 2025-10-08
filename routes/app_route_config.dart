// import 'package:billfold/budget/budgetview.dart';
// import 'package:billfold/budget/get_budget.dart';
// import 'package:billfold/goal/goal_detail.dart';
// import 'package:billfold/goal/goal_view.dart';
// import 'package:billfold/landingpage.dart';
// import 'package:billfold/main.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class MyAppRouter {
//   GoRouter router = GoRouter(initialLocation: '/', routes: [
//     GoRoute(
//       path: '/',
//       name: 'Splashpage',
//       pageBuilder: (context, state) {
//         return MaterialPage(
//             child: SplashPage(
//           onLanguageChanged: (Locale locale) {},
//         ));
//       },
//     ),
//     // GoRoute(
//     //   path: '/home',
//     //   name: 'Home',
//     //   builder: (BuildContext context, state) {
//     //     return   const LandingPage(onLanguageChanged: ,);
//     //   },
//     // ),
//     GoRoute(
//       path: '/createbudget',
//       name: 'createbudget',
//       pageBuilder: (context, state) {
//         return MaterialPage(child: MonthlyBudget());
//       },
//     ),
//     GoRoute(
//       path: '/viewbudget',
//       name: 'viewbudget',
//       pageBuilder: (context, state) {
//         return MaterialPage(child: Budgetview());
//       },
//     ),
//     GoRoute(
//       path: '/creategoal',
//       name: 'creategoal',
//       pageBuilder: (context, state) {
//         return MaterialPage(child: GoalDetails());
//       },
//     ),
//     GoRoute(
//       path: '/viewgoal',
//       name: 'viewgoal',
//       pageBuilder: (context, state) {
//         return MaterialPage(child: GoalsView());
//       },
//     ),
//   ]);
// }
