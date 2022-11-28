import 'package:flutter/material.dart';

class TutorialSetting extends StatefulWidget {
  const TutorialSetting({Key? key}) : super(key: key);

  @override
  State<TutorialSetting> createState() => _TutorialSettingState();
}

class _TutorialSettingState extends State<TutorialSetting> {
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
