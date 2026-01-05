import 'dart:io';

import 'package:dns_client/src/rr_type.dart';

/// Abstract interface for DNS client implementations.
abstract class DnsClient {
  /// Looks up the IP addresses for [hostname].
  ///
  /// Returns a list of [InternetAddress] objects representing the resolved
  /// IP addresses.
  Future<List<InternetAddress>> lookup(String hostname);

  /// Looks up DNS records for [hostname] of the specified [rrType].
  ///
  /// Returns a list of data strings from DNS answers matching the given
  /// resource record type.
  ///
  /// Example:
  /// ```dart
  /// final srvRecords = await client.lookupDataByRRType(
  ///   '_jmap._tcp.example.com',
  ///   RRType.SRVType,
  /// );
  /// ```
  Future<List<String>> lookupDataByRRType(String hostname, RRType rrType);
}
