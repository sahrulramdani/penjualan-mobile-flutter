// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:penjualan_mobile/component/modal_save_fail.dart';
import 'package:penjualan_mobile/component/modal_save_success.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'dart:convert';
import 'package:penjualan_mobile/models/http_barang.dart';

typedef OnDataAddedCallback = void Function(List<Map<String, dynamic>> newData);

class ModalDeleteBarang extends StatelessWidget {
  final OnDataAddedCallback onDataAdded;
  final String kodeBarang;

  const ModalDeleteBarang(
      {Key key, @required this.onDataAdded, @required this.kodeBarang})
      : super(key: key);

  void getBarang() async {
    var response = await http.get(Uri.parse("$urlAddress/barang"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    onDataAdded(data);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        color: myGrey,
        padding: const EdgeInsets.all(10),
        width: 300,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_alert_rounded,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 20),
            const FittedBox(
              child: Text(
                'Apakah Kamu Yakin Ingin Menghapus Data?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    HttpBarang.deleteBarang(kodeBarang).then(
                      (value) {
                        if (value.status == 'true') {
                          Navigator.pop(context);
                          getBarang();
                          showDialog(
                            context: context,
                            builder: (context) => ModalSaveSuccess(
                              message: value.message,
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => ModalSaveFail(
                              message: value.message,
                            ),
                          );
                        }
                      },
                    );
                  },
                  child: const Text('Yakin'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) {
                        return myGreen;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Kembali')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
