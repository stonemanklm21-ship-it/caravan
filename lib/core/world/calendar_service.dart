import '../models/calendar_constants.dart';

class CalendarService {
  static double yearsFromHours(
    double hours,
  ) {
    return hours /
        CalendarConstants.hoursPerYear;
  }

  static int wholeYears(
    double ageYears,
  ) {
    return ageYears.floor();
  }

  static int dayOfYear(
    double ageYears,
  ) {
    final fractionalYear =
        ageYears - ageYears.floor();

    return (fractionalYear *
            CalendarConstants.daysPerYear)
        .floor();
  }

  static String formatAge(
    double ageYears,
  ) {
    return '${wholeYears(ageYears)}Y '
        '${dayOfYear(ageYears)}D';
  }
}