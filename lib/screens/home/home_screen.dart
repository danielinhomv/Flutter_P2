import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../controllers/home/home_controller.dart';
import '../../models/count_notifications_students.dart';
import '../../utils/my_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _con = HomeController();
  CountNotificationsStudents? item;
  // final String _url = 'http://${Environment.API_URL}';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    item = _con.countNotificationsStudentsRequest;

    // final Future<CountNotificationsStudents?> requests =
    //     Future<CountNotificationsStudents?>.delayed(
    //   const Duration(seconds: 1),
    //   () {
    //     item = _con.countNotificationsStudentsRequest;
    //     return item;
    //   },
    // );

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: _myDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Alinea al centro
          children: [
            // const SizedBox(height: 10),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    'Bienvenido/a',
                    style: TextStyle(
                      fontSize: 20,
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _con.user?.userName ?? 'Nombre del usuario',
                    style: TextStyle(
                      fontSize: 25,
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _card('Estudiantes', item?.hijos ?? 0, Icons.people),
            const SizedBox(height: 10),
            _card('Comunicados', item?.comunicados ?? 0, Icons.message),
          ],
        ),
      ),
    );
  }

  Widget _card(String label, int? value, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (label == 'Estudiantes') {
          _con.goToStudentsScreen();
        } else {
          _con.goToNotificationsScreen();
        }
        item = _con.countNotificationsStudentsRequest;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _myDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            accountName: Text(
              _con.user?.userName ?? 'Nombre del usuario',
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(_con.user?.userEmail ?? 'correo@example.com'),
            currentAccountPicture:
                // _con.customer?.photo != null
                //     ? ClipOval(
                //       child: FadeInImage(
                //           placeholder: const AssetImage('assets/img/user_profile.png'),
                //           image: NetworkImage('$_url${_con.customer!.photo!}'),
                //           fadeInDuration: const Duration(milliseconds: 200),
                //           fit: BoxFit.cover,
                //         ),
                //     )
                const CircleAvatar(
              backgroundImage: AssetImage('assets/img/user_profile.png'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: MyColors.primaryColor),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: MyColors.primaryColor,
                  ),
                  title: const Text('Inicio'),
                  onTap: () {
                    _con.goToHomeScreen();
                    item = _con.countNotificationsStudentsRequest;
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment_turned_in_rounded, color: MyColors.primaryColor),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: MyColors.primaryColor,
                  ),
                  title: const Text('Ver Calificaciones'),
                  onTap: () {
                    _con.goToStudentsScreen();
                    item = _con.countNotificationsStudentsRequest;
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment, color: MyColors.primaryColor),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: MyColors.primaryColor,
                  ),
                  title: const Text('Ver Boletines'),
                  onTap: () {
                    _con.goToNewsletterScreen();
                    item = _con.countNotificationsStudentsRequest;
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message, color: MyColors.primaryColor),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: MyColors.primaryColor,
                  ),
                  title: const Text('Ver Comunicados'),
                  onTap: () {
                    _con.goToNotificationsScreen();
                    item = _con.countNotificationsStudentsRequest;
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.edit, color: MyColors.primaryColor),
                //   trailing: Icon(
                //     Icons.keyboard_arrow_right,
                //     color: MyColors.primaryColor,
                //   ),
                //   title: const Text('Editar perfil'),
                //   onTap: () => {},
                // ),
                // ListTile(
                //   leading: Icon(Icons.lock, color: MyColors.primaryColor),
                //   trailing: Icon(
                //     Icons.keyboard_arrow_right,
                //     color: MyColors.primaryColor,
                //   ),
                //   title: context.select(
                //       (NotificationsBloc bloc) => Text('${bloc.state.status}')),
                //   onTap: () {
                //     Navigator.pop(context);
                //     context.read<NotificationsBloc>().requestPermission();
                //   },
                // ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: _con.logout,
                    child: const Text('Cerrar sesión'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
