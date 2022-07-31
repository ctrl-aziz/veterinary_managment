import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrReaderPage extends StatefulWidget {
  final Function(String?) onResult;
  const QrReaderPage({Key? key, required this.onResult}) : super(key: key);

  @override
  State<QrReaderPage> createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: IconButton(
                onPressed: (){
                  if(controller != null){
                    controller!.toggleFlash();
                  }else{
                    if (kDebugMode) {
                      print("flash error");
                    }
                  }
                },
                icon: const Icon(Icons.flashlight_on),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        Navigator.of(context).pop();
        widget.onResult(scanData.code);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
