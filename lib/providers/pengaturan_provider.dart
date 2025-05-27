import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanProvider extends ChangeNotifier {
  bool _modeGelap = false;
  String _metode = '11'; 
  String _bahasa = 'id';
  String _adzan = 'mekah';

  bool get modeGelap => _modeGelap;
  String get metode => _metode;
  String get bahasa => _bahasa;
  String get adzan => _adzan;

  PengaturanProvider() {
    _load();
  }

  void _load() async {
    final pref = await SharedPreferences.getInstance();
    _modeGelap = pref.getBool('modeGelap') ?? false;
    _metode = pref.getString('metode') ?? '11';
    _bahasa = pref.getString('bahasa') ?? 'id';
    _adzan = pref.getString('adzan') ?? 'mekah';
    notifyListeners();
  }

  void setModeGelap(bool value) async {
    _modeGelap = value;
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('modeGelap', value);
    notifyListeners();
  }

  void setMetode(String value) async {
    _metode = value;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('metode', value);
    notifyListeners();
  }

  void setBahasa(String value) async {
    _bahasa = value;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('bahasa', value);
    notifyListeners();
  }

  void setAdzan(String value) async {
    _adzan = value;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('adzan', value);
    notifyListeners();
  }
}
