import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:penjualan_mobile/constants/public_const.dart';

class HttpPelanggan {
  String status;
  String message;
  String err;

  HttpPelanggan({this.status, this.message, this.err});

  static Future<HttpPelanggan> savePelanggan(
    String namaPelanggan,
    String domisili,
    String jenisKelamin,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/pelanggan/save");
    var hasilResponse = await http.post(
      urlApi,
      body: {
        "nama": namaPelanggan,
        "domisili": domisili,
        "jenis_kelamin": jenisKelamin,
      },
    );

    var data = json.decode(hasilResponse.body);
    return HttpPelanggan(
      status: data["status"],
      message: data["message"],
    );
  }

  static Future<HttpPelanggan> updatePelanggan(
    String idPelanggan,
    String namaPelanggan,
    String domisili,
    String jenisKelamin,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/pelanggan/update");
    var hasilResponse = await http.post(
      urlApi,
      body: {
        "id": idPelanggan,
        "nama": namaPelanggan,
        "domisili": domisili,
        "jenis_kelamin": jenisKelamin,
      },
    );

    var data = json.decode(hasilResponse.body);
    return HttpPelanggan(
      status: data["status"],
      message: data["message"],
    );
  }

  static Future<HttpPelanggan> deletePelanggan(
    String idPelanggan,
  ) async {
    Uri urlApi = Uri.parse("$urlAddress/pelanggan/delete/$idPelanggan");
    var hasilResponse = await http.delete(urlApi);

    var data = json.decode(hasilResponse.body);
    return HttpPelanggan(
      status: data["status"],
      message: data["message"],
    );
  }
}
