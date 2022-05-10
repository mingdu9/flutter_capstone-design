import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/User.dart';
import '../homePage/analysis.dart';
import '../homePage/holding.dart';
import '../homePage/home.dart';
import 'firstTutorial.dart';


class HomeTutorial extends StatefulWidget {
  const HomeTutorial({Key? key}) : super(key: key);

  @override
  State<HomeTutorial> createState() => _HomeTutorialState();
}

class _HomeTutorialState extends State<HomeTutorial> {

  var tab = 0;

  void setTab(int n){
    setState(() {
      tab = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.6),
          ),
          [BalanceDesc(setTab: setTab,), ReturnDesc(setTab: setTab), HoldingDesc(setTab: setTab,)][tab],
        ]
    );
  }
}

class BalanceDesc extends StatelessWidget {
  const BalanceDesc({Key? key, this.setTab}) : super(key: key);
  final setTab;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: BalanceBox(balance: context.watch<StoreUser>().balance)
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('잔고', textAlign: TextAlign.left,style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold,
                    letterSpacing: -1.2, color: Colors.white
                ),),
                Divider(color: Colors.white,),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('현재 보유중인 잔고를 보여줘요, ', textAlign: TextAlign.left, style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                )
              ]
          ),
        ),
        Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: IconButton(
                splashColor: Colors.transparent,
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                onPressed: (){
                  setTab(1);
                },
              ),
            )
        )
      ],
    );
  }
}

class ReturnDesc extends StatelessWidget {
  const ReturnDesc({Key? key, this.setTab}) : super(key: key);
  final setTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 4),
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        splashColor: Colors.transparent,
                        onPressed: (){setTab(0);},
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                        onPressed: (){setTab(2);},
                      ),
                    ],
                  ),
                ),
                Text('수익 분석', textAlign: TextAlign.left,style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold,
                    letterSpacing: -1.2, color: Colors.white
                ),),
                Divider(color: Colors.white,),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(faker.lorem.sentences(5).join(' '), textAlign: TextAlign.left, style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                )
              ]
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: ReturnBox()
        ),
      ],
    );
  }
}

class HoldingDesc extends StatelessWidget {
  const HoldingDesc({Key? key, this.setTab}) : super(key: key);
  final setTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: HoldingsBox()
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('보유 종목', textAlign: TextAlign.left,style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold,
                    letterSpacing: -1.2, color: Colors.white
                ),),
                Divider(color: Colors.white,),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('가지고 있는 종목들을 보여줘요', textAlign: TextAlign.left, style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                )
              ]
          ),
        ),
        Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                    onPressed: (){
                      setTab(1);
                    },
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.clear, color: Colors.white,),
                    onPressed: (){
                      context.read<StoreBool>().setIsStarted();
                    },
                  ),
                ],
              ),
            )
        )
      ],
    );
  }
}
