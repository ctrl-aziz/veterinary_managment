class MathHelper{
  static String roundDecimals(double num){
    String strNum = num.toString();
    if(strNum.split(".").last.length > 4){
      return "${strNum.split(".").first}.${strNum.split(".").last.substring(0, 4)}";
    }else{
      return strNum;
    }
  }


  static String roundDecimalDouble(double num){
    String strNum = num.toString();
    if(strNum.split(".").last.length > 4){
      double splitNum = double.parse("${strNum.split(".").first}.${strNum.split(".").last.substring(0, 4)}");
      if((splitNum.roundToDouble() - splitNum).abs() < 0.01){
        return splitNum.roundToDouble().toString();
      }else{
        return splitNum.toString();
      }
    }else{
      double splitNum = double.parse(strNum);
      if((splitNum.roundToDouble() - splitNum).abs() < 0.01){
        return splitNum.roundToDouble().toString();
      }else{
        return splitNum.toString();
      }
    }
  }
}