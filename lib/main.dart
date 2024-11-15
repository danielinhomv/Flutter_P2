import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/students/students_screen.dart';
import 'services/bloc/notifications_bloc.dart';
import 'utils/my_colors.dart';
import  'utils/shared_pref.dart';
import 'config/local_notifications/local_notifications.dart';
import 'screens/newsletter/newsletter_screen.dart';
import 'screens/notifications/details_notification_screen.dart';
import 'screens/qualifications/qualifications_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationsBloc.initializeFCM();
  await LocalNotifications.initializeLocalNotifications(navigatorKey);

  bool isLoggedIn = await SharedPref().contains('user');
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => NotificationsBloc(
          requestLocalNotificationPermissions:
              LocalNotifications.requestPermissionLocalNotifications,
          showLocalNotification: LocalNotifications.showLocalNotification,
        ),
      ),
    ],
    child: MyApp(isLoggedIn: isLoggedIn),
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: 'NimbusSans'
        primarySwatch: MyColors.primarySwatch,
      ),
      title: 'Student App Flutter',
      initialRoute: isLoggedIn ? 'home' : 'login',
      navigatorKey: navigatorKey,
      routes: {
        'login': (BuildContext context) => const LoginScreen(),
        'home': (BuildContext context) => const HomeScreen(),
        // 'home/students': (BuildContext context) => const StudentsListScreen(),
        'home/notifications': (BuildContext context) =>
            const NotificationsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'home/students') {
          final args = settings.arguments as Map<String, dynamic>;
          final isNewsletter = args['isNewsletter'];

          return MaterialPageRoute(
            builder: (context) {
              return StudentsListScreen(isNewsletter: isNewsletter);
            },
          );
        }
        if (settings.name == 'home/notification/details') {
          final args = settings.arguments as Map<String, dynamic>;
          final pushMessageId = args['pushMessageId'];

          return MaterialPageRoute(
            builder: (context) {
              return DetailsNotificationScreen(pushMessageId: pushMessageId);
            },
          );
        }
        if (settings.name == 'home/students/qualifications') {
          final args = settings.arguments as Map<String, dynamic>;
          final student = args['student'];

          return MaterialPageRoute(
            builder: (context) {
              return QualificationScreen(student: student);
            },
          );
        }
        if (settings.name == 'home/students/newsletters') {
          final args = settings.arguments as Map<String, dynamic>;
          final student = args['student'];

          return MaterialPageRoute(
            builder: (context) {
              return NewsletterScreen(student: student);
            },
          );
        }
        return null;
      },
      builder: (context, child) =>
          HandleNotificationInteractions(child: child!),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    final messageId =
        message.messageId?.replaceAll(':', '').replaceAll('%', '');

    if (messageId != null) {
      // navigatorKey.currentState?.pushNamed(
      //   'home/notification/details',
      //   arguments: {
      //     'pushMessageId': messageId,
      //   },
      // );

      print('Message data: ${message.data}');

      final fecha = message.data['fecha'];
      final titulo = message.data['titulo'];
      final mensaje = message.data['mensaje'];
      final tipo = message.data['tipo'];
      final remitente = message.data['remitente'];

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => DetailsNotificationScreen(
            titulo: titulo ?? '',
            mensaje: mensaje ?? '',
            fecha: fecha ?? '',
            tipo: tipo ?? '',
            remitente: remitente ?? '',
          ),
        ),
      );
    }

    // Navigate to the chat screen
    // Navigator.of(context).pushNamed('home/details', arguments: {
    //   'pushMessageId': messageId,
    // });

    // Navigator.pushNamed(context, 'home/details', arguments: {
    //   'pushMessageId': messageId,
    // });
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
