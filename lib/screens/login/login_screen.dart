import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/login/login_controller.dart';
import '../../utils/my_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _con = LoginController();

  @override
  void initState() {
    super.initState();

    // Se ejecuta despues del metodo build
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity, // Ocupar todo el ancho
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -80,
                left: -90,
                child: _circleLogin(),
              ),
              Positioned(
                top: 65,
                left: 35,
                child: _textLogin(),
              ),
              Column(
                children: [
                  _studentJson(),
                  _textFieldEmail(),
                  _textFieldPassword(),
                  _buttonLogin(),
                  const SizedBox(height: 30)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.usernameController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          prefixIcon: Icon(
            Icons.email,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          prefixIcon: Icon(
            Icons.lock,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          _con.login();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text('INGRESAR'),
      ),
    );
  }

  Widget _studentJson() {
    return Container(
      margin: EdgeInsets.only(
        top: 190,
        bottom: MediaQuery.of(context).size.height * 0,
      ),
      child: Lottie.asset(
        'assets/json/student.json',
        width: 320,
        height: 320,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _circleLogin() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _textLogin() {
    return const Text(
      'LOGIN',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }
}
