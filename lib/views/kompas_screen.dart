import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:provider/provider.dart';
import '../providers/lokasi_provider.dart';
import '../providers/pengaturan_provider.dart';
import '../widgets/app_bar_qibla.dart';
import '../widgets/bottom_nav.dart';
import '../utils/warna.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' show pi;

class KompasScreen extends StatelessWidget {
  const KompasScreen({super.key});

  String formatArahKiblat(double derajat, String bahasa) {
    String arahUtara;
    switch (bahasa) {
      case 'id':
        arahUtara = 'dari Utara';
        break;
      case 'ar':
        arahUtara = 'من الشمال';
        break;
      case 'en':
      default:
        arahUtara = 'from North';
    }
    final deg = ((derajat % 360) + 360) % 360;
    return 'Kiblat ${deg.toStringAsFixed(2)}° $arahUtara';
  }

  double normalizeAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;
    return angle;
  }

  @override
  Widget build(BuildContext context) {
    final lokasi = Provider.of<LokasiProvider>(context);
    final pengaturan = Provider.of<PengaturanProvider>(context);
    final bahasa = pengaturan.bahasa;

    return Scaffold(
      backgroundColor: Warna.hijauTua,
      appBar: AppBarQibla(
        title: 'Qibla+ App',
        onSetting: () => Navigator.of(context).pushNamed('/setting'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<QiblahDirection>(
              stream: FlutterQiblah.qiblahStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final direction = snapshot.data!;
                final compassAngle = normalizeAngle(direction.direction);
                final qiblaAngle = normalizeAngle(direction.qiblah);

                final compassRotation = -compassAngle * (pi / 180);
                final needleRotation = -qiblaAngle * (pi / 180);

                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: compassRotation,
                        child: SvgPicture.asset(
                          'assets/images/compass.svg',
                          width: 300,
                          height: 300,
                        ),
                      ),
                      Transform.rotate(
                        angle: needleRotation,
                        child: SvgPicture.asset(
                          'assets/images/needle.svg',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                StreamBuilder<QiblahDirection>(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final derajat = snapshot.data!.qiblah;
                    return Text(
                      formatArahKiblat(derajat, bahasa),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavQibla(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.of(context).pushReplacementNamed('/beranda');
        },
      ),
    );
  }
}
