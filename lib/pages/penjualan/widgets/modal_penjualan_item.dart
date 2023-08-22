// ignore_for_file: missing_return, sort_child_properties_last, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penjualan_mobile/component/modal_save_fail.dart';
import 'package:penjualan_mobile/component/modal_save_success.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:penjualan_mobile/models/http_pelanggan.dart';
import 'package:penjualan_mobile/models/http_penjualan.dart';

class ModalPenjualanItem extends StatefulWidget {
  String cd;
  String idPenjualan;
  String subTotal;
  final Function getPenjualan;
  List<Map<String, dynamic>> listBarang = [];

  ModalPenjualanItem({
    Key key,
    @required this.cd,
    @required this.idPenjualan,
    @required this.subTotal,
    @required this.getPenjualan,
    @required this.listBarang,
  }) : super(key: key);

  @override
  State<ModalPenjualanItem> createState() => _ModalPenjualanItemState();
}

class _ModalPenjualanItemState extends State<ModalPenjualanItem> {
  final formKey = GlobalKey<FormState>();

  String idPelanggan;
  String namaPelanggan = 'Pilih Pelanggan';
  TextEditingController tanggalBeli = TextEditingController();

  List<Map<String, dynamic>> listPelanggan = [];

  getPelanggan() async {
    var response = await http.get(Uri.parse("$urlAddress/pelanggan"));
    List<Map<String, dynamic>> data =
        List.from(json.decode(response.body)['data'] as List);

    setState(() {
      listPelanggan = data;
    });
  }

  getDetail() async {
    var response = await http
        .get(Uri.parse("$urlAddress/penjualan/${widget.idPenjualan}"));
    List<Map<String, dynamic>> data = [json.decode(response.body)['data']];

    if (data.isNotEmpty) {
      if (widget.cd == 'Detail') {
        List<Map<String, dynamic>> listBarangDetail = [];
        var item = data[0]['item_penjualan'];

        for (var items in item) {
          var add = {
            "CEK": false,
            "KODE": items['KODE_BARANG'],
            "NAMA": items['NAMA_BRG'],
            "KATEGORI": items['KATEGORI'],
            "HARGA": items['HARGA'],
            "QTY": items['QTY'],
            "SUBTOTAL":
                int.parse(items['SUBTOTAL'].toString().replaceAll(',', '')),
          };

          listBarangDetail.add(add);
        }
        widget.listBarang = listBarangDetail;
      }

      setState(() {
        idPelanggan = data[0]['KODE_PELANGGAN'];
        namaPelanggan = data[0]['NAMA'];
        tanggalBeli.text = fncTanggalLocalFormat(data[0]['TGL']);
      });
    }
  }

  @override
  void initState() {
    getPelanggan();
    if (widget.cd != 'Tambah') {
      getDetail();
    }
    super.initState();
  }

  Widget inputIdPenjualan() {
    final keyInput = GlobalKey<FormState>();
    return SizedBox(
      child: TextFormField(
        cursorColor: Colors.white,
        key: keyInput,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('ID Penjualan'),
        initialValue: widget.idPenjualan ?? '',
        onChanged: (value) {
          widget.idPenjualan = value;
        },
        readOnly: true,
      ),
    );
  }

  Widget inputNamaPelanggan() {
    return SizedBox(
      child: DropdownSearch(
        enabled: widget.cd == 'Detail' ? false : true,
        mode: Mode.BOTTOM_SHEET,
        showClearButton: true,
        items: listPelanggan,
        dropdownSearchDecoration: fncDropdownStyle('Nama Pelanggan'),
        onChanged: (value) {
          setState(() {
            idPelanggan = value['ID_PELANGGAN'];
            namaPelanggan = value['NAMA'];
          });
        },
        popupItemBuilder: (context, item, isSelected) => ListTile(
          title:
              Text(item['NAMA'], style: const TextStyle(color: Colors.white)),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Colors.grey),
        ),
        popupBackgroundColor: myGrey,
        dropdownSearchBaseStyle: const TextStyle(color: Colors.white),
        dropdownBuilder: (context, selectedItem) => Text(
            namaPelanggan ?? "Pilih Pelanggan",
            style: const TextStyle(color: Colors.white)),
        validator: (value) {
          if (namaPelanggan == "Pilih Pelanggan") {
            return "Kategori kosong !";
          }
        },
      ),
    );
  }

  Widget inputTanggalBeli() {
    return SizedBox(
      child: TextFormField(
        readOnly: widget.cd == 'Detail' ? false : true,
        controller: tanggalBeli,
        cursorColor: Colors.white,
        style: const TextStyle(
            fontFamily: 'Gilroy', fontSize: 15, color: Colors.white),
        decoration: fncInputStyle('Tanggal Transaksi'),
        onTap: () async {
          DateTime pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  primaryColor: myGrey,
                  colorScheme: const ColorScheme.dark(primary: Colors.blue),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.normal),
                ),
                child: child,
              );
            },
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
            tanggalBeli.text = formattedDate;
          }
        },
        validator: (tanggalBeli) {
          if (tanggalBeli.isEmpty) {
            return "Tanggal masih kosong !";
          }
        },
        // readOnly: widget.cd == 'Detail' ? true : false,
      ),
    );
  }

  void fncSave() {
    if (widget.cd == 'Tambah') {
      HttpPenjualan.savePenjualan(
        idPelanggan ?? '',
        fncTanggal(tanggalBeli.text ?? '00-01-1111'),
        widget.subTotal ?? '0',
        widget.listBarang,
      ).then((value) {
        if (value.status == 'true') {
          widget.getPenjualan();
          Navigator.pop(context);
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
      HttpPenjualan.updatePenjualan(
        widget.idPenjualan ?? '',
        idPelanggan ?? '',
        fncTanggal(tanggalBeli.text ?? '00-01-1111'),
        widget.subTotal ?? '0',
        widget.listBarang,
      ).then((value) {
        if (value.status == 'true') {
          widget.getPenjualan();
          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: myGrey,
        ),
        width: screenWidth * 0.95,
        height: screenHeight * 0.85,
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
                      const FittedBox(
                        child: Text(
                          'Barang Item Pelanggan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(children: [Expanded(child: inputNamaPelanggan())]),
                      const SizedBox(height: 15),
                      Row(children: [Expanded(child: inputTanggalBeli())]),
                      const SizedBox(height: 15),
                      Expanded(
                        child: SizedBox(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.listBarang.length,
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
                                              widget.listBarang[index]['NAMA'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${widget.listBarang[index]['QTY']} Item - ${widget.listBarang[index]['KATEGORI']}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            trailing: Text(
                                              myFormat.format(
                                                  widget.listBarang[index]
                                                      ['SUBTOTAL']),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
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
