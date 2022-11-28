import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialEnd extends StatefulWidget {
  const TutorialEnd({Key? key}) : super(key: key);

  @override
  State<TutorialEnd> createState() => _TutorialEndState();
}

class _TutorialEndState extends State<TutorialEnd> {
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
        padding: const EdgeInsets.only(left: 100, top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('이제 제대로 시작해 볼까요?', style: tutorialTitle,),
            ),
            Text('혹시라도 헷갈리면\n[설정]에서 다시보기를 눌러주세요.', textAlign: TextAlign.end, style: tutorialText,),
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
                  GoRouter.of(context).go('/');
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
