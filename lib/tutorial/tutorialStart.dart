import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialStart extends StatefulWidget {
  const TutorialStart({Key? key}) : super(key: key);

  @override
  State<TutorialStart> createState() => _TutorialStartState();
}

class _TutorialStartState extends State<TutorialStart> {
  final TextStyle tutorialTitle = TextStyle(
      color: Colors.black,
      fontSize: 24, letterSpacing: -1.5,
      fontWeight: FontWeight.bold
  );

  final TextStyle tutorialText = TextStyle(
    color: Colors.black,
    fontSize: 20, letterSpacing: -1.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 120, top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('가이드를 시작할게요.', style: tutorialTitle,),
            ),
            Text('스킵하고 싶다면 \n우측 상단의 \'SKIP\'을 눌러주세요.', textAlign: TextAlign.end, style: tutorialText,),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      stops: const [0.0, 1.0],
                      colors: const <Color>[
                        Colors.blue, Color(0xffB484FF)
                      ]
                  )
              ),
              child: ElevatedButton(
                onPressed: (){
                  GoRouter.of(context).go('/tutorial/start');
                },
                style: ElevatedButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  shape: CircleBorder(),
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
