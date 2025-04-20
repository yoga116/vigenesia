import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'MainScreens.dart';
import 'Register.dart';
import '/../Models/Login_Model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? nama;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<LoginModels?> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl = "https://6d89-125-165-152-250.ngrok-free.app/vigenesia";

    Map<String, dynamic> data = {"email": email, "password": password};

    try {
      final response = await dio.post("$baseurl/api/login/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);
        return loginModel;
      } else {
        print("Error: ${response.data}");
      }
    } catch (e) {
      print("Failed To Load: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.lightBlueAccent,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Security System - Login",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 50),
                Form(
                  key: _fbKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: "email",
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        obscureText: true,
                        name: "password",
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Don\'t Have Account? ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: 'Sign Up',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Register(),
                                    ),
                                  );
                                },
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await postLogin(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                nama = value.data?.nama;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MainScreens(nama: nama!),
                                  ),
                                );
                              });
                            } else {
                              Flushbar(
                                message: "Check Your Email / Password",
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.redAccent,
                                flushbarPosition: FlushbarPosition.TOP,
                              ).show(context);
                            }
                          });
                        },
                        icon: const Icon(Icons.login),
                        label: const Text("Sign In"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
