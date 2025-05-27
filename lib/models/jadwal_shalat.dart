class JadwalShalat {
  final String nama;
  final String waktu;
  final String icon;
  final bool alarmAktif;

  JadwalShalat({
    required this.nama,
    required this.waktu,
    required this.icon,
    required this.alarmAktif,
  });

  JadwalShalat copyWith({
    String? nama,
    String? waktu,
    String? icon,
    bool? alarmAktif,
  }) {
    return JadwalShalat(
      nama: nama ?? this.nama,
      waktu: waktu ?? this.waktu,
      icon: icon ?? this.icon,
      alarmAktif: alarmAktif ?? this.alarmAktif,
    );
  }
}
