class DateUtils {
  static String getFotmattedDate(DateTime dateTime) {
    if (dateTime != null) {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
    return "";
  }

  static DateTime getDateTimeFromString(String dateString,
      {String separator = "/"}) {
    if (dateString?.isNotEmpty ?? false) {
      List<int> dateParts = dateString
          .split(separator)
          .map(
            (it) => int.parse(it),
          )
          .toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }
    return null;
  }

  static String getFormattedDateInWords(DateTime dateTime) {
    if (dateTime == null) {
      return "";
    }
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
  }

  static String _getMonthName(int month, {bool short = true}) {
    switch (month) {
      case 1:
        if (short) {
          return "Jan";
        }
        return "January";
      case 2:
        if (short) {
          return "Feb";
        }
        return "February";
      case 3:
        if (short) {
          return "Mar";
        }
        return "March";
      case 4:
        if (short) {
          return "Apr";
        }
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        if (short) {
          return "Aug";
        }
        return "August";
      case 9:
        if (short) {
          return "Sep";
        }
        return "September";
      case 10:
        if (short) {
          return "Oct";
        }
        return "October";
      case 11:
        if (short) {
          return "Nov";
        }
        return "November";
      case 12:
        if (short) {
          return "Dec";
        }
        return "December";
      default:
        return null;
    }
  }
}
