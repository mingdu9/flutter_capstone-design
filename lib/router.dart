import 'package:capstone1/authPage/userPage.dart';
import 'package:capstone1/firstPages/firstTutorial.dart';
import 'package:capstone1/homePage/profit/profitDetail.dart';
import 'package:capstone1/searchPage/stockDetail/stockRoot.dart';
import 'package:capstone1/tutorial/stockRootTutorial.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: Stock(tab: state.params['tab'],ticker: state.params['ticker']),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                          position: animation.drive(Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,).chain(CurveTween(curve: Curves.easeInOut))
                          ),
                          child: child,
                        )
                )
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
  GoRoute(
    path: '/stockTutorial/:prev',
    pageBuilder: (context, state) =>  NoTransitionPage<void>(
        key: state.pageKey,
        child: StockTutorial(prev: state.params['prev'],),
    )
  ),
  GoRoute(
    path: '/profitDetail',
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const ProfitDetail(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
            position: animation.drive(Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,).chain(CurveTween(curve: Curves.easeInOutExpo))
            ),
            child: child,
          )
    )
  )
]);