import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_ii/api/UrlApi.dart';
import 'package:latihan_ii/model/model.dart';
import 'package:latihan_ii/ui/home.dart';

class AddMahasiswa extends StatefulWidget {
  @override
  State<AddMahasiswa> createState() => _AddMahasiswaState();
}

class _AddMahasiswaState extends State<AddMahasiswa> {
  final formKey = GlobalKey<FormState>();
  late final TextSelectionControls? selectionControls;

  check(){
    final form = formKey.currentState;
    if (form!.validate()){
      form.save();
      form.activate();
    }else{
      form.deactivate();
      form.reset();
    }
  }

  final TextEditingController nimMahasiswaController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController fakultasController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  late String nim_mh, nama_mh, fakultas_mh, jurusan_mh, alamat;

   Future  DaftarMahasiswa() async {
     String Pendaftaran = "${ApiDatabase.addData}";
     final response = await http.post(Uri.parse(Pendaftaran), body: {
       "nim_mh" : nimMahasiswaController.text ,
       "nama" : namaController.text,
       "mh_fakultas" : fakultasController.text,
       "mh_progstudi" : jurusanController.text,
       "alamat" : alamatController.text
     });
     check();
     var res = json.encode(response.body);
     Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => Home()));
     debugPrint("Response : " + response.body);
     debugPrint("Status Code : " + response.statusCode.toString());
     debugPrint("Headers : " + response.headers.toString());
     return mahasiswaFromJson(res.toString());
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
                     controller: namaController,
                     autocorrect: false,
                     onSaved: (e) => nama_mh = e!,
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
                     onSaved: (e) => nim_mh = e!,
                     controller: nimMahasiswaController,
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
                     controller: fakultasController,
                     keyboardType: TextInputType.text,
                     onSaved: (e) => fakultas_mh = e!,
                     decoration: InputDecoration(
                       label: Text("Falkutas Mu di UBSI"),
                     ),
                     maxLength: 255,
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.all(8.0),
                   child: TextFormField(
                     controller: jurusanController,
                     autocorrect: false,
                     onSaved: (e) => jurusan_mh = e!,
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
                     controller: alamatController,
                     autocorrect: false,
                     onSaved: (e) => alamat = e!,
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
        title: Text("Tambah Mahasiswa Baru"),
        centerTitle: true,
      ),
      body: _listAddMahasiswa(),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: Text("SIMPAN DATA"),
          onPressed: (){
            DaftarMahasiswa();
          },
        ),
      ),
    );
  }
}
