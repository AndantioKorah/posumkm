import 'package:posumkm/models/TransactionDetailModel.dart';

import 'HttpResponseModel.dart';

class TransactionModel extends HttpResponseModel {
  late String id,
      id_m_merchant,
      tanggal_transaksi,
      nomor_transaksi,
      nama,
      total_harga,
      status_transaksi;
  List<TransactionDetailModel> detail = [];

  TransactionModel(
      {required this.id,
      required this.id_m_merchant,
      required this.tanggal_transaksi,
      required this.nomor_transaksi,
      required this.nama,
      required this.total_harga,
      required this.detail,
      required this.status_transaksi});

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
  }
}
