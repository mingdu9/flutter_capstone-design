
double calculateRate(totalProfit, totalBuyPrice){
  // double result = (closingPrice / averagePrice) * 100 - 100;
  double result = (totalProfit / totalBuyPrice) * 100;
  return result;
}

num calculateProfit(sellPrice, buyPrice, int count){
  num result = (sellPrice - buyPrice) * count;
  return result;
}

String addComma(num price){
  if(price > 0){
    List<String> split = price.toString().split("");
    List<String> result = List.of(split);
    for(int i=split.length-3;i>=0;i=i-3){
      result.insert(i, ',');
    }
    if(result.first == ',') result.removeAt(0);
    return result.join();
  }else if(price < 0){
    List<String> split = price.abs().toString().split("");
    List<String> result = List.of(split);
    for(int i=split.length-3;i>=0;i=i-3){
      result.insert(i, ',');
    }
    if(result.first == ',') result.removeAt(0);
    result.insert(0, '-');
    return result.join();
  }
  return '0';
}