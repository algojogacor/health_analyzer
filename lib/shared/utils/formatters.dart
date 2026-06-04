String fmtNumber(num? value, {int decimals = 0, String suffix = ''}) {
  if (value == null) return '--';
  final text =
      decimals == 0
          ? value.round().toString()
          : value.toStringAsFixed(decimals);
  return suffix.isEmpty ? text : '$text $suffix';
}

String fmtMinutes(double minutes) {
  final rounded = minutes.round();
  final hours = rounded ~/ 60;
  final mins = rounded % 60;
  if (hours > 0 && mins > 0) return '${hours}h ${mins}m';
  if (hours > 0) return '${hours}h';
  return '${mins}m';
}

String fmtTime(DateTime? value) {
  if (value == null) return '--';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(value.hour)}:${two(value.minute)}';
}

String fmtDuration(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;
  String two(int value) => value.toString().padLeft(2, '0');
  if (hours > 0) return '$hours:${two(minutes)}:${two(secs)}';
  return '$minutes:${two(secs)}';
}
