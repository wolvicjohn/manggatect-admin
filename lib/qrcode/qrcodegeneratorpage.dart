import 'dart:typed_data';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class PdfDownloader {
  static Future<void> downloadQrCodeAsPdf(BuildContext context, String docID) async {
    try {
      final pdf = pw.Document();

      final qrCodeImage = QrPainter(
        data: docID,
        version: QrVersions.auto,
        gapless: true,
      );

      final ByteData? imageData = await qrCodeImage.toImageData(200);
      final Uint8List pngBytes = imageData!.buffer.asUint8List();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('MANGGATECH', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text(docID, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Image(pw.MemoryImage(pngBytes), width: 200, height: 200),
              ],
            ),
          );
        },
      ));

      final pdfData = await pdf.save();
      final blob = html.Blob([pdfData], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'QRCode.pdf')
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }
}
