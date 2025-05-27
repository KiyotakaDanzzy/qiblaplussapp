import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pengaturan_provider.dart';
import '../utils/bahasa.dart';
import '../widgets/app_bar_qibla.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pengaturan = Provider.of<PengaturanProvider>(context);
    final teks = teksBahasa[pengaturan.bahasa]!;
    const textColor = Colors.black;

    return Scaffold(
      backgroundColor: const Color(0xFFD6E7F2),
      appBar: AppBarQibla(
        title: teks['qibla_app']!,
        showBack: true,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              label: teks['metode_perhitungan']!,
              value: pengaturan.metode,
              items: [
                DropdownMenuItem(value: '11', child: Text('Kemenag RI')),
                DropdownMenuItem(value: '2', child: Text('ISNA')),
                DropdownMenuItem(value: '3', child: Text('Egyptian')),
              ],
              onChanged: (val) => pengaturan.setMetode(val!),
              textColor: textColor,
            ),
            _buildSwitch(
              label: teks['mode_gelap']!,
              value: pengaturan.modeGelap,
              onChanged: (val) => pengaturan.setModeGelap(val),
              textColor: textColor,
            ),
            _buildDropdown(
              label: teks['bahasa']!,
              value: pengaturan.bahasa,
              items: [
                DropdownMenuItem(value: 'id', child: Text('Indonesia')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('عربي')),
              ],
              onChanged: (val) => pengaturan.setBahasa(val!),
              textColor: textColor,
            ),
            _buildDropdown(
              label: teks['suara_adzan']!,
              value: pengaturan.adzan,
              items: [
                DropdownMenuItem(value: 'mekah', child: Text('Mekah')),
                DropdownMenuItem(value: 'madinah', child: Text('Madinah')),
                DropdownMenuItem(value: 'indonesia', child: Text('Indonesia')),
              ],
              onChanged: (val) => pengaturan.setAdzan(val!),
              textColor: textColor,
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Text(
                    teks['hubungi_developer']!,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/instagram.png',
                            width: 38),
                        onPressed: () {
                          final url = Uri.parse('https://instagram.com/wyldnc');
                          launchUrlCustom(url);
                        },
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Image.asset('assets/images/whatsapp.png',
                            width: 38),
                        onPressed: () {
                          final url = Uri.parse('https://wa.me/6283815831741');
                          launchUrlCustom(url);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    Color textColor = Colors.black,
  }) {
    final coloredItems = items.map((item) {
      return DropdownMenuItem<String>(
        value: item.value,
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: Colors.white),
          child: item.child,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              value: value,
              items: coloredItems,
              isExpanded: true,
              onChanged: onChanged,
              style: const TextStyle(
                  color: Colors.white), 
              dropdownColor: Colors.black, 
              iconEnabledColor: Colors.white, 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color textColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Switch(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> launchUrlCustom(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Tidak bisa membuka $url';
  }
}
