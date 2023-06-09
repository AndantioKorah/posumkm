import 'HttpResponseModel.dart';

class PembayaranModel extends HttpResponseModel {
  late String id,
      id_t_transaksi,
      id_m_jenis_pembayaran,
      id_m_merchant,
      tanggal_pembayaran,
      total_pembayaran,
      nomor_referensi_pembayaran = "-",
      keterangan,
      nomor_pembayaran,
      nama_jenis_pembayaran,
      nama_pembayar,
      kembalian;

  PembayaranModel({
    required this.id,
    required this.id_t_transaksi,
    required this.id_m_jenis_pembayaran,
    required this.id_m_merchant,
    required this.tanggal_pembayaran,
    required this.total_pembayaran,
    required this.nomor_referensi_pembayaran,
    required this.keterangan,
    required this.nomor_pembayaran,
    required this.nama_jenis_pembayaran,
    required this.nama_pembayar,
    required this.kembalian,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_t_transaksi'] = id_t_transaksi;
    result['id_m_jenis_pembayaran'] = id_m_jenis_pembayaran;
    result['id_m_merchant'] = id_m_merchant;
    result['tanggal_pembayaran'] = tanggal_pembayaran;
    result['total_pembayaran'] = total_pembayaran;
    result['nomor_referensi_pembayaran'] = nomor_referensi_pembayaran;
    result['keterangan'] = keterangan;
    result['nomor_pembayaran'] = nomor_pembayaran;
    result['nama_jenis_pembayaran'] = nama_jenis_pembayaran;
    result['nama_pembayar'] = nama_pembayar;
    result['kembalian'] = kembalian;

    return result;
  }

  PembayaranModel.setNull(){
    id = "0";
    id_t_transaksi = "";
    id_m_jenis_pembayaran = "";
    id_m_merchant = "";
    tanggal_pembayaran = "";
    total_pembayaran = "";
    nomor_referensi_pembayaran = "";
    keterangan = "";
    nomor_pembayaran = "";
    nama_jenis_pembayaran = "";
    nama_pembayar = "";
    kembalian = "";
  }

  PembayaranModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['id_t_transaksi'] != null) {
      id_t_transaksi = json['id_t_transaksi'];
    }
    if (json['id_m_jenis_pembayaran'] != null) {
      id_m_jenis_pembayaran = json['id_m_jenis_pembayaran'];
    }
    if (json['id_m_merchant'] != null) {
      id_m_merchant = json['id_m_merchant'];
    }
    if (json['tanggal_pembayaran'] != null) {
      tanggal_pembayaran = json['tanggal_pembayaran'];
    }
    if (json['total_pembayaran'] != null) {
      total_pembayaran = json['total_pembayaran'];
    }
    if (json['nomor_referensi_pembayaran'] != null) {
      nomor_referensi_pembayaran = json['nomor_referensi_pembayaran'];
    } else {
      nomor_referensi_pembayaran = "-";
    }
    if (json['keterangan'] != null) {
      keterangan = json['keterangan'];
    }
    if (json['nomor_pembayaran'] != null) {
      nomor_pembayaran = json['nomor_pembayaran'];
    }
    if (json['nama_jenis_pembayaran'] != null) {
      nama_jenis_pembayaran = json['nama_jenis_pembayaran'];
    }
    if (json['nama_pembayar'] != null) {
      nama_pembayar = json['nama_pembayar'];
    }
    if (json['kembalian'] != null) {
      kembalian = json['kembalian'];
    }
  }
}
