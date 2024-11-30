import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:html' as html;

class QRCodeGeneratorPage extends StatelessWidget {
  final String docID;

  const QRCodeGeneratorPage({Key? key, required this.docID}) : super(key: key);

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    // Create the QR code image as a widget
    final qrCodeImage = QrPainter(
      data: docID,
      version: QrVersions.auto,
      gapless: true,
    );

    // Generate QR code as a ByteData image
    final ByteData? imageData = await qrCodeImage.toImageData(200);
    final Uint8List pngBytes = imageData!.buffer.asUint8List();

    // Add title and QR code image to the PDF
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'MANGGATECH', 
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20), 
              pw.Image(
                pw.MemoryImage(pngBytes),
                width: 200,
                height: 200,
              ),
            ],
          ),
        );
      },
    ));

    return pdf.save(); 
  }

  void _downloadPdf(BuildContext context) async {
    try {
      final pdfData = await _generatePdf();
      final blob = html.Blob([pdfData], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'QRCode.pdf')
        ..click();

      html.Url.revokeObjectUrl(url); // Clean up the URL
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'MANGGATECT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              QrImageView(
                data: docID,
                version: 5,
                size: 320,
                gapless: false,
                errorStateBuilder: (context, error) {
                  return Container(
                    child: const Center(
                      child: Text(
                        'Uh oh! Something went wrong...',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _downloadPdf(context),
                child: const Text("Download QR Code as PDF"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
