import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/quiz_generator.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatelessWidget {
  final String pdfBytesJson;

  PdfView({required this.pdfBytesJson});

  @override
  Widget build(BuildContext context) {
    QuizGenerator quizGenerator = new QuizGenerator();
        print("pdfBytes:$pdfBytesJson");

    Uint8List pdfBytes = quizGenerator.getPdfBytes(pdfBytesJson);
    print("pdfBytes:$pdfBytes");
    // 4. Mostrar el PDF usando el paquete `flutter_pdfview`
    return Scaffold(
      appBar: AppBar(
        title: Text("Vista del PDF"),
      ),
      body: Center(
        child: PDFView(
          pdfData: pdfBytes,
          onPageError: (page, error) {
            print('Error en la página $page: $error');
          },
          onRender: (pages) {
            print('PDF renderizado con $pages páginas');
          },
        ),
      ),
    );
  }
}
