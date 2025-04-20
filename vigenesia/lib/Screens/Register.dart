import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String baseurl = "https://6d89-125-165-152-250.ngrok-free.app/vigenesia";

  Future postRegister(
      String nama, String profesi, String email, String password) async {
    var dio = Dio();
    dynamic data = {
      "nama": nama,
      "profesi": profesi,
      "email": email,
      "password": password
    };

    try {
      final response = await dio.post("$baseurl/api/registrasi/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Register Your Account",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                FormBuilderTextField(
                  name: "name",
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Nama",
                  ),
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  name: "profesi",
                  controller: profesiController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.work, color: Colors.blueAccent),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Profesi",
                  ),
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  name: "email",
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Email",
                  ),
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  obscureText: true,
                  name: "password",
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Password",
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    icon: Icon(Icons.app_registration, color: Colors.white),
                    label: Text(
                      "Daftar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () async {
                      await postRegister(
                              nameController.text,
                              profesiController.text,
                              emailController.text,
                              passwordController.text)
                          .then((value) => {
                                if (value != null)
                                  {
                                    Navigator.pop(context),
                                    Flushbar(
                                      message: "Berhasil Registrasi",
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.greenAccent,
                                      flushbarPosition: FlushbarPosition.TOP,
                                    ).show(context)
                                  }
                                else
                                  {
                                    Flushbar(
                                      message:
                                          "Check Your Field Before Register",
                                      duration: Duration(seconds: 5),
                                      backgroundColor: Colors.redAccent,
                                      flushbarPosition: FlushbarPosition.TOP,
                                    ).show(context)
                                  }
                              });
                    },
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
