import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:capstone1/providers/authentication.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('설정', style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2
            ),),
            Divider(thickness: 1.0, color: Colors.grey),
            /*-----------------------로그아웃------------------------------*/
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      context.read<AuthProvider>().logout();
                      GoRouter.of(context).go('/');
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black, textStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.2
                    )
                    ),
                    child: Text('로그아웃'),
                  ),
                  Divider(thickness: 0.6, color: Colors.grey.withOpacity(0.5), ),
                ],
              ),
            ),
            /*-----------------------내 정보 수정------------------------------*/
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      GoRouter.of(context).push('/modify');
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black, textStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.2
                    )
                    ),
                    child: Text('내 정보 수정'),
                  ),
                  Divider(thickness: 0.6, color: Colors.grey.withOpacity(0.5), ),
                ],
              ),
            ),
            /*-----------------------튜토리얼 다시 보기------------------------------*/
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      GoRouter.of(context).go('/welcome');
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black, textStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.2
                    )
                    ),
                    child: Text('첫 설명 다시보기'),
                  ),
                  Divider(thickness: 0.6, color: Colors.grey.withOpacity(0.5), ),
                ],
              ),
            ),
            /*-----------------------회원 탈퇴-----------------------------*/
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context){
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "정말로 탈퇴하시나요? \u{1F622}",
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                                Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.6),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        splashFactory: NoSplash.splashFactory,
                                        backgroundColor: Colors.transparent,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.all(10)
                                      ),
                                      child: Text('아니요!',
                                        style: TextStyle(
                                          foreground:  Paint()..shader = LinearGradient(
                                              colors: const [Colors.blue, Color(0xffB484FF)]
                                          ).createShader(Rect.fromLTWH(180.0, 0, 150.0, 20.0)),
                                          fontSize: 18
                                        )
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          GoRouter.of(context).replace('/');
                                          print(auth.currentUser!.uid);
                                          context.read<AuthProvider>().withdraw(auth.currentUser!.uid);
                                          context.read<AuthProvider>().logout();
                                        },
                                        style: TextButton.styleFrom(
                                          splashFactory: NoSplash.splashFactory,
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.only(top: 10, bottom: 7, right: 7, left: 7)
                                        ),
                                        child: Text('네',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black
                                          ),
                                        )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });

                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black, textStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.2
                    )
                    ),
                    child: Text('회원 탈퇴'),
                  ),
                  Divider(thickness: 0.6, color: Colors.grey.withOpacity(0.5), ),
                ],
              ),
            ),
          ],
        )
    );
  }
}