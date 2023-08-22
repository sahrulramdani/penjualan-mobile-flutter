import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:penjualan_mobile/constants/public_const.dart';

class HttpBarang {
  String status;
  String message;
  String err;

  HttpBarang({this.status, this.message, this.err});

  static Future<HttpBarang> saveBarang(
    String namaBarang,
    String kategori,
    String harga,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/barang/save");
    var hasilResponse = await http.post(
      urlApi,
      body: {
        "nama": namaBarang,
        "kategori": kategori,
        "harga": harga,
      },
    );

    var data = json.decode(hasilResponse.body);
    return HttpBarang(
      status: data["status"],
      message: data["message"],
    );
  }

  static Future<HttpBarang> updateBarang(
    String kodeBarang,
    String namaBarang,
    String kategori,
    String harga,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/barang/update");
    var hasilResponse = await http.post(
      urlApi,
      body: {
        "id": kodeBarang,
        "nama": namaBarang,
        "kategori": kategori,
        "harga": harga,
      },
    );

    var data = json.decode(hasilResponse.body);
    return HttpBarang(
      status: data["status"],
      message: data["message"],
    );
  }

  static Future<HttpBarang> deleteBarang(
    String kodeBarang,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/barang/delete/$kodeBarang");
    var hasilResponse = await http.delete(urlApi);

    var data = json.decode(hasilResponse.body);
    return HttpBarang(
      status: data["status"],
      message: data["message"],
    );
  }
}
