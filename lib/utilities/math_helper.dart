class MathHelper{
  static String roundDecimal(double num){
    String strNum = num.toString();
    if(strNum.split(".").last.length > 4){
      return "${strNum.split(".").first}.${strNum.split(".").last.substring(0, 4)}";
    }else{
      return strNum;
    }
  }
}