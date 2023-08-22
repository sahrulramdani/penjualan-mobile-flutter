import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:penjualan_mobile/pages/barang/widgets/modal_cu_barang.dart';
import 'package:penjualan_mobile/pages/barang/widgets/modal_delete_barang.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({Key key}) : super(key: key);

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<Map<String, dynamic>> listBarang = [];
  List<Map<String, dynamic>> listBarangBack = [];

  getBarang() async {
    var response = await http.get(Uri.parse("$urlAddress/barang"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    setState(() {
      listBarang = data;
      listBarangBack = data;
    });
  }

  @override
  void initState() {
    getBarang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: SizedBox(
        width: screenWidth,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                FittedBox(
                  child: Text(
                    'Halaman Barang',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ModalCuBarang(
                        onDataAdded: (newData) {
                          setState(() {
                            listBarang = newData;
                            listBarangBack = newData;
                          });
                        },
                        cd: 'Tambah',
                        kodeBarang: '',
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: fncLabelWhite('Tambah'),
                  style: fncButtonStyle(myGreen),
                ),
              ],
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
                                    myFormat.format(listBarang[index]['HARGA']),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ModalCuBarang(
                                        cd: 'Detail',
                                        kodeBarang: listBarang[index]['KODE'],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ModalCuBarang(
                                          onDataAdded: (newData) {
                                            setState(() {
                                              listBarang = newData;
                                              listBarangBack = newData;
                                            });
                                          },
                                          cd: 'Edit',
                                          kodeBarang: listBarang[index]['KODE'],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ModalDeleteBarang(
                                            onDataAdded: (newData) {
                                              setState(() {
                                                listBarang = newData;
                                                listBarangBack = newData;
                                              });
                                            },
                                            kodeBarang: listBarang[index]
                                                ['KODE']),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
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
          ],
        ),
      ),
    );
  }
}
