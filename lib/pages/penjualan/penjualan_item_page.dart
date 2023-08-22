// ignore_for_file: sort_child_properties_last, must_be_immutable

import 'package:flutter/material.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:penjualan_mobile/pages/penjualan/widgets/modal_penjualan_item.dart';

typedef OnDataAddedCallback = void Function(List<Map<String, dynamic>> newData);

class PenjualanItemPage extends StatefulWidget {
  OnDataAddedCallback onDataAdded;
  final String cd;
  final String idPenjualan;
  PenjualanItemPage({
    Key key,
    @required this.cd,
    @required this.idPenjualan,
    @required this.onDataAdded,
  }) : super(key: key);

  @override
  State<PenjualanItemPage> createState() => _PenjualanItemPageState();
}

class _PenjualanItemPageState extends State<PenjualanItemPage> {
  List<Map<String, dynamic>> listBarang = [];
  List<Map<String, dynamic>> listBarangBack = [];
  int jumlahItem = 0;
  int subTotal = 0;

  getBarang() async {
    var response = await http.get(Uri.parse("$urlAddress/barang"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var add = {
          "CEK": false,
          "KODE": data[i]['KODE'],
          "NAMA": data[i]['NAMA'],
          "KATEGORI": data[i]['KATEGORI'],
          "HARGA": data[i]['HARGA'],
          "QTY": 0,
          "SUBTOTAL": 0,
        };

        listBarang.add(add);
        listBarangBack.add(add);
      }
    }

    setState(() {});
  }

  getDetail() async {
    var response = await http
        .get(Uri.parse("$urlAddress/penjualan/${widget.idPenjualan}"));
    List<Map<String, dynamic>> data = [json.decode(response.body)['data']];

    if (data.isNotEmpty) {
      var item = data[0]['item_penjualan'];

      for (var i = 0; i < listBarang.length; i++) {
        for (var items in item) {
          if (listBarang[i]['KODE'] == items['KODE']) {
            listBarang[i]['CEK'] = true;
            listBarang[i]['QTY'] += items['Qty'];
            listBarang[i]['SUBTOTAL'] +=
                int.parse(items['SUBTOTAL'].toString().replaceAll(',', ''));

            jumlahItem += items['Qty'];
            subTotal +=
                int.parse(items['SUBTOTAL'].toString().replaceAll(',', ''));
          }
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    getBarang();
    if (widget.cd != 'Tambah') {
      getDetail();
    }
    super.initState();
  }

  fncAddBarang() {
    jumlahItem = 0;
    subTotal = 0;

    for (var i = 0; i < listBarang.length; i++) {
      if (listBarang[i]['QTY'] > 0) {
        jumlahItem += listBarang[i]['QTY'];
        subTotal += listBarang[i]['SUBTOTAL'];
      }
    }
    setState(() {});
  }

  fncGetData() {
    getPenjualan();
  }

  void getPenjualan() async {
    var response = await http.get(Uri.parse("$urlAddress/penjualan"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    widget.onDataAdded(data);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: myGrey,
      appBar: AppBar(
        title: const Text('Pembelian Barang'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                color: myGrey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        FittedBox(
                          child: Text(
                            'Daftar Barang',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          hintText: 'Cari Nama Barang',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: midBlackBody,
                          suffixIcon: const Icon(
                            Icons.search_outlined,
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (value) {
                          if (value == '') {
                            setState(() {
                              listBarang = listBarangBack;
                            });
                          } else {
                            setState(() {
                              listBarang = listBarangBack
                                  .where(((element) => element['NAMA']
                                      .toString()
                                      .toUpperCase()
                                      .contains(value.toUpperCase())))
                                  .toList();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listBarang.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: midBlackBody,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: ListTile(
                                          tileColor: Colors.green,
                                          title: Text(
                                            listBarang[index]['NAMA'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${listBarang[index]['KODE']} - ${listBarang[index]['KATEGORI']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          trailing: Text(
                                            myFormat.format(
                                                listBarang[index]['HARGA']),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    listBarang[index]['CEK'] == false
                                        ? SizedBox(
                                            width: 110,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      listBarang[index]['CEK'] =
                                                          true;

                                                      listBarang[index]['QTY'] =
                                                          1;
                                                      listBarang[index]
                                                              ['SUBTOTAL'] =
                                                          (listBarang[index]
                                                                  ['QTY'] *
                                                              listBarang[index]
                                                                  ['HARGA']);
                                                    });

                                                    fncAddBarang();
                                                  },
                                                  child: const Text(
                                                    'Tambah',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  style: fncButtonThinStyle(
                                                      myGreen),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            width: 110,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      listBarang[index]
                                                          ['QTY'] -= 1;
                                                      listBarang[index]
                                                              ['SUBTOTAL'] =
                                                          (listBarang[index]
                                                                  ['QTY'] *
                                                              listBarang[index]
                                                                  ['HARGA']);

                                                      if (listBarang[index]
                                                              ['QTY'] <
                                                          1) {
                                                        listBarang[index]
                                                            ['CEK'] = false;
                                                      }
                                                    });

                                                    fncAddBarang();
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .do_disturb_on_outlined,
                                                    color: myRed,
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                Text(
                                                  listBarang[index]['QTY']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(child: Container()),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      listBarang[index]
                                                          ['QTY'] += 1;
                                                      listBarang[index]
                                                              ['SUBTOTAL'] =
                                                          (listBarang[index]
                                                                  ['QTY'] *
                                                              listBarang[index]
                                                                  ['HARGA']);
                                                    });

                                                    fncAddBarang();
                                                  },
                                                  icon: Icon(
                                                    Icons.add_circle_outline,
                                                    color: myGreen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    jumlahItem > 0
                        ? Container(
                            height: 100,
                            color: myGrey,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ModalPenjualanItem(
                                              cd: widget.cd,
                                              idPenjualan: widget.idPenjualan,
                                              subTotal: (subTotal).toString(),
                                              getPenjualan: fncGetData,
                                              listBarang: listBarang
                                                  .where(((element) =>
                                                      element['CEK'] == true))
                                                  .toList(),
                                            ));
                                  },
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: myGreen,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${jumlahItem ?? 0} Item",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(child: Container()),
                                        Text(
                                          myFormat.format(subTotal ?? 0),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.shopping_cart_rounded,
                                            color: Colors.white),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(width: 0, height: 0)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
