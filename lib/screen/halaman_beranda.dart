import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starter/model/response_barang_model.dart';
import 'package:starter/service/api_service.dart';
import 'package:starter/widgets/item_barang.dart';

import 'halaman_tambah_edit.dart';

class HalamanBeranda extends StatelessWidget {
  static const String id = "HALAMANBERANDA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Inventory'),
      ),
      body: GridBarang(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HalamanTambahEdit(
                        barang: null,
                      )));
        },
      ),
    );
  }
}

class GridBarang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: ApiService.getListBarang(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  List<Barang> listBarang = snapshot.data;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: listBarang.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        splashColor: Colors.indigo,
                        borderRadius: BorderRadius.circular(10.0),
                        child: itemBarang(listBarang[index]),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HalamanTambahEdit(
                                      barang: listBarang[index])));
                        },
                      );
                    },
                  );
                }
              },
            )));
  }
}
