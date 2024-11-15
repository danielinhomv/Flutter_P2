// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter_application_1/services/ai_service.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_pdf_text/flutter_pdf_text.dart';

// class QuizGenerator {
//   final AiService _aiService = AiService();

//   Uint8List getPdfBytes(String bytesJson) {
//     List<int> byteList = List<int>.from(jsonDecode(bytesJson));
//     return Uint8List.fromList(byteList);
//   }

//   Future<List<String>> generateQuiz(String bytesJson) async {
//     // Solicitar permiso para almacenamiento
//     if (await _requestStoragePermission()) {
//       Uint8List pdfBytes = getPdfBytes(bytesJson);
//       // Extraer el texto del PDF
//       List<String> questions = await extractTextFromPdf(pdfBytes);
//       print("Texto extraído: $questions");
//       return questions;
//     } else {
//       throw Exception("Permiso de almacenamiento denegado");
//     }
//   }

//   // Solicitar permiso de almacenamiento
//   Future<bool> _requestStoragePermission() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       // Solicita el permiso si no ha sido otorgado
//       status = await Permission.storage.request();
//     }
//     return status.isGranted;
//   }

//   // Método para extraer texto usando flutter_pdf_text, página por página
//   Future<List<String>> extractTextFromPdf(Uint8List pdfBytes) async {
//     try {
//       // Guardar los bytes PDF en un archivo temporal
//       final tempDir = await getTemporaryDirectory();
//       final tempPath = '${tempDir.path}/temp.pdf';
//       final tempFile = File(tempPath);
//       await tempFile.writeAsBytes(pdfBytes);

//       // Abrir el documento PDF usando flutter_pdf_text
//       PDFDoc pdfDoc = await PDFDoc.fromPath(tempFile.path);
//       List<String> pageTexts = [];

//       // Iterar sobre cada página del documento y extraer el texto
//       for (int i = 1; i <= pdfDoc.length; i++) {
//         String text = await pdfDoc.pageAt(i).text;
//         pageTexts.add(text);
//       }

//       // Eliminar el archivo temporal después de su uso
//       await tempFile.delete();

//       return pageTexts;
//     } catch (e) {
//       print("Error al extraer texto: $e");
//       return [];
//     }
//   }

//   Future<String> evaluar(List<String> preguntas, List<String> respuestas) async {
//     double valorPorPregunta = 100 / preguntas.length;
//     String solicitudAChatGpt = "";

//     for (int indice = 0; indice < preguntas.length; indice++) {
//       if (respuestas[indice].isNotEmpty) {
//         solicitudAChatGpt += """
//         Pregunta: ${preguntas[indice]}
//         Respuesta: ${respuestas[indice]}
//       """;
//       }
//     }
//     if (solicitudAChatGpt.isEmpty) {
//       return "0";
//     }
//     String respuestaDeChatGpt =
//         await _aiService.evaluateResponses(solicitudAChatGpt, valorPorPregunta);
//     return respuestaDeChatGpt == "99" ? "100" : respuestaDeChatGpt;
//   }
// }
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_application_1/services/ai_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';

class QuizGenerator {
  final AiService _aiService = AiService();

  Uint8List getPdfBytes(String bytesJson) {
    List<int> byteList = List<int>.from(jsonDecode(bytesJson));
    return Uint8List.fromList(byteList);
  }

  Future<List<String>> generateQuiz(String bytesJson) async {
    // Solicitar permiso para almacenamiento
    //if (await _requestStoragePermission()) {
    Uint8List pdfBytes = getPdfBytes(bytesJson);
    // Extraer el texto del PDF
    List<String> paginasDeTexto = await extractTextFromPdf(pdfBytes);
    print("Texto extraído: $paginasDeTexto");
    List<String> preguntas = [];
    for (var textoDePagina in paginasDeTexto) {
      String cuestionario = await _aiService.generateQuestions(textoDePagina);
      preguntas.addAll(cuestionario.split('\n'));
    }
    return preguntas;
    //} else {
    // throw Exception("Permiso de almacenamiento denegado");
    //}
  }

  // Solicitar permiso de almacenamiento
  // Future<bool> _requestStoragePermission() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     // Solicita el permiso si no ha sido otorgado
  //     status = await Permission.storage.request();
  //   }
  //   return status.isGranted;
  // }

  // Método para extraer texto usando flutter_pdf_text, página por página
  Future<List<String>> extractTextFromPdf(Uint8List pdfBytes) async {
    try {
      // Guardar los bytes PDF en un archivo temporal
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/temp.pdf';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(pdfBytes);

      // Abrir el documento PDF usando flutter_pdf_text
      PDFDoc pdfDoc = await PDFDoc.fromPath(tempFile.path);
      List<String> pageTexts = [];

      // Iterar sobre cada página del documento y extraer el texto
      for (int i = 1; i <= pdfDoc.length; i++) {
        String text = await pdfDoc.pageAt(i).text;
        pageTexts.add(text);
      }

      // Eliminar el archivo temporal después de su uso
      await tempFile.delete();

      return pageTexts;
    } catch (e) {
      print("Error al extraer texto: $e");
      return [];
    }
  }

  Future<List<List<String>>> evaluar(
      List<String> preguntas, List<String> respuestas) async {
    int valorPorPregunta = 100 ~/ respuestas.length;
    int total = 0;
    String solicitudAChatGpt = "";
    int cantidadRespuestasCorrectas = 0;
    List<String> respuestasCorrectas = List.filled(preguntas.length, '');
    List<String> sonRespuestasCorrectas = List.filled(preguntas.length, '0');
    List<String> cantidadDeRespuestasCorrectasYcalificacionFinal = [];
    List<List<String>> revision = [];
    for (int indice = 0; indice < preguntas.length; indice++) {
      int nroPregunta = indice + 1;
      solicitudAChatGpt = """
        Pregunta $nroPregunta: ${preguntas[indice]}
        Respuesta: ${respuestas[indice]}
      """;
      String correccionDeChatGpt =
          await _aiService.evaluateResponses(solicitudAChatGpt);
      print("respuesta de chatGPT:$correccionDeChatGpt");
      if (correccionDeChatGpt.toLowerCase() == "correcta") {
        total = total + valorPorPregunta;
        cantidadRespuestasCorrectas++;
        sonRespuestasCorrectas[indice] = "1";
      }
      String respuestaCorrectaDeChatGpt =
          await _aiService.evaluateResponseYCorregir(
              "Pregunta $nroPregunta: ${preguntas[indice]}");
      respuestasCorrectas[indice] = respuestaCorrectaDeChatGpt;
    }
    String cantidadCorrectas = "$cantidadRespuestasCorrectas";
    cantidadDeRespuestasCorrectasYcalificacionFinal.add(cantidadCorrectas);
    String calificacion = "$total/100";
    cantidadDeRespuestasCorrectasYcalificacionFinal.add(calificacion);
    revision.add(preguntas);
    revision.add(respuestas);
    revision.add(respuestasCorrectas);
    revision.add(sonRespuestasCorrectas);
    revision.add(cantidadDeRespuestasCorrectasYcalificacionFinal);
    return revision;
  }
}
