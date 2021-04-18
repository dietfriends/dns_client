import 'dart:convert';
import 'dart:io';
import 'package:dns_client/dns_client.dart';
import 'package:http/http.dart' as http;

import 'dns_record.dart';

class DnsOverHttps extends DnsClient {
  final _client = HttpClient();

  /// URL of the service (without query).
  final String url;
  final Uri _uri;

  /// Whether to hide client IP address from the authoritative server.
  final bool maximalPrivacy;

  /// Default timeout for operations.
  final Duration? timeout;

  DnsOverHttps(this.url,
      {this.timeout = const Duration(milliseconds: 5000),
      this.maximalPrivacy = false})
      : _uri = Uri.parse(url) {
    _client.connectionTimeout = timeout;
  }

  factory DnsOverHttps.google({Duration? timeout}) {
    return DnsOverHttps('https://dns.google.com/resolve', timeout: timeout);
  }

  factory DnsOverHttps.cloudflare({Duration? timeout}) {
    return DnsOverHttps('https://cloudflare-dns.com/dns-query',
        timeout: timeout);
  }

  @override
  Future<List<InternetAddress>> lookup(String hostname) {
    return lookupHttps(hostname).then((record) {
      return record.answer
              ?.where((answer) => answer.type == 1)
              .map((answer) => InternetAddress(answer.data))
              .toList() ??
          [];
    });
  }

  Future<DnsRecord> lookupHttps(String hostname,
      {InternetAddressType type = InternetAddressType.any}) async {
    // Build URL
    var query = {'name': hostname};
    // Add: IPv4 or IPv6?
    if (type == InternetAddressType.any || type == InternetAddressType.IPv4) {
      query['type'] = 'A';
    } else {
      query['type'] = 'AAAA';
    }

    // Hide my IP?
    if (maximalPrivacy) {
      query['edns_client_subnet'] = '0.0.0.0/0';
    }
    final response = await http.get(Uri.https(_uri.authority, _uri.path, query),
        headers: {'accept': 'application/dns-json'});
    final record = DnsRecord.fromJson(jsonDecode(response.body));
    return record;
  }
}
