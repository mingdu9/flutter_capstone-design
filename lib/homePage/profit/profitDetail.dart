import 'package:capstone1/constant/constants.dart';
import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/user.dart';
import 'package:capstone1/tutorial/tutorialHome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';



class ProfitDetail extends StatefulWidget {
  const ProfitDetail({Key? key, }) : super(key: key);

  @override
  State<ProfitDetail> createState() => _ProfitDetailState();
}

class _ProfitDetailState extends State<ProfitDetail> {
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
    letterSpacing: -1.5,
  );

  late TutorialCoachMark tutorialCoachMark;
  GlobalKey realizedProfitKey = GlobalKey();
  GlobalKey valuationProfitKey = GlobalKey();
  GlobalKey holdingsProfitKey = GlobalKey();

  void showTutorial(){
    tutorialCoachMark.show(context: context);
  }
  void createTutorial(){
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black54,
      textSkip: "CLOSE",
      textStyleSkip: TextStyle(fontSize: 19, color: Colors.white),
    );
  }

  @override
  initState(){
    createTutorial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: (){GoRouter.of(context).pop();},
        ),
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text("μμ΅ λΆμ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.values[4]),),
        actions: [
          IconButton(
              onPressed: (){
                showTutorial();
                },
              icon: Icon(Icons.question_mark, color: Colors.black,))
        ],
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 20, bottom: 20),
        primary: false,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                    key: realizedProfitKey,
                    decoration: shadowedBox,
                    margin: EdgeInsets.only(left: 20, right: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('μ΄ μ€νμμ΅', style: titleStyle,),
                          Divider(height: 23, thickness: 1,),
                          Text('${addComma(context.watch<UserProvider>().totalRealizedProfit)}μ',
                            style: TextStyle(
                              fontSize: 20, color: (context.watch<UserProvider>().totalRealizedProfit >= 0 ?
                                (context.watch<UserProvider>().totalRealizedProfit == 0 ? Colors.grey : Colors.redAccent)
                                  : Colors.blueAccent),
                            ),
                          )
                        ],
                      ),
                    )
                )
              ),
              Expanded(
                  child: Container(
                      key: valuationProfitKey,
                      decoration: shadowedBox,
                      margin: EdgeInsets.only(left: 10, right: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('μ΄ νκ°μμ΅', style: titleStyle,),
                            Divider(height: 23, thickness: 1,),
                            Text('${addComma(context.watch<UserProvider>().valuationProfit.ceil())}μ', style: TextStyle(
                              fontSize: 20,
                              color: (context.watch<UserProvider>().valuationProfit >= 0 ? (
                                  context.watch<UserProvider>().valuationProfit == 0 ? Colors.grey : Colors.redAccent): Colors.blueAccent),
                            ),),
                          ],
                        ),
                      )
                  )
              ),
            ],
          ),
          Container(
            decoration: shadowedBox,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(key: holdingsProfitKey, child: Text("μ’λͺ©λ³ μμ΅", style: titleStyle)),
                Divider(thickness: 1, height: 23,),
                context.watch<UserProvider>().tickers.isNotEmpty ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemCount: context.watch<UserProvider>().tickers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${context.read<UserProvider>().summaries.elementAt(index)['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -1.2,
                                            fontSize: 17),
                                      ),
                                      Text('${context.watch<UserProvider>().summaries.elementAt(index)['index']}',
                                        style: TextStyle(
                                            letterSpacing: -1.2,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: context.watch<UserProvider>().valuationProfitRate > 0 ?
                                        [
                                          Icon(Icons.arrow_drop_up_rounded, color: Colors.redAccent),
                                          Text('${context.watch<UserProvider>().valuationProfitRate.toStringAsFixed(2)} %',
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Colors.redAccent),)
                                        ] : context.watch<UserProvider>().valuationProfitRate == 0 ? [
                                          Text('- ${context.watch<UserProvider>().valuationProfitRate.toStringAsFixed(2)} %',
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Colors.grey),)
                                        ]: [
                                          Icon(Icons.arrow_drop_down_rounded, color: Colors.blue,),
                                          Text('${context.watch<UserProvider>().valuationProfitRate.toStringAsFixed(2)} %',
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: Colors.blue),)
                                        ]
                                    ),
                                    Text('${addComma(context.watch<UserProvider>().valuationProfit.ceil())}μ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: context.watch<UserProvider>().valuationProfit > 0
                                              ? Colors.redAccent
                                              : ( context.watch<UserProvider>().valuationProfit == 0 ? Colors.black54 : Colors.blueAccent)),
                                    ),                ]),

                            ]
                        ), Divider(
                          thickness: 0.5, color: Colors.grey.withOpacity(0.7),
                        )
                      ],
                    );
                  },
                ) : Center(child: Text('μμ', style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),), )
              ],
            ),
          )
        ],
      )
    );
  }

  List<TargetFocus> _createTargets(){
    List<TargetFocus> targets = [];
    /*----------------μ€νμμ΅----------------*/
    targets.add(
        TargetFocus(
          identify: "realizedProfit",
          keyTarget: realizedProfitKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller){
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('μ€νμμ΅', style: TextStyle(
                        color: Colors.white,
                        fontSize: 24, letterSpacing: -1.5,
                        fontWeight: FontWeight.bold
                      ),),
                      Divider(color: Colors.white),
                      Text('κ°μμμ λΆν° ν μκ°κΉμ§μ λ§€λν λμ μ€μ  μμ΅μ΄μμ.\nμ¦, λμ κ±°λκ° λ°μμν¨ μ΅μ’μ μΈ κ²°κ³ΌλΌκ³  ν  μ μμ΄μ.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, letterSpacing: -1.5,
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => controller.next(),
                            icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            )
          ]
        )
    );
    /*----------------νκ°μμ΅----------------*/
    targets.add(
        TargetFocus(
            identify: "valuationProfit",
            keyTarget: valuationProfitKey,
            alignSkip: Alignment.topLeft,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('νκ°μμ΅', style: TextStyle(
                              color: Colors.white,
                              fontSize: 24, letterSpacing: -1.5,
                              fontWeight: FontWeight.bold
                          ),),
                          Divider(color: Colors.white),
                          SingleChildScrollView(
                            child: Text('νμ¬ λ³΄μ ν μ’λͺ©μ λ§€μκ° κΈ°μ€ νκ°κΈμ‘μ΄μμ.\nλμ ν¬μκΈμ΄ νμ¬ μΌλ§μ κ°μΉλ‘ νμ°λμ΄μλμ§λ₯Ό μ μ μμ΄μ.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20, letterSpacing: -1.5,
                                )
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    /*----------------μ’λͺ©λ³ μμ΅----------------*/
    targets.add(
        TargetFocus(
            identify: "holdingsProfit",
            keyTarget: holdingsProfitKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('μ’λͺ©λ³ μμ΅', style: TextStyle(
                              color: Colors.white,
                              fontSize: 24, letterSpacing: -1.5,
                              fontWeight: FontWeight.bold
                          ),),
                          Divider(color: Colors.white),
                          SingleChildScrollView(
                            child: Text('νμ¬ λ³΄μ ν μ’λͺ©λ€μ νκ°μμ΅μ μλ €μ€μ.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20, letterSpacing: -1.5,
                                )
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    return targets;
  }
}

