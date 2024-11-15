import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/pdfView.dart';
import 'package:flutter_application_1/screens/quiz_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/my_colors.dart';
import '../../models/push_message.dart';
import '../../services/bloc/notifications_bloc.dart';

class DetailsNotificationScreen extends StatelessWidget {
  final String? pushMessageId;
  final String? titulo;
  final String? mensaje;
  final String? bytePdfJson;
  final String? fecha;
  final String? tipo;
  final String? remitente;

  const DetailsNotificationScreen({
    super.key,
    this.titulo,
    this.mensaje,
    this.bytePdfJson,
    this.fecha,
    this.pushMessageId,
    this.tipo,
    this.remitente,
  });

  @override
  Widget build(BuildContext context) {
    final PushMessage? message =
        context.watch<NotificationsBloc>().getMessageById(pushMessageId ?? '');

    final tipoNotification =
        (message != null) ? message.data!['tipo'] : tipo ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Comunicado '),
            Text(
              '($tipoNotification)',
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (message != null) ? message.title : titulo ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Remitente: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryColor,
                  ),
                ),
                Text(
                  (message != null)
                      ? message.data!['remitente']
                      : remitente ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 1.3),
            const SizedBox(height: 10),
            Text(
              (message != null) ? message.body : mensaje ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: Text(
                (message != null) ? message.data!['fecha'] : fecha ?? '',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(height: 20),
            // Conditional buttons
            if (bytePdfJson != null && bytePdfJson!.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PdfView(pdfBytesJson: bytePdfJson ?? ''),
                    ),
                  );
                },
                child: const Text('Ver PDF'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizScreen(pdfBytesJson: bytePdfJson ?? ''),
                    ),
                  );
                },
                child: const Text('Retroalimentación'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
