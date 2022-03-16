import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_ii/model/model.dart';
import 'package:latihan_ii/api/UrlApi.dart';

class EditMahasiswa extends StatefulWidget {
    Mahasiswa mahasiswa;
    VoidCallback refreshMahasiswa;

    EditMahasiswa({required this.mahasiswa, required this.refreshMahasiswa});

  @override
  State<EditMahasiswa> createState() => _EditMahasiswaState();
}

class _EditMahasiswaState extends State<EditMahasiswa> {
  final formKey = GlobalKey<FormState>();

  check(){
    final form = formKey.currentState;
    if (form!.validate()){
      form.save();
      submit();
    }else{}
  }

  late TextEditingController nim_mahasiswa;
  late TextEditingController nama;
  late TextEditingController mahasiswa_fakultas;
  late TextEditingController mahasiswa_progstudi;
  late TextEditingController alamat;

  setUp(){
    nim_mahasiswa = TextEditingController(text: widget.mahasiswa.nim_mh);
    nama = TextEditingController(text: widget.mahasiswa.nama);
    mahasiswa_fakultas = TextEditingController(text: widget.mahasiswa.mhFakultas);
    mahasiswa_progstudi = TextEditingController(text: widget.mahasiswa.mhProgstudi);
    alamat = TextEditingController(text: widget.mahasiswa.alamat);
  }

  Future submit() async {
    String editdata = "${ApiDatabase.editData}";
    final response = await http.post(Uri.parse(editdata),
    body: {
      "nim_mh":nim_mahasiswa.text,
      "nama": nama.text,
      "mh_fakultas": mahasiswa_fakultas.text,
      "mh_progstudi": mahasiswa_progstudi.text,
      "alamat": alamat.text,
    });
    final message = json.encode(response.body);
    debugPrint("Pesan : " + message.toString());
    debugPrint("Response : " + response.body);
    debugPrint("Status Code : " + response.statusCode.toString());
    debugPrint("Headers : " + response.headers.length.toString());
    mahasiswaFromJson(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUp();
  }

  Widget  _listAddMahasiswa() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nama,
                    autocorrect: false,
                    onSaved: (e) => nama = e! as TextEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Nama Lengkap",
                    ),
                    maxLength: 255,
                    enabled: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (e) => nim_mahasiswa = e! as TextEditingController,
                    controller: nim_mahasiswa,
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if (value!.length < 8){
                        return "Tidak boleh kurang dari 8 digit";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Buat Account Nim",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: mahasiswa_fakultas,
                    keyboardType: TextInputType.text,
                    onSaved: (e) => mahasiswa_fakultas = e! as TextEditingController,
                    decoration: InputDecoration(
                      label: Text("Falkutas Mu di UBSI"),
                    ),
                    maxLength: 255,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: mahasiswa_progstudi,
                    autocorrect: false,
                    onSaved: (e) => mahasiswa_progstudi = e! as TextEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Jurusan Anda",
                    ),
                    maxLength: 255,
                    enabled: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: alamat,
                    autocorrect: false,
                    onSaved: (e) => alamat = e! as TextEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Alamat Rumah",
                    ),
                    maxLength: 255,
                    enabled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('',
        style: TextStyle(),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: Text('SIMPAN DATA'),
          onPressed: (){
            submit();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _listAddMahasiswa(),
    );
  }
}
