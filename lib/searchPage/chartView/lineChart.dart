import 'package:capstone1/providers/stock.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartContainer extends StatefulWidget {
  const ChartContainer({Key? key}) : super(key: key);

  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {

  List<FlSpot> setSpots(data){
    List<FlSpot> spots = [];
    List<double> prices = [];
    for (var element in data) {
      prices.add(element['closingPrice'] * 0.01);
    }
    for(int i=0;i<data.length;i++){
      spots.add(FlSpot(i+.0, prices[i]));
    }
    prices.sort();
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    var minY = 0.0;
    var maxY = 0.0;
    List<FlSpot> list = setSpots(context.read<StorePrice>().priceList);
    List<int> prices = [];
    for (var price in context.watch<StorePrice>().priceList){
      prices.add(price['closingPrice']);
    }
    prices.sort();
    minY = prices[0] * 0.01;
    maxY = prices[prices.length-1] *0.01;
    const leftStyle = TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    return ChangeNotifierProvider(
      create: (c) => StorePrice(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(4,8),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 24, 18, 12),
          child: LineChart(
            LineChartData(
                maxY: maxY + 3,
                minY: minY - 4,
                gridData: FlGridData(
                  show: false,
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Color(0xffB484FF).withOpacity(0.7),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((e){
                        final textStyle = TextStyle(
                          color: Colors.white,
                          fontSize: 17
                        );
                        var price = e.y * 100;
                        return LineTooltipItem('${price.toInt()}\n'
                            '${context.read<StorePrice>().priceList[e.x.toInt()]['date'].substring(5)}',
                            textStyle);
                      }).toList();
                    }
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta){
                            String text;
                            if(value % 10 == 0 && value != 0){
                              text = context.watch<StorePrice>().priceList[value.toInt()]['date'].substring(5);
                            }else{
                              text = '';
                            }
                            return Padding(
                              padding: EdgeInsets.only(top: 8.0), child: Text(text, style: leftStyle),
                            );
                          }
                      )
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: prices[prices.length-1] > 100000 ? 50 : 40,
                        getTitlesWidget: (value, meta){
                          if(value.toInt() == prices[0]*0.01){
                            return Text('${prices[0]}', style: leftStyle, textAlign: TextAlign.left,);
                          }else if(value.toInt() == prices[prices.length-1]*0.01){
                            return Text('${prices[prices.length-1]}', style: leftStyle, textAlign: TextAlign.left);
                          }
                          return Text('');
                        }
                    ),
                  ),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(width: 0.8, color: Colors.grey,),
                      bottom: BorderSide(width: 0.8, color: Colors.grey)
                    )
                ),
                lineBarsData: [
                  LineChartBarData(
                      spots: list,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: const [
                          Color(0xffff7d7d),
                          Color(0xff2892ff),
                        ].map((color) => color.withAlpha(200)).toList(),
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                          show: false
                      ),
                      belowBarData: BarAreaData(
                        show: false,
                      )
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}