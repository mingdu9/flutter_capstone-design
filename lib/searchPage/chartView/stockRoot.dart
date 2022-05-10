import 'package:capstone1/Models/User.dart';
import 'package:capstone1/Models/stock.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'lineChart.dart';


class Stock extends StatefulWidget {
  const Stock({Key? key, this.tab, this.ticker}) : super(key: key);
  final ticker;
  final tab;

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  int selltotal = 0;
  int buytotal = 0;
  int index = 0;

  final TextEditingController sellController = TextEditingController();
  final TextEditingController buyController = TextEditingController();

  findHoldingNum(List<dynamic> holdings, ticker){
    print('holdings: ${holdings}');
    setState(() {
      if(holdings.isNotEmpty){
        for (int i=0;i<=holdings.length-1;i++) {
          if(holdings[i]['ticker'] == ticker){
            index =  i;
            return;
          }
        }
        index = -1;
      }else{
        index = -1;
      }
      print('index: ${index}');
    });
  }

  getData()async{
    await context.read<StorePrice>().setPriceList(widget.ticker);
    await context.read<StoreUser>().defineUser();
    findHoldingNum(context.read<StoreUser>().holdings, widget.ticker);
    print('index: ${index}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('stock detail ticker : ${widget.ticker}');
    getData();
  }

  String addString(List<dynamic> list){
    String result = '';
    for (var element in list) {
      result+=element+'/';
    }
    return result.substring(0, result.length-1);
  }

  @override
  Widget build(BuildContext context) {
    sell(int count) async {
      int price = context.read<StorePrice>().lastPrice['price'];
      int balance = context.read<StoreUser>().balance;
      await context.read<StoreUser>().updateBalance(balance + price*count);
      await context.read<StoreUser>().updateCount(
          context.read<StoreUser>().holdings[index]['count']-count, index, widget.ticker);
    }
    buy(int count) async{
      int price = context.read<StorePrice>().lastPrice['price'];
      int balance = context.read<StoreUser>().balance;
      await context.read<StoreUser>().updateBalance(balance - (price*count));
      if(index < 0){
        await context.read<StoreUser>().addHolding(count, widget.ticker);
      }else{
        await context.read<StoreUser>().updateCount(
            context.read<StoreUser>().holdings[index]['count']+count, index, widget.ticker);
      }
    }

    var titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 29,
        letterSpacing: -1.2
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => GoRouter.of(context).go('/mainTab/${widget.tab}'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: (){
                    setState(() {
                      buytotal = 0;
                    });
                    buyController.clear();
                    showDialog(context: context, builder: (context){
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        backgroundColor: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xffff7d7d).withOpacity(0.1) , Colors.white],
                                  begin: Alignment(0.0,-2.0), end: Alignment(0.0, -0.5)
                                )
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('매수', style: TextStyle(
                                    fontSize: 33, fontWeight: FontWeight.bold,
                                  )),
                                  Divider(height: 13),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('현재가', style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Text('${context.watch<StorePrice>().lastPrice['price']}원', style: TextStyle(
                                              fontSize: 20,
                                            ),)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('잔고', style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Text('${context.watch<StoreUser>().balance}원', style: TextStyle(
                                              fontSize: 20,
                                            ),)
                                          ],
                                        ),
                                        Divider(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('개수', style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Container(
                                              padding: EdgeInsets.only(bottom: 4),
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: TextField(
                                                controller: buyController,
                                                onChanged: (value){
                                                  if(value.isEmpty){
                                                    setState(() {
                                                      buytotal = 0;
                                                    });
                                                  }else{
                                                    setState(() {
                                                      buytotal = context.read<StorePrice>().lastPrice['price'] * int.parse(value);
                                                    });
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    hintText: '최대 30주씩',
                                                    hintStyle: TextStyle(
                                                        fontSize: 17
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('총 금액', style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Text('$buytotal원', style: TextStyle(
                                              fontSize: 20,
                                            ),)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 8),
                                        child: ElevatedButton(
                                          child: Text('매수', style: TextStyle(color: Color(0xffff7d7d)),),
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 18),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(13),
                                                side: BorderSide(color: Color(0xffff7d7d),width: 2)
                                            ),
                                            onPrimary: Color(0xffff7d7d),
                                            primary: Colors.white,
                                          ),
                                          onPressed: (){
                                            if(int.parse(buyController.text) *
                                                context.read<StorePrice>().lastPrice['price']
                                                <= context.read<StoreUser>().balance ){
                                              buy(int.parse(buyController.text));
                                              Navigator.pop(context);
                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('매수 실패'))
                                              );
                                            }

                                            },
                                        ),
                                      ),
                                      ElevatedButton(
                                        child: Text('취소', style: TextStyle(color: Color(0xff7f7f7f)),),
                                        style: ElevatedButton.styleFrom(
                                          textStyle: TextStyle(fontSize: 18),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(13),
                                              side: BorderSide(color: Color(
                                                  0xff7f7f7f),width: 2)
                                          ),
                                          onPrimary: Color(0xff7f7f7f),
                                          primary: Colors.white,
                                        ),
                                        onPressed: (){Navigator.pop(context);},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
                    },
                child: Text('매수', style: TextStyle(
                  fontSize: 20,
                ),),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
                    primary: const Color(0xffff7d7d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    )
                ),),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    selltotal = 0;
                  });
                  sellController.clear();
                  // GoRouter.of(context).
                  showDialog(context: context, builder: (context){
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [Color(0xff2892ff).withOpacity(0.1) , Colors.white],
                                begin: Alignment(0.0,-2.0), end: Alignment(0.0, -0.5)
                            )
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('매도', style: TextStyle(
                                    fontSize: 33, fontWeight: FontWeight.bold,
                                  )),
                                  Divider(height: 13),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('현재가', style: TextStyle(
                                              fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Text('${context.watch<StorePrice>().lastPrice['price']}원', style: TextStyle(
                                              fontSize: 20,
                                            ),)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('보유 개수', style: TextStyle(
                                            fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Text('${context.watch<StoreUser>().holdings.isEmpty? '0' : context.watch<StoreUser>().holdings[index]['count']}주',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('개수', style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Container(
                                              padding: EdgeInsets.only(bottom: 4),
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: TextField(
                                                controller: sellController,
                                                onChanged: (text){
                                                  if(text.isEmpty){
                                                    setState(() {
                                                      selltotal = 0;
                                                    });
                                                  }else{
                                                    setState(() {
                                                      selltotal = context.read<StorePrice>().lastPrice['price'] * int.parse(text);
                                                    });
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    hintText: '최대 30주씩',
                                                    hintStyle: TextStyle(
                                                        fontSize: 17
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('총 금액', style: TextStyle(
                                                fontSize: 23, fontWeight: FontWeight.bold
                                            ),),
                                            Text('$selltotal원', style: TextStyle(
                                              fontSize: 20,
                                            ),)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 8),
                                        child: ElevatedButton(
                                          child: Text('매도', style: TextStyle(color: Color(0xff2892ff)),),
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 18),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(13),
                                              side: BorderSide(color: Color(0xff2892ff),width: 2)
                                            ),
                                            onPrimary: Color(0xff2892ff),
                                            primary: Colors.white,
                                          ),
                                          onPressed: (){
                                            if(index < 0){
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('매도 실패'))
                                              );
                                            }
                                            else if(int.parse(sellController.text) >=
                                                context.read<StoreUser>().holdings[index]['count']
                                              && int.parse(sellController.text) <= 30){
                                              sell(int.parse(sellController.text));
                                              Navigator.pop(context);
                                            }else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('매도 실패'))
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                        child: Text('취소', style: TextStyle(color: Color(0xff7f7f7f)),),
                                        style: ElevatedButton.styleFrom(
                                          textStyle: TextStyle(fontSize: 18),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(13),
                                              side: BorderSide(color: Color(
                                                  0xff7f7f7f),width: 2)
                                          ),
                                          onPrimary: Color(0xff7f7f7f),
                                          primary: Colors.white,
                                        ),
                                        onPressed: (){Navigator.pop(context);},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
                },
                child: Text('매도', style: TextStyle(
                  fontSize: 20,
                ),),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body:  context.watch<StorePrice>().stockInfo['index'].runtimeType == Null ? Center(child: CircularProgressIndicator()) : ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(addString(context.watch<StorePrice>().stockInfo['index']), style: TextStyle(
                        fontSize: 17, color: Colors.black26
                    ),),
                    Text(context.watch<StorePrice>().stockInfo['name'], style: titleStyle,),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${context.watch<StorePrice>().lastPrice['price']}원', style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.values[5],
                        color: context.watch<StorePrice>().lastPrice['changeRate'] > 0 ? Colors.red : Colors.blueAccent
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: context.watch<StorePrice>().lastPrice['changeRate'] > 0 ?
                      [
                        Icon(Icons.arrow_drop_up_rounded, color: Colors.red),
                        Text('${context.watch<StorePrice>().lastPrice['changeRate']} %',
                          style: TextStyle(fontSize: 15, color: Colors.red),)
                      ] :
                      [ Icon(Icons.arrow_drop_down_rounded, color: Colors.blue,),
                        Text('${context.watch<StorePrice>().lastPrice['changeRate']} %',
                          style: TextStyle(fontSize: 15, color: Colors.blue),)
                      ],
                    ),
                  ],
                )],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
              child: ChartContainer(),
              // child: Text('chart')
          ),
          InfoBox(),
        ],
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(4,8),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('관련 정보', style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2,
              fontSize: 26,
            ),),
            Divider(thickness: 0.8, color: Colors.grey.withOpacity(0.8),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('기사', style: TextStyle(
                    letterSpacing: -1.2,
                    fontSize: 18,
                  ),),
                  Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('기사', style: TextStyle(
                    letterSpacing: -1.2,
                    fontSize: 18,
                  ),),
                  Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),),
                ],
              ),
            ),Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('기사', style: TextStyle(
                    letterSpacing: -1.2,
                    fontSize: 18,
                  ),),
                  Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
