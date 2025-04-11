// Format date from dd-mm-yyyy to yyyy-mm-dd
DateTime parseFormattedDate(String dateStr) {
  List<String> parts = dateStr.split('-');
  return DateTime(
    int.parse(parts[2]),
    int.parse(parts[1]),
    int.parse(parts[0]),
  );
}
