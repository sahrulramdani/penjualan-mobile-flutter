import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:penjualan_mobile/pages/barang/widgets/modal_cu_barang.dart';
import 'package:penjualan_mobile/pages/barang/widgets/modal_delete_barang.dart';
import 'package:penjualan_mobile/pages/penjualan/penjualan_item_page.dart';
import 'package:penjualan_mobile/pages/penjualan/widgets/modal_hapus_penjualan.dart';
import 'package:penjualan_mobile/pages/penjualan/widgets/modal_penjualan_item.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({Key key}) : super(key: key);

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  List<Map<String, dynamic>> listPenjualan = [];
  List<Map<String, dynamic>> listPenjualanBack = [];

  getPenjualan() async {
    var response = await http.get(Uri.parse("$urlAddress/penjualan"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    setState(() {
      listPenjualan = data;
      listPenjualanBack = data;
    });
  }

  @override
  void initState() {
    getPenjualan();
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
                    'Halaman Penjualan',
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
                  hintText: 'Cari Nota Penjualan',
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
                      listPenjualan = listPenjualanBack;
                    });
                  } else {
                    setState(() {
                      listPenjualan = listPenjualanBack
                          .where(((element) => element['ID_NOTA']
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PenjualanItemPage(
                          cd: 'Tambah',
                          idPenjualan: '',
                          onDataAdded: (newData) {
                            setState(() {
                              listPenjualan = newData;
                              listPenjualanBack = newData;
                            });
                          },
                        ),
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
                    itemCount: listPenjualan.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: midBlackBody),
                            bottom: BorderSide(width: 1.0, color: midBlackBody),
                          ),
                          color: myGrey,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: ListTile(
                                  tileColor: Colors.green,
                                  title: Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    height: 60,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${listPenjualan[index]['ID_NOTA']}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "${listPenjualan[index]['NAMA']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${fncGetTanggal(listPenjualan[index]['TGL'])}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: Text(
                                    myFormat.format(
                                        listPenjualan[index]['SUB_TOTAL']),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ModalPenjualanItem(
                                        cd: 'Detail',
                                        idPenjualan: listPenjualan[index]
                                            ['ID_NOTA'],
                                        subTotal: listPenjualan[index]
                                                ['SUB_TOTAL']
                                            .toString(),
                                        getPenjualan: () {},
                                        listBarang: const [],
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PenjualanItemPage(
                                            cd: 'Edit',
                                            idPenjualan: listPenjualan[index]
                                                ['ID_NOTA'],
                                            onDataAdded: (newData) {
                                              setState(() {
                                                listPenjualan = newData;
                                                listPenjualanBack = newData;
                                              });
                                            },
                                          ),
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
                                        builder: (context) =>
                                            ModalDeletePenjualan(
                                          onDataAdded: (newData) {
                                            setState(() {
                                              listPenjualan = newData;
                                              listPenjualanBack = newData;
                                            });
                                          },
                                          idPenjualan: listPenjualan[index]
                                              ['ID_NOTA'],
                                        ),
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
