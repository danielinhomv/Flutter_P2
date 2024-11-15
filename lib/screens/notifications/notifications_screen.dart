import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../controllers/notifications/notifications_controller.dart';
import '../../models/notification.dart';
import '../../utils/my_colors.dart';
import 'details_notification_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsController _con = NotificationsController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<NotificationModel>? notificationsRequest;

    final Future<List<NotificationModel>?> requests =
        Future<List<NotificationModel>?>.delayed(
      const Duration(seconds: 1),
      () {
        notificationsRequest = _con.notificationsRequest;
        return notificationsRequest;
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Comunicados'),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyColors.primaryColor,
        strokeWidth: 4.0,
        onRefresh: _con.updateNotifications,
        child: FutureBuilder<List<NotificationModel>?>(
          future: requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error al cargar los comunicados',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No hay comunicados disponibles.',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _cardNotificationRequest(
                            snapshot.data![index], index);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _cardNotificationRequest(NotificationModel? request, index) {
    return GestureDetector(
      onTap: () {
        // _con.openBottomSheet(order);
        _con.registrarVisita(request!.id);//aqui se registra la visita
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsNotificationScreen(
              titulo: request.titulo,
              mensaje: request.mensaje,
              bytePdfJson: request.bytePdfJson,
              fecha: request.fecha,
              tipo: request.tipo ,
              remitente: request.remitente ,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 130,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.1), // Color de la sombra con opacidad
              spreadRadius: 1, // Extensión de la sombra
              blurRadius: 5, // Radio de desenfoque de la sombra
              offset: const Offset(0, 3), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${request?.titulo}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                Text(
                  '${request?.mensaje}',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                Text(
                  '${request?.fecha}',
                  style: const TextStyle(fontSize: 13),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
