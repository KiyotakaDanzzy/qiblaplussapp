import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lokasi_provider.dart';
import '../providers/jadwal_provider.dart';
import '../providers/pengaturan_provider.dart';
import '../widgets/app_bar_qibla.dart';
import '../widgets/jadwal_tile.dart';
import '../widgets/bottom_nav.dart';
import '../utils/warna.dart';
import '../utils/bahasa.dart';
import '../utils/helper.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

String getLocalTimeZoneAbbreviation() {
  final location = tz.local;
  final now = tz.TZDateTime.now(location);
  return now.timeZoneName;
}

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  @override
  void initState() {
    super.initState();
    final lokasi = Provider.of<LokasiProvider>(context, listen: false);
    final jadwal = Provider.of<JadwalProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await lokasi.updateLokasi();
      if (lokasi.posisi != null) {
        await jadwal.fetchJadwal(
            lokasi.posisi!.latitude, lokasi.posisi!.longitude);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lokasi = Provider.of<LokasiProvider>(context);
    final jadwal = Provider.of<JadwalProvider>(context);
    final pengaturan = Provider.of<PengaturanProvider>(context);

    final locale = pengaturan.bahasa;
    final teks = teksBahasa[locale]!;

    String waktuShalatUtama = '--:--';
    String namaShalatUtama = teks['dzuhur']!;
    String iconUtama = 'assets/images/dzuhur.png';

    if (jadwal.jadwal.isNotEmpty) {
      final now = DateTime.now();
      for (final j in jadwal.jadwal) {
        final waktu = DateTime.parse(j.waktu);
        if (now.isBefore(waktu)) {
          waktuShalatUtama = DateFormat('HH:mm').format(waktu);
          namaShalatUtama = teks[j.nama] ?? j.nama;
          iconUtama = j.icon;
          break;
        }
      }
    }

    final zonaWaktu = getLocalTimeZoneAbbreviation();

    return Scaffold(
      backgroundColor: Warna.hijauTua,
      appBar: AppBarQibla(
        title: teks['qibla_app']!,
        onSetting: () => Navigator.of(context).pushNamed('/setting'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                Image.asset('assets/images/location_pin.png', width: 22),
                const SizedBox(width: 8),
                Text(
                  lokasi.kota.isNotEmpty ? lokasi.kota : '--',
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaShalatUtama,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$waktuShalatUtama $zonaWaktu',
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Image.asset(iconUtama, width: 85),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Warna.putih,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      formatTanggal(DateTime.now(), locale),
                      style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Warna.hitam),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jadwal.jadwal.length,
                      itemBuilder: (ctx, i) {
                        final j = jadwal.jadwal[i];
                        return JadwalTile(
                          jadwal: j,
                          namaTampil: teks[j.nama] ?? j.nama,
                          onAlarmToggle: () {
                            jadwal.toggleAlarm(context, i);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavQibla(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) {
            Navigator.of(context).pushReplacementNamed('/kompas');
          }
        },
      ),
    );
  }
}
