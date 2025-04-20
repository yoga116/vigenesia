import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';

class EditPage extends StatefulWidget {
  final String? id;
  final String? isi_motivasi;
  const EditPage({Key? key, this.id, this.isi_motivasi}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl = "https://6d89-125-165-152-250.ngrok-free.app/vigenesia";

  var dio = Dio();
  TextEditingController isiMotivasiC = TextEditingController();

  Future<dynamic> putPost(String isi_motivasi, String ids) async {
    Map<String, dynamic> data = {"isi_motivasi": isi_motivasi, "id": ids};
    var response = await dio.put('$baseurl/aci/api/dev/PUTmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    print("---> ${response.data} + ${response.statusCode}");
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Motivasi"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.isi_motivasi}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  name: "isi_motivasi",
                  controller: isiMotivasiC,
                  decoration: InputDecoration(
                    labelText: "New Data",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    prefixIcon: Icon(Icons.edit),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    putPost(isiMotivasiC.text, widget.id.toString())
                        .then((value) {
                      if (value != null) {
                        Navigator.pop(context);
                        Flushbar(
                          message: "Berhasil Update & Refresh dlu",
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.green,
                          flushbarPosition: FlushbarPosition.TOP,
                        ).show(context);
                      }
                    });
                  },
                  icon: Icon(Icons.save),
                  label: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 50),
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
