// ignore_for_file: missing_return, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:penjualan_mobile/component/modal_save_fail.dart';
import 'package:penjualan_mobile/component/modal_save_success.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:penjualan_mobile/models/http_barang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef OnDataAddedCallback = void Function(List<Map<String, dynamic>> newData);

class ModalCuBarang extends StatefulWidget {
  final OnDataAddedCallback onDataAdded;
  final String cd;
  final String kodeBarang;
  const ModalCuBarang({
    Key key,
    this.onDataAdded,
    @required this.cd,
    @required this.kodeBarang,
  }) : super(key: key);

  @override
  State<ModalCuBarang> createState() => _ModalCuBarangState();
}

class _ModalCuBarangState extends State<ModalCuBarang> {
  final formKey = GlobalKey<FormState>();

  String kodeBarang = '';
  String namaBarang = '';
  String kategori = 'Pilih Kategori';
  String harga = '';

  getBarangDetail() async {
    var response =
        await http.get(Uri.parse("$urlAddress/barang/${widget.kodeBarang}"));
    List<Map<String, dynamic>> data = [json.decode(response.body)['data']];

    if (data.isNotEmpty) {
      setState(() {
        kodeBarang = widget.kodeBarang;
        namaBarang = data[0]['NAMA'];
        kategori = data[0]['KATEGORI'];
        harga = myFormat.format(data[0]['HARGA'] ?? 0);
      });
    }
  }

  @override
  void initState() {
    if (widget.cd != 'Tambah') {
      getBarangDetail();
    }
    super.initState();
  }

  Widget inputKodeBarang() {
    final keyInput = GlobalKey<FormState>();

    return SizedBox(
      child: TextFormField(
        cursorColor: Colors.white,
        key: keyInput,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('Kode Barang'),
        initialValue: kodeBarang ?? '',
        onChanged: (value) {
          kodeBarang = value;
        },
        readOnly: true,
      ),
    );
  }

  Widget inputNamaBarang() {
    final keyInput = GlobalKey<FormState>();

    return SizedBox(
      child: TextFormField(
        cursorColor: Colors.white,
        key: keyInput,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('Nama Barang'),
        initialValue: namaBarang ?? '',
        onChanged: (value) {
          namaBarang = value;
        },
        validator: (namaBarang) {
          if (namaBarang.isEmpty) {
            return "Nama Barang masih kosong !";
          }
        },
        readOnly: widget.cd == 'Detail' ? true : false,
      ),
    );
  }

  Widget inputKategoriBarang() {
    return SizedBox(
      child: DropdownSearch(
        enabled: widget.cd == 'Detail' ? false : true,
        mode: Mode.BOTTOM_SHEET,
        showClearButton: true,
        items: const ["ATK", "MASAK", "RT", "ELEKTRONIK", "PERKAKAS"],
        dropdownSearchDecoration: fncDropdownStyle('Kategori'),
        onChanged: (value) {
          kategori = value;
        },
        popupItemBuilder: (context, item, isSelected) => ListTile(
          title: Text(item, style: const TextStyle(color: Colors.white)),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Colors.grey),
        ),
        popupBackgroundColor: myGrey,
        dropdownSearchBaseStyle: const TextStyle(color: Colors.white),
        dropdownBuilder: (context, selectedItem) => Text(
            kategori ?? "Pilih Kategori",
            style: const TextStyle(color: Colors.white)),
        validator: (value) {
          if (kategori == "Pilih Kategori") {
            return "Kategori kosong !";
          }
        },
      ),
    );
  }

  Widget inputHargaBarang() {
    final keyInput = GlobalKey<FormState>();

    return SizedBox(
      child: TextFormField(
        textAlign: TextAlign.right,
        inputFormatters: [ThousandsFormatter()],
        keyboardType: TextInputType.number,
        cursorColor: Colors.white,
        key: keyInput,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('Harga Barang'),
        initialValue: harga ?? '',
        onChanged: (value) {
          harga = value;
        },
        validator: (harga) {
          if (harga.isEmpty) {
            return "Harga Barang masih kosong !";
          }
        },
        readOnly: widget.cd == 'Detail' ? true : false,
      ),
    );
  }

  void fncSave() {
    if (widget.cd == 'Tambah') {
      HttpBarang.saveBarang(
        (namaBarang ?? '').toUpperCase(),
        kategori ?? '',
        (harga ?? '0').replaceAll(',', ''),
      ).then((value) {
        if (value.status == 'true') {
          getBarang();
          Navigator.pop(context);
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
      });
    } else {
      HttpBarang.updateBarang(
        widget.kodeBarang,
        (namaBarang ?? '').toUpperCase(),
        kategori ?? '',
        (harga ?? '0').replaceAll(',', ''),
      ).then((value) {
        if (value.status == 'true') {
          getBarang();
          Navigator.pop(context);
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
      });
    }
  }

  void getBarang() async {
    var response = await http.get(Uri.parse("$urlAddress/barang"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    widget.onDataAdded(data);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: myGrey,
        ),
        width: screenWidth * 0.9,
        height: 500,
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          '${widget.cd} Barang',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      widget.cd != 'Tambah'
                          ? Column(
                              children: [
                                Row(children: [
                                  Expanded(child: inputKodeBarang())
                                ]),
                                const SizedBox(height: 15),
                              ],
                            )
                          : const SizedBox(),
                      Row(children: [Expanded(child: inputNamaBarang())]),
                      const SizedBox(height: 15),
                      Row(children: [Expanded(child: inputKategoriBarang())]),
                      const SizedBox(height: 15),
                      Row(children: [Expanded(child: inputHargaBarang())]),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.cd != 'Detail'
                        ? ElevatedButton.icon(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                fncSave();
                              } else {
                                return;
                              }
                            },
                            icon: const Icon(Icons.save),
                            label: fncLabelWhite('Simpan'),
                            style: fncButtonStyle(myGreen),
                          )
                        : Container(),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: fncLabelWhite('Kembali'),
                      style: fncButtonStyle(Colors.blue),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
