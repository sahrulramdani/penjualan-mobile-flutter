// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:penjualan_mobile/pages/home.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  String email;
  String password;
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: myGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 20),
                Text('Selling Apps',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              width: screenWidth * 0.8,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Selamat Datang di Selling Apps',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  const SizedBox(height: 100),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 15,
                              color: Colors.white),
                          decoration: InputDecoration(
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
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(color: Colors.white),
                              isDense: true,
                              filled: true,
                              fillColor: midBlackBody,
                              suffixIcon: const Icon(Icons.email_outlined,
                                  color: Colors.white)),
                          initialValue: email ?? '',
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 15,
                              color: Colors.white),
                          obscureText: isHide,
                          decoration: InputDecoration(
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
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            hintStyle: const TextStyle(color: Colors.white),
                            isDense: true,
                            filled: true,
                            fillColor: midBlackBody,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isHide = !isHide;
                                });
                              },
                              child: Icon(
                                isHide
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: isHide ? Colors.grey : Colors.blue,
                              ),
                            ),
                          ),
                          initialValue: password ?? '',
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Homepage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
