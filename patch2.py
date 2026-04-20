import os

file_path = r'e:\Flutter_Projects\smartattend\lib\Student_Dashboard\Scan_Qr_Screen.dart'

new_code = """import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartattend/Student_Dashboard/student_main_navigation.dart';
import '../app_size/app_size.dart';
import '../utils/UiHelper.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isScanning = false;
  String? _scannedData;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
      _scannedData = null;
    });
    try {
      _scannerController.start();
    } catch (e) {
      debugPrint('Error starting scanner: $e');
    }
  }

  void _stopScanning() {
    setState(() {
      _isScanning = false;
    });
    try {
      _scannerController.stop();
    } catch (e) {
      debugPrint('Error stopping scanner: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = 0, h = 0;
    try {
      w = AppSize.width(context) > 0 ? AppSize.width(context) : MediaQuery.of(context).size.width;
      h = AppSize.height(context) > 0 ? AppSize.height(context) : MediaQuery.of(context).size.height;
    } catch (_) {
      w = MediaQuery.of(context).size.width;
      h = MediaQuery.of(context).size.height;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan Qr Code',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0047AB),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            children: [
              SizedBox(height: h * 0.05),
              Text(
                "Scan QR Code",
                style: TextStyle(
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: h * 0.08),
              Container(
                height: h * 0.35,
                width: h * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF0047AB), width: 3),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: _isScanning
                      ? MobileScanner(
                          controller: _scannerController,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            if (barcodes.isNotEmpty) {
                              final barcode = barcodes.first;
                              if (barcode.rawValue != null) {
                                _stopScanning();
                                setState(() {
                                  _scannedData = barcode.rawValue;
                                });
                                UIHelper.showSnackBar(
                                  context, 
                                  "QR Scanned Successfully: ${_scannedData}",
                                );
                              }
                            }
                          },
                        )
                      : Center(
                          child: _scannedData != null
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.green, size: 60),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Data: $_scannedData",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )
                              : const Icon(Icons.qr_code_scanner, size: 80, color: Colors.black54),
                        ),
                ),
              ),
              const Spacer(),
              UIHelper.customButton(
                text: _isScanning ? "Stop Scanning" : "Start Scanning",
                onPressed: _isScanning ? _stopScanning : _startScanning,
              ),
              SizedBox(height: h * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
"""

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_code)
print("File rewritten successfully!")
