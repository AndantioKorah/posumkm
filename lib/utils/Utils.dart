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

  String formatDateOnlyNamaBulan(String date){
    final split = date.split("-");
    return "${split[2]} ${getNamaBulan(split[1])} ${split[0]}";
  }

  String getNamaBulan(String bulan){
    switch(bulan){
      case "1" : return "Januari";
      case "2" : return "Februari";
      case "3" : return "Maret";
      case "4" : return "April";
      case "5" : return "Mei";
      case "6" : return "Juni";
      case "7" : return "Juli";
      case "8" : return "Agustus";
      case "9" : return "September";
      case "10" : return "Oktober";
      case "11" : return "November";
      case "12" : return "Desember";
      default: return "Januari";
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