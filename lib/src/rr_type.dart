// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

/// Represents a DNS Resource Record Type (RRType).
///
/// A resource record (RR) is the fundamental unit of data in DNS zone files.
/// Each RRType identifies the format and purpose of the data in the record.
///
/// This class provides static constants for commonly used record types
/// (A, AAAA, CNAME, MX, SRV, etc.). Custom types can be created for
/// types not pre-defined.
///
/// Example:
/// ```dart
/// // Using a predefined type
/// await dns.lookupDataByRRType('example.com', RRType.MX);
///
/// // Creating a custom type (e.g., TLSA record, type 52)
/// final tlsaType = RRType('TLSA', 52);
/// await dns.lookupDataByRRType('example.com', tlsaType);
/// ```
///
/// See also:
/// - [List of DNS record types](https://en.wikipedia.org/wiki/List_of_DNS_record_types)
/// - [IANA DNS Parameters](https://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml)
/// - RFC 1035 for standard DNS record types
class RRType with EquatableMixin {
  // Predefined record types

  /// A record: Maps a hostname to an IPv4 address.
  static final RRType A = RRType._('A', 1);

  /// NS record: Delegates a DNS zone to authoritative name servers.
  static final RRType NS = RRType._('NS', 2);

  /// CNAME record: Canonical name (alias) for a domain.
  static final RRType CNAME = RRType._('CNAME', 5);

  /// SOA record: Start of authority, defines zone properties.
  static final RRType SOA = RRType._('SOA', 6);

  /// PTR record: Pointer for reverse DNS lookups.
  static final RRType PTR = RRType._('PTR', 12);

  /// HINFO record: Host CPU and OS information.
  static final RRType HINFO = RRType._('HINFO', 13);

  /// MX record: Mail exchanger for email routing.
  static final RRType MX = RRType._('MX', 15);

  /// TXT record: Arbitrary text data (SPF, DKIM, etc.).
  static final RRType TXT = RRType._('TXT', 16);

  /// RP record: Responsible person for the domain.
  static final RRType RP = RRType._('RP', 17);

  /// AFSDB record: AFS database server location.
  static final RRType AFSDB = RRType._('AFSDB', 18);

  /// KEY record: Legacy public key (RFC 2535, obsoleted by DNSKEY in RFC 4034).
  static final RRType KEY = RRType._('KEY', 25);

  /// AAAA record: Maps a hostname to an IPv6 address.
  static final RRType AAAA = RRType._('AAAA', 28);

  /// LOC record: Geographic location of a domain.
  static final RRType LOC = RRType._('LOC', 29);

  /// SRV record: Service location for specific services.
  static final RRType SRV = RRType._('SRV', 33);

  /// NAPTR record: Naming authority pointer for regex-based rewriting (ENUM, SIP).
  static final RRType NAPTR = RRType._('NAPTR', 35);

  /// KX record: Key management agent host (similar to MX for mail).
  static final RRType KX = RRType._('KX', 36);

  /// CERT record: Certificate storage (X.509, PGP, etc.).
  static final RRType CERT = RRType._('CERT', 37);

  /// APL record: Address prefix list for network ranges.
  static final RRType APL = RRType._('APL', 42);

  /// DS record: Delegation signer for DNSSEC chain of trust.
  static final RRType DS = RRType._('DS', 43);

  /// IPSECKEY record: IPsec public key for IKE.
  static final RRType IPSECKEY = RRType._('IPSECKEY', 45);

  /// NSEC record: Next secure record for DNSSEC denial of existence.
  static final RRType NSEC = RRType._('NSEC', 47);

  /// DNSKEY record: Public key for DNSSEC zone signing.
  static final RRType DNSKEY = RRType._('DNSKEY', 48);

  /// DHCID record: DHCP client identifier for DNS updates.
  static final RRType DHCID = RRType._('DHCID', 49);

  /// NSEC3 record: Hashed denial of existence for DNSSEC.
  static final RRType NSEC3 = RRType._('NSEC3', 50);

  /// NSEC3PARAM record: NSEC3 parameters for DNSSEC.
  static final RRType NSEC3PARAM = RRType._('NSEC3PARAM', 51);

