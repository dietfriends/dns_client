import 'package:equatable/equatable.dart';

/// A resource record, commonly referred to as an RR, is the unit of information entry in DNS zone files
/// Standard DNS resource record type
class RRType with EquatableMixin {
  static final RRType AType = RRType('A', 1); // Name to address mapping record
  static final RRType NSType = RRType('NS', 2); // Name server record
  static final RRType CNAMEType = RRType('CNAME', 5); // Canonical Name record
  static final RRType SOAType = RRType('SOA', 6); // Start of authority
  static final RRType PTRType =
      RRType('PTR', 12); // Address to name mapping record
  static final RRType MXType = RRType('MX', 15); // Mail exchanger record
  static final RRType TXTType = RRType('TXT', 16); // Text record
  static final RRType AAAAType =
      RRType('AAAA', 28); // Host to Ipv6 address record
  static final RRType SRVType = RRType('SRV', 33); // Service record

  final String name;
  final int value;

  RRType(this.name, this.value);

  @override
  List<Object?> get props => [name, value];
}
