import 'HttpResponseModel.dart';

class TransactionDetailModel extends HttpResponseModel {
  late String id,
      id_t_transaksi,
      id_m_menu_merchant,
      harga,
      qty,
      total_harga,
      nama_menu_merchant;

  TransactionDetailModel({
    required this.id,
    required this.id_t_transaksi,
    required this.id_m_menu_merchant,
    required this.harga,
    required this.qty,
    required this.total_harga,
    required this.nama_menu_merchant,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_t_transaksi'] = id_t_transaksi;
    result['id_m_menu_merchant'] = id_m_menu_merchant;
    result['harga'] = harga;
    result['qty'] = qty;
    result['nama_menu_merchant'] = nama_menu_merchant;

    return result;
  }

  TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['id_t_transaksi'] != null) {
      id_t_transaksi = json['id_t_transaksi'];
    }
    if (json['id_m_menu_merchant'] != null) {
      id_m_menu_merchant = json['id_m_menu_merchant'];
    }
    if (json['harga'] != null) {
      harga = json['harga'];
    }
    if (json['qty'] != null) {
      qty = json['qty'];
    }
    if (json['nama_menu_merchant'] != null) {
      nama_menu_merchant = json['nama_menu_merchant'];
    }
  }
}

List<TransactionDetailModel> convertToListTransactionDetail(List<dynamic> res) {
  List<TransactionDetailModel> transactionDetailModel = [];
  TransactionDetailModel? temp;

  for (var i = 0; i < res.length; i++) {
    temp = TransactionDetailModel.fromJson(res[i]);
    transactionDetailModel.add(temp);
  }

  return transactionDetailModel;
}
