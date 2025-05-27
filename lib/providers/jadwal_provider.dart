import 'package:flutter/material.dart';
import '../models/jadwal_shalat.dart';
import '../services/jadwal_service.dart';
import '../services/notifikasi_service.dart';
import 'package:provider/provider.dart';
import 'pengaturan_provider.dart';

class JadwalProvider extends ChangeNotifier {
  List<JadwalShalat> _jadwal = [];
  String _metode = '11';
  String _bahasa = 'en';
  final DateTime _tanggal = DateTime.now();

  List<JadwalShalat> get jadwal => _jadwal;
  String get metode => _metode;
  String get bahasa => _bahasa;
  DateTime get tanggal => _tanggal;

  void setMetode(String metode) {
    _metode = metode;
    notifyListeners();
  }

  void setBahasa(String bahasa) {
    _bahasa = bahasa;
    notifyListeners();
  }

  Future<void> fetchJadwal(double lat, double lng) async {
    final data = await JadwalService.fetchJadwal(lat, lng, _metode, _bahasa);
    if (data != null) {
      final timings = data['data']['timings'];
      final tanggalHariIni = DateTime.now();

      DateTime parseWaktuSholat(String waktuStr) {
        if (RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}$').hasMatch(waktuStr)) {
          waktuStr = '$waktuStr:00:00';
        }
        try {
          final waktu = DateTime.parse(waktuStr);
          return waktu.toLocal();
        } catch (_) {
          final parts = waktuStr.split(':');
          int jam = 0;
          int menit = 0;
          if (parts.length >= 2) {
            jam = int.tryParse(parts[0]) ?? 0;
            menit = int.tryParse(parts[1]) ?? 0;
          } else if (parts.length == 1) {
            jam = int.tryParse(parts[0]) ?? 0;
          }
          return DateTime(tanggalHariIni.year, tanggalHariIni.month, tanggalHariIni.day, jam, menit);
        }
      }

      _jadwal = [
        JadwalShalat(
            nama: 'subuh',
            waktu: parseWaktuSholat(timings['Fajr']).toIso8601String(),
            icon: 'assets/images/subuh.png',
            alarmAktif: false),
        JadwalShalat(
            nama: 'dzuhur',
            waktu: parseWaktuSholat(timings['Dhuhr']).toIso8601String(),
            icon: 'assets/images/dzuhur.png',
            alarmAktif: false),
        JadwalShalat(
            nama: 'ashar',
            waktu: parseWaktuSholat(timings['Asr']).toIso8601String(),
            icon: 'assets/images/ashar.png',
            alarmAktif: false),
        JadwalShalat(
            nama: 'maghrib',
            waktu: parseWaktuSholat(timings['Maghrib']).toIso8601String(),
            icon: 'assets/images/maghrib.png',
            alarmAktif: false),
        JadwalShalat(
            nama: 'isya',
            waktu: parseWaktuSholat(timings['Isha']).toIso8601String(),
            icon: 'assets/images/isya.png',
            alarmAktif: false),
      ];
    }
    notifyListeners();
  }

  Future<void> toggleAlarm(BuildContext context, int index) async {
    final pengaturan = Provider.of<PengaturanProvider>(context, listen: false);
    final String soundName = pengaturan.adzan;

    final jadwalShalat = _jadwal[index];
    final newStatus = !jadwalShalat.alarmAktif;

    _jadwal[index] = jadwalShalat.copyWith(alarmAktif: newStatus);
    notifyListeners();

    final waktu = DateTime.parse(jadwalShalat.waktu).toLocal();
    final now = DateTime.now();
    final waktuShalat = DateTime(
      now.year,
      now.month,
      now.day,
      waktu.hour,
      waktu.minute,
    );

    final int id = index;

    if (newStatus) {
      await NotifikasiService.jadwalkanAdzan(
          id, waktuShalat, jadwalShalat.nama, soundName);
    } else {
      await NotifikasiService.batalkanAdzan(id);
    }
  }
}
