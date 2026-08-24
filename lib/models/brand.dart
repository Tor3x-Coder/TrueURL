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

    // === Expanded Nigerian Brands (Popular but not always in scam lists) ===

    // Fintech & Digital Banks
    Brand(name: 'PiggyVest', domains: ['piggyvest.com'], category: 'Fintech'),
    Brand(name: 'Cowrywise', domains: ['cowrywise.com'], category: 'Fintech'),
    Brand(name: 'Risevest', domains: ['risevest.com'], category: 'Fintech'),
    Brand(name: 'Chipper Cash', domains: ['chippercash.com'], category: 'Fintech'),
    Brand(name: 'Carbon', domains: ['carbon.ng'], category: 'Fintech'),
    Brand(name: 'FairMoney', domains: ['fairmoney.ng'], category: 'Fintech'),

    // E-commerce & Delivery
    Brand(name: 'Jumia', domains: ['jumia.com.ng'], category: 'E-commerce'),
    Brand(name: 'Konga', domains: ['konga.com'], category: 'E-commerce'),
    Brand(name: 'Jiji', domains: ['jiji.ng'], category: 'E-commerce'),
    Brand(name: 'GIG Logistics', domains: ['giglogistics.com'], category: 'Logistics'),

    // Universities (Common targets)
    Brand(name: 'UNILAG', domains: ['unilag.edu.ng'], category: 'University'),
    Brand(name: 'UI', domains: ['ui.edu.ng'], category: 'University'),
    Brand(name: 'OAU', domains: ['oauife.edu.ng'], category: 'University'),
    Brand(name: 'UNN', domains: ['unn.edu.ng'], category: 'University'),
    Brand(name: 'ABU', domains: ['abu.edu.ng'], category: 'University'),

    // More Government Agencies
    Brand(name: 'NCC', domains: ['ncc.gov.ng'], category: 'Gov'),
    Brand(name: 'NCC (Consumer)', domains: ['consumer.ncc.gov.ng'], category: 'Gov'),
    Brand(name: 'Nigerian Police', domains: ['npf.gov.ng'], category: 'Gov'),
    Brand(name: 'EFCC', domains: ['efccnigeria.org'], category: 'Gov'),
    Brand(name: 'Nigerian Army', domains: ['army.mil.ng'], category: 'Gov'),

    // Popular Services
    Brand(name: 'Bet9ja', domains: ['bet9ja.com'], category: 'Betting'),
    Brand(name: 'SportyBet', domains: ['sportybet.com'], category: 'Betting'),
    Brand(name: 'Nairabet', domains: ['nairabet.com'], category: 'Betting'),
    Brand(name: 'BetKing', domains: ['betking.com'], category: 'Betting'),

    // Ride-hailing & Delivery
    Brand(name: 'Uber', domains: ['uber.com'], category: 'Ride-hailing'),
    Brand(name: 'Bolt', domains: ['bolt.eu'], category: 'Ride-hailing'),
    Brand(name: 'Gokada', domains: ['gokada.ng'], category: 'Ride-hailing'),

    // More Banks
    Brand(name: 'UBA', domains: ['ubagroup.com'], category: 'Banks'),
    Brand(name: 'Stanbic IBTC', domains: ['stanbicibtcbank.com'], category: 'Banks'),
    Brand(name: 'Sterling Bank', domains: ['sterling.ng'], category: 'Banks'),
    Brand(name: 'Unity Bank', domains: ['unitybankng.com'], category: 'Banks'),
    Brand(name: 'Wema Bank', domains: ['wemabank.com'], category: 'Banks'),
    Brand(name: 'Polaris Bank', domains: ['polarisbanklimited.com'], category: 'Banks'),

    // Insurance & Pensions
    Brand(name: 'Leadway', domains: ['leadway.com'], category: 'Insurance'),
    Brand(name: 'AXA Mansard', domains: ['axamansard.com'], category: 'Insurance'),
    Brand(name: 'AIICO', domains: ['aiicoplc.com'], category: 'Insurance'),

    // Popular Apps & Services
    Brand(name: 'Glo', domains: ['gloworld.com'], category: 'Telcos'),
    Brand(name: '9mobile', domains: ['9mobile.com.ng'], category: 'Telcos'),
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