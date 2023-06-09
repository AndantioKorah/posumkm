// ignore: file_names
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

class Utils{
  String formatCurrency(dynamic amount, String formatOutput){
    MoneyFormatterOutput result = MoneyFormatter(
        amount: double.parse(amount),
        settings: MoneyFormatterSettings(
          symbol: 'Rp',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 0,
        )
    ).output;

    switch (formatOutput){
      case "nonSymbol": return result.nonSymbol;
      case "symbolOnLeft": return result.symbolOnLeft;
      case "symbolOnRight" : return result.symbolOnRight;
      case "compactNonSymbol" : return result.compactNonSymbol;
      case "compactSymbolOnLeft" : return result.compactSymbolOnLeft;
      case "compactSymbolOnRight" : return result.compactSymbolOnRight;
      case "fractionDigitsOnly" : return result.fractionDigitsOnly;
      case "withoutFractionDigits" : return result.withoutFractionDigits;
      default: return result.symbolOnLeft;
    }
  }

  String formatDateOnly(String date, String divider){
    switch(divider){
      case "-": return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
      case "/": return DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
      default: return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
    }
  }

  String formatDate(String date, String divider){
    switch(divider){
      case "-": return DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(date));
      case "/": return DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(date));
      default: return DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(date));
    }
  }

  Map<String, int> extractDate(String date){
    final split = date.split(" ");
    final dateSplit = split[0].split("-");
    final timeSplit = split[1].split(":");
    return {
      "year": int.parse(dateSplit[0]),
      "month": int.parse(dateSplit[1]),
      "date": int.parse(dateSplit[2]),
      "hour": int.parse(timeSplit[0]),
      "minute": int.parse(timeSplit[1]),
      "second": int.parse(timeSplit[2]),
    };
  }
}