import 'HttpResponseModel.dart';

class DataDashboardModel extends HttpResponseModel {
  late String total_penjualan,
      total_transaksi,
      total_item;

  DataDashboardModel(
      {required this.total_penjualan,
      required this.total_transaksi,
      required this.total_item,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['total_penjualan'] = total_penjualan;
    result['total_transaksi'] = total_transaksi;
    result['total_item'] = total_item;

    return result;
  }

  DataDashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['total_penjualan'] != null) {
      total_penjualan = json['total_penjualan'];
    }
    if (json['total_transaksi'] != null) {
      total_transaksi = json['total_transaksi'];
    }
    if (json['total_item'] != null) {
      total_item = json['total_item'];
    }
  }
}