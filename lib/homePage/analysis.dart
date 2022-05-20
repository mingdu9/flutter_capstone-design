import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/User.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ReturnBox extends StatelessWidget {
  const ReturnBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var summaries = context.watch<StoreUser>().sumList;
    var mainStyle = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(4, 8),
        )
      ],
      borderRadius: BorderRadius.circular(8.0),
    );
    const titleStyle = TextStyle(
      fontSize: 27,
      fontWeight: FontWeight.bold,
      letterSpacing: -2.0,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      padding: EdgeInsets.all(20),
      decoration: mainStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '수익률',
                style: titleStyle,
              ),
              IconButton(
                  onPressed: (){print('more');},
                  icon: Icon(Icons.arrow_forward_ios)
              )
            ],
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.withOpacity(0.7),
          ),
          context.watch<StoreUser>().holdings.isEmpty
              ? Center(
                  child: Text(
                    '없음',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: summaries.length >= 3 ? 3 : summaries.length,
                  itemBuilder: (context, index) {
                    final currentSummary = summaries.elementAt(index);
                    String rate = calculateRate(currentSummary['closingPrice'], context.watch<StoreUser>().holdings[index]['average']).toStringAsFixed(2);
                    num profit = calculateProfit(currentSummary['closingPrice'], context.watch<StoreUser>().holdings[index]['average'], context.watch<StoreUser>().holdings[index]['count']);
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go(
                            '/mainTab/0/stockDetail/${currentSummary['ticker']}');
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${currentSummary['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -1.2,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        '${currentSummary['index']}',
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
                                    children: double.parse(rate) > 0
                                        ? [
                                            Icon(Icons.arrow_drop_up_rounded,
                                                color: Colors.red),
                                            Text(
                                              '$rate %',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.red),
                                            )
                                          ]
                                        : (double.parse(rate) == 0 ? [
                                      Text(
                                        '- $rate %',
                                        style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.grey),
                                      )
                                    ]: [
                                            Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              '$rate %',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.blue),
                                            )
                                          ]),
                                  ),
                                  Text(
                                    '${profit.ceil()}원',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: double.parse(rate) > 0
                                            ? Colors.red
                                            : ( double.parse(rate) == 0 ? Colors.black54 : Colors.blueAccent)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Colors.grey.withOpacity(0.7),
                          )
                        ],
                      ),
                    );
                  })
        ],
      ),
    );
  }
}

