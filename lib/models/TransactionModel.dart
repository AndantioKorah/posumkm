import 'package:posumkm/models/TransactionDetailModel.dart';

import 'HttpResponseModel.dart';

class TransactionModel extends HttpResponseModel {
  late String id,
      id_m_merchant,
      tanggal_transaksi,
      nomor_transaksi,
      nama,
      total_harga,
      status_transaksi,
      total_item,
      list_nama_item;
  List<TransactionDetailModel> detail = [];

  TransactionModel(
      {required this.id,
      required this.id_m_merchant,
      required this.tanggal_transaksi,
      required this.nomor_transaksi,
      required this.nama,
      required this.total_harga,
      required this.detail,
      required this.status_transaksi,
      required this.total_item,
      required this.list_nama_item,
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_m_merchant'] = id_m_merchant;
    result['tanggal_transaksi'] = tanggal_transaksi;
    result['nomor_transaksi'] = nomor_transaksi;
    result['nama'] = nama;
    result['total_harga'] = total_harga;
    result['detail'] = detail;
    result['status_transaksi'] = status_transaksi;
    result['total_item'] = total_item;
    result['list_nama_item'] = list_nama_item;

    return result;
  }

  TransactionModel.setNull(){
    id = "0";
    id_m_merchant = "";
    tanggal_transaksi = "";
    nomor_transaksi = "";
    nama = "";
    total_harga = "";
    detail = [];
    status_transaksi = "";
    total_item = "0";
    list_nama_item = "";
  }

  TransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['id_m_merchant'] != null) {
      id_m_merchant = json['id_m_merchant'];
    }
    if (json['tanggal_transaksi'] != null) {
      tanggal_transaksi = json['tanggal_transaksi'];
    }
    if (json['nomor_transaksi'] != null) {
      nomor_transaksi = json['nomor_transaksi'];
    }
    if (json['nama'] != null) {
      nama = json['nama'];
    }
    if (json['total_harga'] != null) {
      total_harga = json['total_harga'];
    }
    if (json['detail'] != null) {
      detail = convertToListTransactionDetail(json['detail']);
    }
    if (json['status_transaksi'] != null) {
      status_transaksi = json['status_transaksi'];
    }
    if (json['total_item'] != null) {
      total_item = json['total_item'].toString();
    }
    if (json['list_nama_item'] != null) {
      list_nama_item = json['list_nama_item'];
    }
  }
}

List<TransactionModel> convertToList(List<dynamic> res) {
  List<TransactionModel> transactionModel = [];
  TransactionModel? temp;

  for (var i = 0; i < res.length; i++) {
    temp = TransactionModel.fromJson(res[i]);
    transactionModel.add(temp);
  }

  return transactionModel;
}