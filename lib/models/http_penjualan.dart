import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:penjualan_mobile/constants/public_const.dart';

class HttpPenjualan {
  String status;
  String message;
  String err;

  HttpPenjualan({this.status, this.message, this.err});

  static Future<HttpPenjualan> savePenjualan(
    String idPelanggan,
    String tanggal,
    String subtotal,
    List<Map<String, dynamic>> listBarang,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/penjualan/save");
    var body = {
      "nama": idPelanggan,
      "tanggal": tanggal,
      "subtotal": subtotal,
      "listItem": listBarang,
    };
    var hasilResponse = await http.post(
      urlApi,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    var data = json.decode(hasilResponse.body);
    return HttpPenjualan(
      status: data["status"],
      message: data["message"],
    );
  }

  static Future<HttpPenjualan> updatePenjualan(
    String idPenjualan,
    String idPelanggan,
    String tanggal,
    String subtotal,
    List<Map<String, dynamic>> listBarang,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/penjualan/update");
    var body = {
      "id": idPenjualan,
      "nama": idPelanggan,
      "tanggal": tanggal,
      "subtotal": subtotal,
      "listItem": listBarang,
    };
    var hasilResponse = await http.post(
      urlApi,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    var data = json.decode(hasilResponse.body);
    return HttpPenjualan(
      status: data["status"],
      message: data["message"],
    );
  }

  static Future<HttpPenjualan> deletePenjualan(
    String idPenjualan,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/penjualan/delete/$idPenjualan");
    var hasilResponse = await http.delete(urlApi);

    var data = json.decode(hasilResponse.body);
    return HttpPenjualan(
      status: data["status"],
      message: data["message"],
    );
  }
}
