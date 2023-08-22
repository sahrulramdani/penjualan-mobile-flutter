import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

MaterialColor myBlack = const MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);

Color myGrey = Colors.grey[900];
Color borderGrey = const Color.fromARGB(255, 116, 116, 116);
Color midBlackBody = const Color.fromARGB(50, 255, 255, 255);
Color modalBlackBg = const Color.fromARGB(255, 67, 67, 67);
Color myGreen = const Color.fromARGB(255, 0, 187, 6);
Color myRed = const Color.fromARGB(255, 255, 20, 3);

const urlAddress = 'http://127.0.0.1:8000/api';

NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

fncLabelWhite(label) {
  return Text(
    label,
    style: const TextStyle(
      fontFamily: 'Gilroy',
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}

fncButtonStyle(color) {
  return ElevatedButton.styleFrom(
    backgroundColor: color,
    minimumSize: const Size(60, 40),
    shadowColor: Colors.grey,
    elevation: 5,
  );
}

fncButtonThinStyle(color) {
  return ElevatedButton.styleFrom(
    backgroundColor: color,
    minimumSize: const Size(40, 40),
    shadowColor: Colors.grey,
    elevation: 5,
  );
}

fncInputStyle(label) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: borderGrey,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: borderGrey,
        width: 2.0,
      ),
    ),
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white),
    hintStyle: const TextStyle(color: Colors.white),
    isDense: true,
    filled: true,
    fillColor: midBlackBody,
  );
}

fncDropdownStyle(label) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: borderGrey,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: borderGrey,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: borderGrey,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: borderGrey,
        width: 2.0,
      ),
    ),
    labelText: label,
    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    labelStyle: const TextStyle(color: Colors.white),
    hintStyle: const TextStyle(color: Colors.white),
    isDense: true,
    filled: true,
    fillColor: midBlackBody,
    suffixIconColor: Colors.white,
    prefixIconColor: Colors.white,
  );
}

fncGetTanggal(tgl) {
  String tanggalAll = tgl.replaceAll('-', '');
  String tahun = tanggalAll.substring(0, 4);
  String bulan = tanggalAll.substring(4, 6);
  String tanggal = tanggalAll.substring(6, 8);
  String namaBulan;

  if (bulan == '01') {
    namaBulan = 'Januari';
  } else if (bulan == '02') {
    namaBulan = 'Februari';
  } else if (bulan == '03') {
    namaBulan = 'Maret';
  } else if (bulan == '04') {
    namaBulan = 'April';
  } else if (bulan == '05') {
    namaBulan = 'Mei';
  } else if (bulan == '06') {
    namaBulan = 'Juni';
  } else if (bulan == '07') {
    namaBulan = 'Juli';
  } else if (bulan == '08') {
    namaBulan = 'Agustus';
  } else if (bulan == '09') {
    namaBulan = 'September';
  } else if (bulan == '10') {
    namaBulan = 'Oktober';
  } else if (bulan == '11') {
    namaBulan = 'November';
  } else if (bulan == '12') {
    namaBulan = 'Desember';
  }

  return '$tanggal $namaBulan $tahun';
}

fncTanggal(String tgl) {
  String tanggalAll = tgl.replaceAll('-', '');
  String tanggal = tanggalAll.substring(0, 2);
  String bulan = tanggalAll.substring(2, 4);
  String tahun = tanggalAll.substring(4, 8);
  String date = "$tahun-$bulan-$tanggal";

  return date;
}

fncTanggalLocalFormat(String tgl) {
  String tanggalAll = tgl.replaceAll('-', '');
  String tahun = tanggalAll.substring(0, 4);
  String bulan = tanggalAll.substring(4, 6);
  String tanggal = tanggalAll.substring(6, 8);
  String date = "$tanggal-$bulan-$tahun";

  return date;
}
