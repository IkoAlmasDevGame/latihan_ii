import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latihan_ii/api/UrlApi.dart';
import 'package:latihan_ii/ui/Daftar/FormCreate.dart';
import 'package:latihan_ii/ui/home.dart';
import 'package:http/http.dart' as http;

class LoginHome extends StatefulWidget {
  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  final formkey = GlobalKey<FormState>();
  bool _isHidePassword = true;

  void  VisibillityPassword(){
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  check(){
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
    }else{}
  }

  Future LoginAkses() async {
    var data = {"username": usernameController.text, "password": passwordController.text};
    String urlLogin = "${ApiDatabase.login}";
    final response = await http.post(Uri.parse(urlLogin),
    body: json.encode(data),
    );
    final message = jsonDecode(response.body);
    if (message == "Login Matched"){
      check();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => Home()));
    }else{
      debugPrint("Message : " +message.toString());
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=>LoginHome()));
    }
    debugPrint("Response : " +response.body);
    debugPrint("Status Code : "+(response.statusCode).toString());
    debugPrint("Headers : "+(response.headers).toString());
  }

  late String username, password;

  void NewAccountCreate(context) async {
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => FormCreate())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Home Page',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.fiber_new, size: 20, color: Colors.white,),
        onPressed: (){
          setState(() {
            NewAccountCreate(context);
          });
        },
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: usernameController,
                    onSaved: (e) => username = e!,
                    autofocus: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.account_box, size: 20,),
                      labelText: "UserName",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    validator: (value){
                      if (value!.isEmpty){
                        return "Tolong diisi Input Username ini";
                      }
                      return null;
                    },
                    autocorrect: false,
                    maxLength: 255,
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  TextFormField(
                    controller: passwordController,
                    onSaved: (e) => password = e!,
                    autofocus: true,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: (){
                          VisibillityPassword();
                        },
                        child: Icon(_isHidePassword ? Icons.visibility_off : Icons.visibility, color: _isHidePassword ? Colors.green : Colors.grey, size: 20,),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    validator: (value){
                      if (value!.isEmpty){
                        return "Tolong diisi Input Password ini";
                      }
                      return null;
                    },
                    autocorrect: false,
                    maxLength: 255,
                    obscureText: _isHidePassword,
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  RaisedButton(
                    child: Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, backgroundColor: Colors.white),
                    ),
                    onPressed: (){
                      LoginAkses();
                    },
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
