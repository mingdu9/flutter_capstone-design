
double calculateRate(int closingPrice, var averagePrice){
  double result = (closingPrice / averagePrice) * 100 - 100;
  return result;
}

num calculateProfit(int closingPrice, var averagePrice, int count){
  num result = (closingPrice - averagePrice) * count;
  return result;
}