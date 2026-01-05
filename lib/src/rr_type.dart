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
/// await dns.lookupDataByRRType('example.com', RRType.MXType);
///
/// // Creating a custom type (e.g., CAA record, type 257)
/// final caaType = RRType('CAA', 257);
/// await dns.lookupDataByRRType('example.com', caaType);
/// ```
///
/// See also:
/// - [List of DNS record types](https://en.wikipedia.org/wiki/List_of_DNS_record_types)
/// - [IANA DNS Parameters](https://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml)
/// - RFC 1035 for standard DNS record types
class RRType with EquatableMixin {
  /// A record: Maps a hostname to an IPv4 address.
  static final RRType AType = RRType._('A', 1);

  /// NS record: Name server record.
  static final RRType NSType = RRType._('NS', 2);

  /// CNAME record: Canonical name (alias) record.
  static final RRType CNAMEType = RRType._('CNAME', 5);

  /// SOA record: Start of authority record.
  static final RRType SOAType = RRType._('SOA', 6);

  /// PTR record: Pointer record for reverse DNS lookups.
  static final RRType PTRType = RRType._('PTR', 12);

  /// MX record: Mail exchanger record.
  static final RRType MXType = RRType._('MX', 15);

  /// TXT record: Text record for arbitrary data.
  static final RRType TXTType = RRType._('TXT', 16);

  /// AAAA record: Maps a hostname to an IPv6 address.
  static final RRType AAAAType = RRType._('AAAA', 28);

  /// SRV record: Service location record.
  static final RRType SRVType = RRType._('SRV', 33);

  /// Map of known RRTypes by their numeric value.
  static final Map<int, RRType> _byValue = {
    1: AType,
    2: NSType,
    5: CNAMEType,
    6: SOAType,
    12: PTRType,
    15: MXType,
    16: TXTType,
    28: AAAAType,
    33: SRVType,
  };

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
