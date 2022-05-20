import 'package:capstone1/authPage/userPage.dart';
import 'package:capstone1/firstPages/firstTutorial.dart';
import 'package:capstone1/searchPage/stockDetail/stockRoot.dart';
import 'package:go_router/go_router.dart';

import 'firstPages/firstPage.dart';
import 'main.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const MyApp(),
    routes: [
      GoRoute(
          path: 'mainTab/:tab',
          builder: (c, s) => TabContainer(tab: s.params['tab'],),
          routes: [
            GoRoute(
                path: 'stockDetail/:ticker',
                builder: (context, state) => Stock(tab: state.params['tab'],ticker: state.params['ticker'])
            )
          ]
      )
    ]
  ),
  GoRoute(
    path: '/login',
    builder: (c, s) => const Login(),
  ),
  GoRoute(
    path: '/signUp',
    builder: (context, state) => const SignUp(),
  ),
  GoRoute(
    path: '/welcome',
    builder: (context, state) => const WelcomePage(),
  ),

]);