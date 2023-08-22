import 'package:flutter/material.dart';
import 'package:penjualan_mobile/constants/public_const.dart';

class ModalSaveSuccess extends StatelessWidget {
  final String message;
  const ModalSaveSuccess({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        color: myGrey,
        padding: const EdgeInsets.all(10),
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box_rounded,
              color: myGreen,
              size: 100,
            ),
            const SizedBox(height: 20),
            FittedBox(
              child: Text(message,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white)),
            ),
            const SizedBox(height: 5),
            const FittedBox(
              child: Text('Silahkan kembali ke halaman',
                  style: TextStyle(fontSize: 10, color: Colors.white)),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'))
          ],
        ),
      ),
    );
  }
}
