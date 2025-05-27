import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/splash_screen.dart';
import 'views/beranda_screen.dart';
import 'views/kompas_screen.dart';
import 'views/setting_screen.dart';
import 'providers/lokasi_provider.dart';
import 'providers/jadwal_provider.dart';
import 'providers/pengaturan_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/notifikasi_service.dart';
import 'package:timezone/data/latest.dart' as tzdata;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('ar', null);
  tzdata.initializeTimeZones();
  await NotifikasiService.init();
  runApp(const QiblaPlusApp());
}

class QiblaPlusApp extends StatelessWidget {
  const QiblaPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LokasiProvider()),
        ChangeNotifierProvider(create: (_) => JadwalProvider()),
        ChangeNotifierProvider(create: (_) => PengaturanProvider()),
      ],
      child: MaterialApp(
        title: 'Qibla+ App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (ctx) => const SplashScreen(),
          '/beranda': (ctx) => const BerandaScreen(),
          '/kompas': (ctx) => const KompasScreen(),
          '/setting': (ctx) => const SettingScreen(),
        },
        theme: ThemeData(
          fontFamily: 'Amiri',
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
