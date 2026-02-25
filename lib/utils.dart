bool isAbove15(DateTime dob) {
  final now = DateTime.now();

  int age = now.year - dob.year;

  if (now.month < dob.month ||
      (now.month == dob.month && now.day < dob.day)) {
    age--;
  }

  return age >= 15;
}
