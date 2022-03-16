// To parse this JSON data, do
//
//     final mahasiswa = mahasiswaFromJson(jsonString);

import 'dart:convert';

List<Mahasiswa> mahasiswaFromJson(String str) => List<Mahasiswa>.from(json.decode(str).map((x) => Mahasiswa.fromJson(x)));

String mahasiswaToJson(List<Mahasiswa> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mahasiswa {
  Mahasiswa({
    required this.id,
    required this.nim_mh,
    required this.nama,
    required this.mhFakultas,
    required this.mhProgstudi,
    required this.alamat,
  });

  String id;
  String nim_mh;
  String nama;
  String mhFakultas;
  String mhProgstudi;
  String alamat;

  factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
    id: json["id"],
    nim_mh: json["nim_mh"],
    nama: json["nama"],
    mhFakultas: json["mh_fakultas"],
    mhProgstudi: json["mh_progstudi"],
    alamat: json["alamat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nim_mh": nim_mh,
    "nama": nama,
    "mh_fakultas": mhFakultas,
    "mh_progstudi": mhProgstudi,
    "alamat": alamat,
  };
}
