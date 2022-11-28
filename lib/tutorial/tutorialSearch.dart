import 'package:capstone1/constant/globalKeys.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorialSearch extends StatefulWidget {
  const TutorialSearch({Key? key}) : super(key: key);

  @override
  State<TutorialSearch> createState() => _TutorialSearchState();
}

class _TutorialSearchState extends State<TutorialSearch> {

  final shadowedBox = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 7,
        offset: const Offset(4,8),
      )
    ],
    borderRadius: BorderRadius.circular(8.0),
  );
  final titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: -2.0,
  );
  final TextStyle textStyle = const TextStyle(
      fontSize: 20,
      letterSpacing: -1.2
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        children: [
          Container(
            child: TextField(
              enabled: false,
              style: TextStyle(
                  color: Colors.black, fontSize: 17, height: 1.3),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass, size: 20, key: homeGlobals.magnifyKey,
                    color: Colors.black,),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none
                  ),
                  fillColor: Color(0xFFE2E2E2),
                  filled: true,
                  hintText: '종목 검색...',
                  hintStyle: TextStyle(
                    color: Colors.black, letterSpacing: -1.2,)
              ),
            ),
          ),
          Container(
            decoration: shadowedBox,
            margin: EdgeInsets.only(top: 20, bottom: 10),
            padding: EdgeInsets.only(top: 13, bottom: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(key: homeGlobals.termKey ,child: Text('오늘의 용어', style: titleStyle,),),
                    IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.refresh_rounded)
                    )
                  ],
                ),
                Divider(color: Colors.grey,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('[경제]',
                            style: TextStyle(
                                color: Colors.grey
                            ),),
                          Text('불규칙 보행 가설',
                            style: TextStyle(
                                fontSize: 20,
                                overflow: TextOverflow.fade
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.arrow_forward_ios)
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Row(
              children: [
                Text("일일 ", style: TextStyle(
                    fontSize: 25,
                    letterSpacing: -1.0,
                    fontWeight: FontWeight.bold
                )),
                Container(
                  key: homeGlobals.stockRankKey,
                  child: Text("거래량", style: TextStyle(
                      fontSize: 25,
                      letterSpacing: -1.0,
                      fontWeight: FontWeight.bold
                  )),
                ),
                Text(" top 10", style: TextStyle(
                    fontSize: 25,
                    letterSpacing: -1.0,
                    fontWeight: FontWeight.bold
                )),
              ],
            ),
          ),
          Divider(color: Colors.grey,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (c, i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black
                        ),
                        onPressed: (){},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${i+1}. ', style: textStyle,),
                            Text('종목${i+1}', style: textStyle,)
                          ],
                        ),
                      ),
                      Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),)
                    ],
                  ),
                );
              },
            ),
          )
        ]
    );
  }
}
