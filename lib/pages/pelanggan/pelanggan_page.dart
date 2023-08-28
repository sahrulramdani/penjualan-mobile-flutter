import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:penjualan_mobile/pages/pelanggan/widgets/modal_cu_pelanggan.dart';
import 'package:penjualan_mobile/pages/pelanggan/widgets/modal_delete_pelanggan.dart';

class PelangganPage extends StatefulWidget {
  const PelangganPage({Key key}) : super(key: key);

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  List<Map<String, dynamic>> listPelanggan = [];
  List<Map<String, dynamic>> listPelangganBack = [];

  getPelanggan() async {
    var response = await http.get(Uri.parse("$urlAddress/pelanggan"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    setState(() {
      listPelanggan = data;
      listPelangganBack = data;
    });
  }

  @override
  void initState() {
    getPelanggan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int x = 1;

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
                    'Halaman Pelanggan',
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
                  hintText: 'Cari Nama Pelanggan',
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
                      listPelanggan = listPelangganBack;
                    });
                  } else {
                    setState(() {
                      listPelanggan = listPelangganBack
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
                      builder: (context) => ModalCuPelanggan(
                        onDataAdded: (newData) {
                          setState(() {
                            listPelanggan = newData;
                            listPelangganBack = newData;
                          });
                        },
                        cd: 'Tambah',
                        idPelanggan: '',
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
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 3 / 6,
                  ),
                  children: listPelanggan.map((e) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth,
                            height: 165,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://picsum.photos/id/${x++}/200/300"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e['ID_PELANGGAN'] ?? '',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 10),
                                  FittedBox(
                                    child: Text(
                                      e['NAMA'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(e['JENIS_KELAMIN'] ?? '',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      const Expanded(child: SizedBox()),
                                      Expanded(
                                        child: SizedBox(
                                          child: FittedBox(
                                            child: Text(
                                              e['DOMISILI'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Expanded(
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ModalCuPelanggan(
                                                  onDataAdded: (newData) {
                                                    setState(() {
                                                      listPelanggan = newData;
                                                      listPelangganBack =
                                                          newData;
                                                    });
                                                  },
                                                  cd: 'Detail',
                                                  idPelanggan:
                                                      e['ID_PELANGGAN'],
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.remove_red_eye,
                                              color: Color.fromARGB(
                                                  255, 255, 230, 0),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ModalCuPelanggan(
                                                  onDataAdded: (newData) {
                                                    setState(() {
                                                      listPelanggan = newData;
                                                      listPelangganBack =
                                                          newData;
                                                    });
                                                  },
                                                  cd: 'Edit',
                                                  idPelanggan:
                                                      e['ID_PELANGGAN'],
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  255, 6, 143, 255),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ModalDeletePelanggan(
                                                        onDataAdded: (newData) {
                                                          setState(() {
                                                            listPelanggan =
                                                                newData;
                                                            listPelangganBack =
                                                                newData;
                                                          });
                                                        },
                                                        idPelanggan:
                                                            e['ID_PELANGGAN']),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
