import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/lokasi_service.dart';

class LokasiProvider extends ChangeNotifier {
  Position? _posisi;
  String _kota = '';

  Position? get posisi => _posisi;
  String get kota => _kota;

  double get latitude => _posisi?.latitude ?? 0.0;
  double get longitude => _posisi?.longitude ?? 0.0;

  Future<void> updateLokasi() async {
    _posisi = await LokasiService.dapatkanLokasi();
    if (_posisi != null) {
      _kota = await LokasiService.dapatkanNamaKota(_posisi!);
    } else {
      _kota = '';
    }
    notifyListeners();
  }
}
