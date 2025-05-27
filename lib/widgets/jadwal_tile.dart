import 'package:flutter/material.dart';
import '../models/jadwal_shalat.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

String getLocalTimeZoneAbbreviation() {
  final location = tz.local;
  final now = tz.TZDateTime.now(location);
  return now.timeZoneName;
}

class JadwalTile extends StatelessWidget {
  final JadwalShalat jadwal;
  final String namaTampil;
  final VoidCallback onAlarmToggle;

  const JadwalTile({
    super.key,
    required this.jadwal,
    required this.namaTampil,
    required this.onAlarmToggle,
  });

  @override
  Widget build(BuildContext context) {
    final zonaWaktu = getLocalTimeZoneAbbreviation();

    return ListTile(
      leading: Image.asset(jadwal.icon, width: 36),
      title: Text(
        namaTampil,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
      ),
      subtitle: Text(
        '${DateFormat('HH:mm').format(DateTime.parse(jadwal.waktu))} $zonaWaktu',
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
      trailing: IconButton(
        icon: Image.asset(
          jadwal.alarmAktif
              ? 'assets/images/alarm_on.png'
              : 'assets/images/alarm_off.png',
          width: 28,
        ),
        onPressed: onAlarmToggle,
      ),
    );
  }
}
