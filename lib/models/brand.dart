class Brand {
  final String name;
  final List<String> domains;
  final String category; // e.g. 'Exams', 'Telcos', 'Banks'
  final String? warning; // "This brand will never..."

  const Brand({
    required this.name,
    required this.domains,
    required this.category,
    this.warning,
  });
}

class BrandBook {
  static const List<Brand> brands = [
    // Exams
    Brand(
      name: 'JAMB',
      domains: ['jamb.gov.ng'],
      category: 'Exams',
      warning: 'JAMB never asks for payment via WhatsApp links or random portals.',
    ),
    Brand(
      name: 'WAEC',
      domains: ['waecdirect.org', 'waecnigeria.org'],
      category: 'Exams',
    ),
    Brand(
      name: 'NECO',
      domains: ['neco.gov.ng'],
      category: 'Exams',
    ),
    Brand(
      name: 'NABTEB',
      domains: ['nabteb.gov.ng'],
      category: 'Exams',
    ),

    // Government
    Brand(
      name: 'NYSC',
      domains: ['nysc.gov.ng'],
      category: 'Gov',
    ),
    Brand(
      name: 'NIMC',
      domains: ['nimc.gov.ng'],
      category: 'Gov',
    ),
    Brand(
      name: 'INEC',
      domains: ['inec.gov.ng'],
      category: 'Gov',
    ),
    Brand(
      name: 'FIRS',
      domains: ['firs.gov.ng'],
      category: 'Gov',
    ),
    Brand(
      name: 'CBN',
      domains: ['cbn.gov.ng'],
      category: 'Gov',
    ),
    Brand(
      name: 'Immigration',
      domains: ['immigration.gov.ng'],
      category: 'Gov',
    ),

    // Telcos
    Brand(
      name: 'MTN',
      domains: ['mtn.ng', 'mtnonline.com'],
      category: 'Telcos',
      warning: 'MTN does not drop data gifts as anonymous group-chat links. Official promos live on mtn.ng and the MyMTN app.',
    ),
    Brand(
      name: 'Airtel',
      domains: ['airtel.com.ng'],
      category: 'Telcos',
      warning: 'Airtel does not send free data via WhatsApp forwards.',
    ),
    Brand(
      name: 'Glo',
      domains: ['gloworld.com'],
      category: 'Telcos',
    ),
    Brand(
      name: '9mobile',
      domains: ['9mobile.com.ng'],
      category: 'Telcos',
    ),

    // Banks / Fintech
    Brand(
      name: 'FirstBank',
      domains: ['firstbanknigeria.com'],
      category: 'Banks',
    ),
    Brand(
      name: 'GTBank',
      domains: ['gtbank.com'],
      category: 'Banks',
    ),
    Brand(
      name: 'Access Bank',
      domains: ['accessbankplc.com'],
      category: 'Banks',
    ),
    Brand(
      name: 'Zenith Bank',
      domains: ['zenithbank.com'],
      category: 'Banks',
    ),
    Brand(
      name: 'Kuda',
      domains: ['kuda.com'],
      category: 'Fintech',
    ),
    Brand(
      name: 'OPay',
      domains: ['opayweb.com'],
      category: 'Fintech',
    ),
    Brand(
      name: 'PalmPay',
      domains: ['palmpay.com'],
      category: 'Fintech',
    ),
    Brand(
      name: 'Moniepoint',
      domains: ['moniepoint.com'],
      category: 'Fintech',
    ),
    Brand(
      name: 'Paystack',
      domains: ['paystack.com'],
      category: 'Fintech',
    ),
    Brand(
      name: 'Flutterwave',
      domains: ['flutterwave.com'],
      category: 'Fintech',
    ),
  ];

  static Brand? findByDomain(String domain) {
    final cleanDomain = domain.toLowerCase().trim();
    for (final brand in brands) {
      for (final d in brand.domains) {
        if (cleanDomain == d || cleanDomain.endsWith('.$d')) {
          return brand;
        }
      }
    }
    return null;
  }

  static List<Brand> getByCategory(String category) {
    return brands.where((b) => b.category == category).toList();
  }
}