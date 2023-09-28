import 'HttpResponseModel.dart';

class DataDashboardModel extends HttpResponseModel {
  late String total_penjualan,
      total_penjualan_lunas,
      total_penjualan_belum_lunas,
      total_transaksi,
      total_transaksi_lunas,
      total_transaksi_belum_lunas,
      total_item,
      total_item_lunas,
      total_item_belum_lunas;

  DataDashboardModel(
      {required this.total_penjualan,
      required this.total_penjualan_lunas,
      required this.total_penjualan_belum_lunas,
      required this.total_transaksi,
      required this.total_transaksi_lunas,
      required this.total_transaksi_belum_lunas,
      required this.total_item,
      required this.total_item_lunas,
      required this.total_item_belum_lunas,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['total_penjualan'] = total_penjualan;
    result['total_penjualan_lunas'] = total_penjualan_lunas;
    result['total_penjualan_belum_lunas'] = total_penjualan_belum_lunas;
    result['total_transaksi'] = total_transaksi;
    result['total_transaksi_belum_lunas'] = total_transaksi_belum_lunas;
    result['total_transaksi_lunas'] = total_transaksi_lunas;
    result['total_item'] = total_item;
    result['total_item_lunas'] = total_item_lunas;
    result['total_item_belum_lunas'] = total_item_belum_lunas;

    return result;
  }

  DataDashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['total_penjualan'] != null) {
      total_penjualan = json['total_penjualan'];
    }
    if (json['total_penjualan_lunas'] != null) {
      total_penjualan_lunas = json['total_penjualan_lunas'];
    }
    if (json['total_penjualan_belum_lunas'] != null) {
      total_penjualan_belum_lunas = json['total_penjualan_belum_lunas'];
    }
    if (json['total_transaksi'] != null) {
      total_transaksi = json['total_transaksi'];
    }
    if (json['total_transaksi_lunas'] != null) {
      total_transaksi_lunas = json['total_transaksi_lunas'];
    }
    if (json['total_transaksi_belum_lunas'] != null) {
      total_transaksi_belum_lunas = json['total_transaksi_belum_lunas'];
    }
    if (json['total_item'] != null) {
      total_item = json['total_item'];
    }
    if (json['total_item_lunas'] != null) {
      total_item_lunas = json['total_item_lunas'];
    }
    if (json['total_item_belum_lunas'] != null) {
      total_item_belum_lunas = json['total_item_belum_lunas'];
    }
  }
}