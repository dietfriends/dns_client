import 'dart:convert';
import 'dart:io';

import 'dns_client.dart';

class DnsOverHttps extends DnsClient {
  final _client = HttpClient();

  /// URL of the service (without query).
  final String url;
  final Uri _uri;

  /// Whether to hide client IP address from the authoritative server.
  final bool maximalPrivacy;

  /// Default timeout for operations.
  final Duration? timeout;

  DnsOverHttps(
    this.url, {
    this.timeout = const Duration(milliseconds: 5000),
    this.maximalPrivacy = false,
  }) : _uri = Uri.parse(url) {
    _client.connectionTimeout = timeout;
  }

  /// Shuts down the HTTP client.
  ///
  /// If [force] is `false` (the default) the [HttpClient] will be kept alive
  /// until all active connections are done. If [force] is `true` any active
  /// connections will be closed to immediately release all resources. These
  /// closed connections will receive an error event to indicate that the client
  /// was shut down. In both cases trying to establish a new connection after
  /// calling [close] will throw an exception.
  @override
  void close({bool force = false}) {
    _client.close(force: force);
  }

  factory DnsOverHttps.google({Duration? timeout}) {
    return DnsOverHttps('https://dns.google.com/resolve', timeout: timeout);
  }

  factory DnsOverHttps.cloudflare({Duration? timeout}) {
    return DnsOverHttps(
      'https://cloudflare-dns.com/dns-query',
      timeout: timeout,
    );
  }

  @override
  Future<List<InternetAddress>> lookup(
    String hostname, {
    DnsRecordType? type,
  }) async {
    final record = await lookupRecord(
      hostname,
      type: type ?? DnsRecordType.ANY,
    );

    Iterable<Answer> l = record.answer ?? [];

    if (type != null) {
      l = l.where((r) => r.recordType == type);
    } else {
      l = l.where(
        (r) =>
            r.recordType == DnsRecordType.A ||
            r.recordType == DnsRecordType.AAAA,
      );
    }

    var addressesAsync = l
        .map((answer) => answer.asInternetAddressAsync)
        .toList();

    var addresses = await Future.wait(addressesAsync);

    return addresses;
  }

  @override
  Future<DnsRecord> lookupRecord(
    String hostname, {
    DnsRecordType type = DnsRecordType.ANY,
  }) async {
    var query = {'name': hostname, 'type': type.value};

    if (maximalPrivacy) {
      query['edns_client_subnet'] = '0.0.0.0/0';
    }

    final request = await _client.getUrl(
      Uri.https(_uri.authority, _uri.path, query),
    );
    request.headers.set('accept', 'application/dns-json');

    final response = await request.close();
    final contents = await response.transform(utf8.decoder).join();
    return DnsRecord.fromJson(jsonDecode(contents));
  }
}
