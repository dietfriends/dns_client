import 'dart:io';

import 'dns_record.dart';

export 'dns_record.dart';

/// Abstract DNS client that can resolve hostnames and fetch DNS records.
abstract class DnsClient {
  /// Resolves the given [hostname] to a list of [InternetAddress].
  ///
  /// If [type] is provided, only records of that type are returned (e.g., [DnsRecordType.MX]).
  /// If [type] is null, only [DnsRecordType.A] (IPv4) and [DnsRecordType.AAAA] (IPv6)
  /// records are returned by default, filtering the answers from a broader [DnsRecordType.ANY] query.
  ///
  /// **Note:** Not all DNS providers support `ANY` queries, and some may return incomplete
  /// results or block them entirely. This method filters the answers to include only A and AAAA
  /// records regardless of provider behavior.
  ///
  /// Uses [lookupRecord] internally to fetch the full DNS response and filters the answers
  /// according to the requested type.
  ///
  /// Returns a [List] of [InternetAddress] objects corresponding to the filtered records.
  Future<List<InternetAddress>> lookup(String hostname, {DnsRecordType? type});

  /// Looks up a DNS record of the specified [type] for the given [hostname].
  ///
  /// By default, [DnsRecordType.ANY] is used to fetch all available records.
  /// Returns a [DnsRecord] containing the answers and metadata.
  Future<DnsRecord> lookupRecord(
    String hostname, {
    DnsRecordType type = DnsRecordType.ANY,
  });

  /// Closes the DNS client and releases any underlying resources.
  ///
  /// If [force] is `false` (the default), the client will allow
  /// active connections to finish before closing.
  /// If [force] is `true`, all active connections are immediately
  /// terminated, and further lookups will throw a [StateError].
  ///
  /// After calling this method, the client **cannot be used** again.
  void close({bool force = false});
}
