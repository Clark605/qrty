/// Generates iCal format for events following RFC 5545
class ICalGenerator {
  /// Generate iCal format for events
  static String generateEvent({
    required String summary,
    required DateTime startDate,
    DateTime? endDate,
    String? location,
    String? description,
  }) {
    final event = StringBuffer();
    event.writeln('BEGIN:VCALENDAR');
    event.writeln('VERSION:2.0');
    event.writeln('PRODID:-//QRty App//Event Generator//EN');
    event.writeln('BEGIN:VEVENT');

    // Unique identifier
    final uid = DateTime.now().millisecondsSinceEpoch.toString();
    event.writeln('UID:$uid@qrty.app');

    // Date created
    final now = _formatDateTime(DateTime.now());
    event.writeln('DTSTAMP:$now');

    // Event summary
    event.writeln('SUMMARY:${_escapeText(summary)}');

    // Start date
    event.writeln('DTSTART:${_formatDateTime(startDate)}');

    // End date
    if (endDate != null) {
      event.writeln('DTEND:${_formatDateTime(endDate)}');
    }

    // Location
    if (location?.isNotEmpty == true) {
      event.writeln('LOCATION:${_escapeText(location!)}');
    }

    // Description
    if (description?.isNotEmpty == true) {
      event.writeln('DESCRIPTION:${_escapeText(description!)}');
    }

    event.writeln('END:VEVENT');
    event.writeln('END:VCALENDAR');
    return event.toString();
  }

  /// Format DateTime to iCal format (YYYYMMDDTHHMMSSZ)
  static String _formatDateTime(DateTime dateTime) {
    final utc = dateTime.toUtc();
    return '${utc.year.toString().padLeft(4, '0')}'
        '${utc.month.toString().padLeft(2, '0')}'
        '${utc.day.toString().padLeft(2, '0')}'
        'T'
        '${utc.hour.toString().padLeft(2, '0')}'
        '${utc.minute.toString().padLeft(2, '0')}'
        '${utc.second.toString().padLeft(2, '0')}'
        'Z';
  }

  /// Escape text for iCal format
  static String _escapeText(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll('\n', '\\n');
  }
}
