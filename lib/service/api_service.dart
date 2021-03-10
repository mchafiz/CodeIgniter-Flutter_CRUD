import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:starter/model/response_barang_model.dart';
import 'package:starter/model/response_post_model.dart';

class ApiService {
  static var _url =
      Uri.parse('http://192.168.1.9:8118/server_inventory/index.php/api');

  static Future<List<Barang>> getListBarang() async {
    List<Barang> listbarang = [];

    final response = await http.get("$_url/getBarang");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      ResponseBarang responseBarang = ResponseBarang.fromJson(json);
      responseBarang.barang.forEach((element) {
        listbarang.add(element);
      });
      return listbarang;
    } else {
      return [];
    }
  }

  Future<ResponsePost> postBarang(
      String nama, String jumlah, String urlgambar) async {
    final response = await http.post('$_url/insertbarang',
        body: {'nama': nama, 'jumlah': jumlah, 'gambar': urlgambar});

    if (response.statusCode == 200) {
      final jsonn = jsonDecode(response.body);
      ResponsePost post = ResponsePost.fromJson(jsonn);
      return post;
    } else {
      return ResponsePost(lastId: 0, pesan: 'gagal brohh', sukses: false);
    }
  }

  updateBarang(id, nama, jumlah, gambar) async {
    final response = await http.post('$_url/updatebarang',
        body: {'id': id, 'nama': nama, 'jumlah': jumlah, 'gambar': gambar});
    if (response.statusCode == 200) {
      var jsonn = jsonDecode(response.body);
      ResponsePost responsePost = ResponsePost.fromJson(jsonn);
      return responsePost;
    } else {
      return ResponsePost(lastId: 0, pesan: 'error', sukses: false);
    }
  }

  deleteBarang(String id) async {
    final response = await http.post('$_url/deletebarang', body: {'id': id});
    if (response.statusCode == 200) {
      var jsonn = jsonDecode(response.body);
      ResponsePost responsePost = ResponsePost.fromJson(jsonn);
      return responsePost;
    } else {
      return null;
    }
  }
}
