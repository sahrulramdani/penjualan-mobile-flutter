import 'package:flutter/material.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:penjualan_mobile/pages/barang/barang_page.dart';
import 'package:penjualan_mobile/pages/pelanggan/pelanggan_page.dart';
import 'package:penjualan_mobile/pages/penjualan/penjualan_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool enableBarang = true;
  bool enablePelanggan = false;
  bool enablePenjualan = false;
  bool enablePenjualanItem = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myGrey,
      appBar: AppBar(
        title: const Text('Selling Apps'),
        leading: Container(
          padding: const EdgeInsets.all(12),
          child: const Image(
            image: AssetImage('assets/images/logo.png'),
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
                    Visibility(
                      visible: enableBarang ?? true,
                      child: const BarangPage(),
                    ),
                    Visibility(
                      visible: enablePelanggan ?? true,
                      child: const PelangganPage(),
                    ),
                    Visibility(
                      visible: enablePenjualan ?? true,
                      child: const PenjualanPage(),
                    ),
                    Visibility(
                      visible: enablePenjualanItem ?? true,
                      child: const PenjualanPage(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25.0)),
                color: myBlack,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GNav(
                  backgroundColor: myBlack,
                  color: const Color.fromARGB(255, 215, 215, 215),
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.grey[800],
                  gap: 6,
                  padding: const EdgeInsets.all(16),
                  tabs: [
                    GButton(
                      icon: Icons.storage_rounded,
                      text: 'Barang',
                      onPressed: () {
                        setState(() {
                          enableBarang = true;
                          enablePelanggan = false;
                          enablePenjualan = false;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.people_outline_rounded,
                      text: 'Pelanggan',
                      onPressed: () {
                        setState(() {
                          enableBarang = false;
                          enablePelanggan = true;
                          enablePenjualan = false;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.shopify_rounded,
                      text: 'Penjualan',
                      onPressed: () {
                        setState(() {
                          enableBarang = false;
                          enablePelanggan = false;
                          enablePenjualan = true;
                        });
                      },
                    ),
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
