import 'package:flutter/material.dart';
import 'package:starter/model/response_barang_model.dart';
import 'package:starter/model/response_post_model.dart';
import 'package:starter/service/api_service.dart';
import 'package:toast/toast.dart';

import 'halaman_beranda.dart';

class HalamanTambahEdit extends StatefulWidget {
  static const String id = "HALAMANTAMBAHEDIT";
  final Barang barang;

  HalamanTambahEdit({this.barang});

  @override
  _HalamanTambahEditState createState() => _HalamanTambahEditState();
}

class _HalamanTambahEditState extends State<HalamanTambahEdit> {
  final _formKey = GlobalKey<FormState>();

  bool _isUpdate = false;

  String _idBarang;
  TextEditingController _nmBarang, _jmlBarang, _urlBarang;

  ApiService service = ApiService();
  bool _sukses;
  ResponsePost response;

  void cekValidasi() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_isUpdate);
      if (_isUpdate) {
        response = await service.updateBarang(
            _idBarang, _nmBarang.text, _jmlBarang.text, _urlBarang.text);
      } else {
        response = await service.postBarang(
            _nmBarang.text, _jmlBarang.text, _urlBarang.text);
      }

      _sukses = response.sukses;

      if (_sukses) {
        Navigator.pushNamedAndRemoveUntil(
            context, HalamanBeranda.id, (Route<dynamic> route) => false);
        setState(() {});
        Toast.show('Berhasil', context);
      } else {
        Toast.show('Gagal', context);
      }
    }
  }

  String validator(String value) {
    if (value.isEmpty)
      return "jangan kosong";
    else
      return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.barang != null) {
      _isUpdate = true;
      _idBarang = widget.barang.barangId;

      _nmBarang = TextEditingController(text: widget.barang.barangNama);
      _jmlBarang = TextEditingController(text: widget.barang.barangJumlah);
      _urlBarang = TextEditingController(text: widget.barang.barangGambar);
    } else {
      _nmBarang = TextEditingController();
      _jmlBarang = TextEditingController();
      _urlBarang = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isUpdate ? Text('Update Data') : Text('Tambah Data'),
        actions: <Widget>[
          _isUpdate
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    service.deleteBarang(_idBarang);
                    Navigator.pushNamedAndRemoveUntil(context,
                        HalamanBeranda.id, (Route<dynamic> route) => false);
                  },
                )
              : Text('')
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: _nmBarang,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Nama Barang'),
                    validator: validator,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: _jmlBarang,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jumlah Barang'),
                    validator: validator,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: _urlBarang,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Url Barang'),
                    validator: validator,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        primary: Theme.of(context).primaryColor),
                    child: Text(
                      'SIMPAN',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: cekValidasi,
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
