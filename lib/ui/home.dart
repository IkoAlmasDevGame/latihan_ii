import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latihan_ii/api/UrlApi.dart';
import 'package:latihan_ii/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_ii/ui/Daftar/Add.dart';
import 'package:latihan_ii/ui/Daftar/Edit.dart';
import 'package:latihan_ii/ui/SignIn/Login.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future <Mahasiswa> daftarMahasiswa;
  bool loading = false;

  Future<void> refreshMahasiswa() async {
    setState(() {
      daftarMahasiswa = dataMahasiswa() as Future<Mahasiswa>;
    });
  }

  _delete(String id) async {
    String deletedata = "${ApiDatabase.deleteData}";
    final response = await http.post(Uri.parse(deletedata),
        body: {
          "id": id,
        });
    final message = mahasiswaFromJson(response.body);
    if (message == "Data berhasil dihapus") {
      setState(() {
        refreshMahasiswa();
      });
    } else {
      print('Data tidak terhapus');
    }
    debugPrint("Response : " + response.body);
    debugPrint("Status Code : " + (response.statusCode).toString());
    debugPrint("Headers : " + (response.headers.toString()));
    return mahasiswaFromJson(response.body);
  }

  @override
  void initState() {
    super.initState();
    dataMahasiswa();
  }

  final list = [];
  Future<List<Mahasiswa>> dataMahasiswa() async {
    list.clear();
    setState(() {
      loading = true;
    });
    String lihatMahasiswa = "${ApiDatabase.getData}";
    final response = await http.get(Uri.parse(lihatMahasiswa));
    if(response.contentLength == 2){
      debugPrint('Status Code : ' + (response.statusCode).toString());
      debugPrint('Headers : ' + (response.headers).toString());
    }else{
      final data = mahasiswaFromJson(response.body);
      data.forEach((json) {
        final value = new Mahasiswa(
            id: '',
            nim_mh: json.nim_mh,
            nama: json.nama,
            mhFakultas: json.mhFakultas,
            mhProgstudi: json.mhProgstudi,
            alamat: json.alamat
        ).toJson();
        list.add(value);
      });
    }
    setState(() {
      loading = false;
    });
    return mahasiswaFromJson(response.body);
  }

  Widget _BuildContent(){
    return RefreshIndicator(
      onRefresh: () => refreshMahasiswa(),
      child: Container(
        padding: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border.all(width: 1.1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.blue
        ),
        child: FutureBuilder(
          future: dataMahasiswa(),
          builder: (context, AsyncSnapshot asyncSnapshot) {
            if (asyncSnapshot.hasData){
              return ListView.builder(
                itemCount: asyncSnapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index){
                  Mahasiswa mahasiswa = asyncSnapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.all(3.0),
                    elevation: 2.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Text("nim mahasiswa : ${mahasiswa.nim_mh}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text("nama lengkap : ${mahasiswa.nama}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text("fakultas : ${mahasiswa.mhFakultas}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text("program studi : ${mahasiswa.mhProgstudi}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text("Alamat : ${mahasiswa.alamat}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit, size: 20,),
                              onPressed: (){
                                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=>EditMahasiswa(mahasiswa: mahasiswa, refreshMahasiswa: refreshMahasiswa)));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, size: 20,),
                              onPressed: (){
                                _delete(mahasiswa.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(child:CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Mahasiswa",
            style: TextStyle(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 20),
            onPressed: (){
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (context) => AddMahasiswa()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: _BuildContent(),
      drawer: Drawer(
        child: ListView(
        children: <Widget>[
          ListTile(
            trailing: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: (){
              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=>LoginHome()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
