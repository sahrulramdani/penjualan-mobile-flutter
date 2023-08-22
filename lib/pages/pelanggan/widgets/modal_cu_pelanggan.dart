// ignore_for_file: missing_return, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:penjualan_mobile/component/modal_save_fail.dart';
import 'package:penjualan_mobile/component/modal_save_success.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:penjualan_mobile/models/http_pelanggan.dart';

typedef OnDataAddedCallback = void Function(List<Map<String, dynamic>> newData);

class ModalCuPelanggan extends StatefulWidget {
  final OnDataAddedCallback onDataAdded;
  final String cd;
  final String idPelanggan;
  const ModalCuPelanggan({
    Key key,
    this.onDataAdded,
    @required this.cd,
    @required this.idPelanggan,
  }) : super(key: key);

  @override
  State<ModalCuPelanggan> createState() => _ModalCuPelangganState();
}

class _ModalCuPelangganState extends State<ModalCuPelanggan> {
  final formKey = GlobalKey<FormState>();

  String idPelanggan = '';
  String namaPelanggan = '';
  String domisili = '';
  String jenisKelamin = 'Pilih Jenis Kelamin';

  getPelangganDetail() async {
    var response = await http
        .get(Uri.parse("$urlAddress/pelanggan/${widget.idPelanggan}"));
    List<Map<String, dynamic>> data = [json.decode(response.body)['data']];

    if (data.isNotEmpty) {
      setState(() {
        idPelanggan = widget.idPelanggan;
        namaPelanggan = data[0]['NAMA'];
        domisili = data[0]['DOMISILI'];
        jenisKelamin = data[0]['JENIS_KELAMIN'];
      });
    }
  }

  @override
  void initState() {
    if (widget.cd != 'Tambah') {
      getPelangganDetail();
    }
    super.initState();
  }

  Widget inputIdPelanggan() {
    final keyInput = GlobalKey<FormState>();

    return SizedBox(
      child: TextFormField(
        cursorColor: Colors.white,
        key: keyInput,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('ID Pelanggan'),
        initialValue: idPelanggan ?? '',
        onChanged: (value) {
          idPelanggan = value;
        },
        readOnly: true,
      ),
    );
  }

  Widget inputNamaPelanggan() {
    final keyInput = GlobalKey<FormState>();

    return SizedBox(
      child: TextFormField(
        cursorColor: Colors.white,
        key: keyInput,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('Nama Pelanggan'),
        initialValue: namaPelanggan ?? '',
        onChanged: (value) {
          namaPelanggan = value;
        },
        validator: (namaPelanggan) {
          if (namaPelanggan.isEmpty) {
            return "Nama Pelanggan masih kosong !";
          }
        },
        readOnly: widget.cd == 'Detail' ? true : false,
      ),
    );
  }

  Widget inputDomisili() {
    final keyInput = GlobalKey<FormState>();

    return SizedBox(
      child: TextFormField(
        cursorColor: Colors.white,
        key: keyInput,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('Domisili'),
        initialValue: domisili ?? '',
        onChanged: (value) {
          domisili = value;
        },
        validator: (domisili) {
          if (domisili.isEmpty) {
            return "Domisili masih kosong !";
          }
        },
        readOnly: widget.cd == 'Detail' ? true : false,
      ),
    );
  }

  Widget inputJenisKelamin() {
    return SizedBox(
      child: DropdownSearch(
        enabled: widget.cd == 'Detail' ? false : true,
        mode: Mode.BOTTOM_SHEET,
        showClearButton: true,
        items: const ["PRIA", "WANITA"],
        dropdownSearchDecoration: fncDropdownStyle('Jenis Kelamin'),
        onChanged: (value) {
          jenisKelamin = value;
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
            jenisKelamin ?? "Pilih Jenis Kelamin",
            style: const TextStyle(color: Colors.white)),
        validator: (value) {
          if (jenisKelamin == "Pilih Jenis Kelamin") {
            return "Kategori kosong !";
          }
        },
      ),
    );
  }

  void fncSave() {
    if (widget.cd == 'Tambah') {
      HttpPelanggan.savePelanggan(
        (namaPelanggan ?? '').toUpperCase(),
        (domisili ?? '').toUpperCase(),
        jenisKelamin ?? '',
      ).then((value) {
        if (value.status == 'true') {
          getPelanggan();
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
      HttpPelanggan.updatePelanggan(
        widget.idPelanggan,
        (namaPelanggan ?? '').toUpperCase(),
        (domisili ?? '').toUpperCase(),
        jenisKelamin ?? '',
      ).then((value) {
        if (value.status == 'true') {
          getPelanggan();
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

  void getPelanggan() async {
    var response = await http.get(Uri.parse("$urlAddress/pelanggan"));
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
                                  Expanded(child: inputIdPelanggan())
                                ]),
                                const SizedBox(height: 15),
                              ],
                            )
                          : const SizedBox(),
                      Row(children: [Expanded(child: inputNamaPelanggan())]),
                      const SizedBox(height: 15),
                      Row(children: [Expanded(child: inputDomisili())]),
                      const SizedBox(height: 15),
                      Row(children: [Expanded(child: inputJenisKelamin())]),
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
