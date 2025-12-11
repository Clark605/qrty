/// Generates vCard 3.0 format for contacts and business cards
class VCardGenerator {
  /// Generate vCard for contact information
  static String generateContact({
    required String firstName,
    required String lastName,
    String? company,
    String? job,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    final vcard = StringBuffer();
    vcard.writeln('BEGIN:VCARD');
    vcard.writeln('VERSION:3.0');

    // Full name
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      vcard.writeln('FN:$firstName $lastName'.trim());
      vcard.writeln('N:$lastName;$firstName;;;');
    }

    // Organization and title
    if (company?.isNotEmpty == true) {
      vcard.writeln('ORG:$company');
    }
    if (job?.isNotEmpty == true) {
      vcard.writeln('TITLE:$job');
    }

    // Contact information
    if (phone?.isNotEmpty == true) {
      vcard.writeln('TEL:$phone');
    }
    if (email?.isNotEmpty == true) {
      vcard.writeln('EMAIL:$email');
    }
    if (website?.isNotEmpty == true) {
      vcard.writeln('URL:$website');
    }

    // Address
    if (address?.isNotEmpty == true) {
      final addressParts = [
        '', // PO Box (empty)
        '', // Extended address (empty)
        address ?? '',
        city ?? '',
        state ?? '',
        zip ?? '',
        country ?? '',
      ];
      vcard.writeln('ADR:${addressParts.join(';')}');
    }

    vcard.writeln('END:VCARD');
    return vcard.toString();
  }

  /// Generate vCard for business card
  static String generateBusiness({
    required String company,
    String? industry,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    final vcard = StringBuffer();
    vcard.writeln('BEGIN:VCARD');
    vcard.writeln('VERSION:3.0');

    // Company as the primary name
    vcard.writeln('FN:$company');
    vcard.writeln('ORG:$company');

    // Industry as category
    if (industry?.isNotEmpty == true) {
      vcard.writeln('CATEGORIES:$industry');
    }

    // Contact information
    if (phone?.isNotEmpty == true) {
      vcard.writeln('TEL:$phone');
    }
    if (email?.isNotEmpty == true) {
      vcard.writeln('EMAIL:$email');
    }
    if (website?.isNotEmpty == true) {
      vcard.writeln('URL:$website');
    }

    // Address
    if (address?.isNotEmpty == true) {
      final addressParts = [
        '', // PO Box (empty)
        '', // Extended address (empty)
        address ?? '',
        city ?? '',
        state ?? '',
        zip ?? '',
        country ?? '',
      ];
      vcard.writeln('ADR:${addressParts.join(';')}');
    }

    vcard.writeln('END:VCARD');
    return vcard.toString();
  }
}
