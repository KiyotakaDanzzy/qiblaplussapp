import 'package:timezone/timezone.dart' as tz;

String getLocalTimeZoneAbbreviation() {
  final location = tz.local;
  final now = tz.TZDateTime.now(location);
  return now.timeZoneName;
}
