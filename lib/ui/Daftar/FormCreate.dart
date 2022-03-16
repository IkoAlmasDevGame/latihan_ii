import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_ii/api/UrlApi.dart';
import 'package:latihan_ii/ui/SignIn/Login.dart';

class FormCreate extends StatefulWidget {
  @override
  State<FormCreate> createState() => _FormCreateState();
}

class _FormCreateState extends State<FormCreate> {
  final formKey = GlobalKey<FormState>();
  bool _isHidePassword = true;
  bool _isHideRepassword = true;

  void VisibillityPassword(){
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void VisibillityRepassword(){
    setState(() {
      _isHideRepassword = !_isHideRepassword;
    });
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  Future data() async {
    String register = "${ApiDatabase.register}";
    final response = await http.post(Uri.parse(register),
    body: {
      "username": usernameController.text,
      "password": passwordController.text,
      "repassword": repasswordController.text
    });
      var message = json.encode(response.body);
      debugPrint("Response : " + response.body);
      debugPrint("Status Code : " + (response.statusCode).toString());
      debugPrint("Headers : " + (response.headers.toString()));
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=>LoginHome()));
    return message.toString();
  }

  late String username, password, repassword;

  AddCreateForm(){
    return Container(
      child: Center(
        child: Form(
          key: formKey,
          child: Column(
          children: <Widget>[
            TextFormField(
              autocorrect: false,
              autofocus: true,
              controller: usernameController,
              onSaved: (e) => username = e!,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.account_box, size: 20,),
                labelText: "Username",
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              validator: (value){
                if (value!.length < 3){
                  return "Tolong diisi box username";
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              onSaved: (e) => password = e!,
              obscureText: _isHidePassword,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: (){
                    VisibillityPassword();
                  },
                  child: Icon(_isHidePassword ? Icons.visibility_off : Icons.visibility, color: _isHidePassword ? Colors.green : Colors.grey, size: 20,),
                ),
                labelText: "Password",
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                isDense: true,
              ),
              autocorrect: false,
              maxLength: 255,
              validator: (value){
                if (value!.length < 8) {
                  return "Tolong diisi box password";
                }
                return null;
              },
            ),
            TextFormField(
              controller: repasswordController,
              onSaved: (e) => repassword = e!,
              obscureText: _isHideRepassword,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: (){
                    VisibillityRepassword();
                  },
                  child: Icon(_isHideRepassword ? Icons.visibility_off : Icons.visibility, color: _isHideRepassword ? Colors.green : Colors.grey, size: 20,),
                ),
                labelText: "Repassword",
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                isDense: true,
              ),
              autocorrect: false,
              maxLength: 255,
              validator: (value){
                if (value!.length < 8) {
                  return "Tolong diisi box repassword";
                }
                return null;
              },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String judul = "Create Account";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: AddCreateForm(),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          child: Text("SIMPAN",
            style: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: (){
            data();
          },
        ),
      ),
    );
  }
}