  /// SMIMEA record: S/MIME certificate association.
  static final RRType SMIMEA = RRType._('SMIMEA', 53);

  /// HIP record: Host identity protocol public key.
  static final RRType HIP = RRType._('HIP', 55);

  /// CDS record: Child copy of DS record for DNSSEC.
  static final RRType CDS = RRType._('CDS', 59);

  /// SVCB record: Service binding for generic services.
  static final RRType SVCB = RRType._('SVCB', 64);

  /// HTTPS record: Service binding for HTTPS connections.
  static final RRType HTTPS = RRType._('HTTPS', 65);

  /// EUI48 record: 48-bit MAC address (EUI-48).
  static final RRType EUI48 = RRType._('EUI48', 108);

  /// EUI64 record: 64-bit MAC address (EUI-64).
  static final RRType EUI64 = RRType._('EUI64', 109);

  /// URI record: Uniform resource identifier mapping.
  static final RRType URI = RRType._('URI', 256);

  /// CAA record: Certification authority authorization.
  static final RRType CAA = RRType._('CAA', 257);

  /// TA record: DNSSEC trust anchor.
  static final RRType TA = RRType._('TA', 32768);

  /// DLV record: DNSSEC lookaside validation (deprecated since 2017, no longer operational).
  static final RRType DLV = RRType._('DLV', 32769);

  // Legacy aliases (deprecated, use new names without 'Type' suffix)

  @Deprecated('Use RRType.A instead')
  static final RRType AType = A;

  @Deprecated('Use RRType.NS instead')
  static final RRType NSType = NS;

  @Deprecated('Use RRType.CNAME instead')
  static final RRType CNAMEType = CNAME;

  @Deprecated('Use RRType.SOA instead')
  static final RRType SOAType = SOA;

  @Deprecated('Use RRType.PTR instead')
  static final RRType PTRType = PTR;

  @Deprecated('Use RRType.MX instead')
  static final RRType MXType = MX;

  @Deprecated('Use RRType.TXT instead')
  static final RRType TXTType = TXT;

  @Deprecated('Use RRType.AAAA instead')
  static final RRType AAAAType = AAAA;

  @Deprecated('Use RRType.SRV instead')
  static final RRType SRVType = SRV;

  /// Map of known RRTypes by their numeric value.
  static final Map<int, RRType> _byValue = {
    1: A,
    2: NS,
    5: CNAME,
    6: SOA,
    12: PTR,
    13: HINFO,
    15: MX,
    16: TXT,
    17: RP,
    18: AFSDB,
    25: KEY,
    28: AAAA,
    29: LOC,
    33: SRV,
    35: NAPTR,
    36: KX,
    37: CERT,
    42: APL,
    43: DS,
    45: IPSECKEY,
    47: NSEC,
    48: DNSKEY,
    49: DHCID,
    50: NSEC3,
    51: NSEC3PARAM,
    53: SMIMEA,
    55: HIP,
    59: CDS,
    64: SVCB,
    65: HTTPS,
    108: EUI48,
    109: EUI64,
    256: URI,
    257: CAA,
    32768: TA,
    32769: DLV,
  };

  /// All predefined record types.
  static List<RRType> get values => _byValue.values.toList();

  /// The mnemonic name of this record type (e.g., 'A', 'AAAA', 'MX').
  final String name;

  /// The numeric type code as defined in DNS standards (e.g., 1 for A, 28 for AAAA).
  final int value;

  /// Creates a custom RRType.
  ///
  /// Use this for record types not available as static constants.
  /// The [value] must be in the valid DNS range (1-65535).
  ///
  /// Throws [ArgumentError] if [value] is out of range.
  RRType(this.name, this.value) {
    if (value < 1 || value > 65535) {
      throw ArgumentError.value(value, 'value', 'Must be between 1 and 65535');
    }
  }

  /// Private constructor for static constants (no validation needed).
  RRType._(this.name, this.value);

  /// Returns the RRType for the given numeric [value], or `null` if unknown.
  ///
  /// This only returns pre-defined types. For custom types, use the
  /// regular constructor.
  static RRType? fromValue(int value) => _byValue[value];

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'RRType($name, $value)';
}
