import 'package:capstone1/authPage/userPage.dart';
import 'package:capstone1/firstPages/firstTutorial.dart';
import 'package:capstone1/homePage/profit/profitDetail.dart';
import 'package:capstone1/searchPage/stockDetail/stockRoot.dart';
import 'package:capstone1/tutorial/stockRootTutorial.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';

CustomTransitionPage buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}){
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: animation.drive(Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero
            ).chain(CurveTween(curve: Curves.easeInOut)),),
          child: child,
        )
  );
}

final router = GoRouter(
    routes: [
  GoRoute(path: '/', builder: (context, state) => const MyApp(), routes: [
    GoRoute(
        path: 'mainTab/:tab',
        builder: (c, s) => TabContainer(
              tab: s.params['tab'],
            ),
        routes: [
          GoRoute(
              path: 'stockDetail/:ticker',
              builder: (context, state) => Stock( tab: state.params['tab'], ticker: state.params['ticker']),
              pageBuilder: (context, state) => buildPageWithSlideTransition(
                context: context, state: state,
                child: Stock( tab: state.params['tab'], ticker: state.params['ticker']))
          ),
        ])
  ]),
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
      pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: StockTutorial(
              prev: state.params['prev'],
            ),
          )),
  GoRoute(
      path: '/profitDetail',
      pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context, state: state,
          child: const ProfitDetail())
  ),
]);
