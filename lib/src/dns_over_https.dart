import 'dart:convert';
import 'dart:io';
import 'package:dns_client/dns_client.dart';

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
  void close({bool force = false}) {
    _client.close(force: force);
  }

  /// [Google DNS-over-HTTPS documentation](https://developers.google.com/speed/public-dns/docs/dns-over-https)
  factory DnsOverHttps.google({Duration? timeout}) {
    return DnsOverHttps('https://dns.google/resolve', timeout: timeout);
  }

  /// [Cloudflare DNS-over-HTTPS documentation](https://developers.cloudflare.com/1.1.1.1/dns-over-https/json-format/)
  factory DnsOverHttps.cloudflare({Duration? timeout}) {
    return DnsOverHttps(
      'https://cloudflare-dns.com/dns-query',
      timeout: timeout,
    );
  }

  /// AdGuard DNS with default filtering (blocks ads and trackers).
  ///
  /// [AdGuard DNS documentation](https://adguard-dns.io/kb/general/dns-providers/)
  factory DnsOverHttps.adguard({Duration? timeout}) {
    return DnsOverHttps(
      'https://dns.adguard-dns.com/resolve',
      timeout: timeout,
    );
  }

  /// AdGuard DNS without filtering.
  ///
  /// [AdGuard DNS documentation](https://adguard-dns.io/kb/general/dns-providers/)
  factory DnsOverHttps.adguardNonFiltering({Duration? timeout}) {
    return DnsOverHttps(
      'https://unfiltered.adguard-dns.com/resolve',
      timeout: timeout,
    );
  }

  /// AdGuard DNS with family protection (blocks ads, trackers, and adult content).
  ///
  /// [AdGuard DNS documentation](https://adguard-dns.io/kb/general/dns-providers/)
  factory DnsOverHttps.adguardFamily({Duration? timeout}) {
    return DnsOverHttps(
      'https://family.adguard-dns.com/resolve',
      timeout: timeout,
    );
  }

  /// NextDNS DNS-over-HTTPS.
  ///
  /// [configId] is optional. When provided, uses personalized filtering
  /// based on your NextDNS configuration (typically a 6-character alphanumeric
  /// ID from your NextDNS dashboard). Without [configId], uses the NextDNS
  /// public resolver.
  ///
  /// [NextDNS documentation](https://nextdns.io/)
  factory DnsOverHttps.nextdns({String? configId, Duration? timeout}) {
    final url =
        configId != null
            ? 'https://dns.nextdns.io/${Uri.encodeComponent(configId)}'
            : 'https://dns.nextdns.io/dns-query';
    return DnsOverHttps(url, timeout: timeout);
  }

  /// NextDNS Anycast endpoint for optimal routing.
  ///
  /// Uses NextDNS anycast infrastructure for lower latency routing.
  /// [configId] is optional for personalized filtering (typically a
  /// 6-character alphanumeric ID from your NextDNS dashboard).
  ///
  /// [NextDNS documentation](https://nextdns.io/)
  factory DnsOverHttps.nextdnsAnycast({String? configId, Duration? timeout}) {
    final url =
        configId != null
            ? 'https://anycast.dns.nextdns.io/${Uri.encodeComponent(configId)}'
            : 'https://anycast.dns.nextdns.io/dns-query';
    return DnsOverHttps(url, timeout: timeout);
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

  Future<DnsRecord> lookupHttps(
    String hostname, {
    InternetAddressType type = InternetAddressType.any,
  }) async {
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
    final request = await _client.getUrl(
      Uri.https(_uri.authority, _uri.path, query),
    );
    request.headers.set('accept', 'application/dns-json');
    final response = await request.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    final record = DnsRecord.fromJson(
      jsonDecode(contents.toString()) as Map<String, dynamic>,
    );
    return record;
  }

  /// Performs a DNS-over-HTTPS query for the specified [hostname] and [rrType].
  ///
  /// Returns the full [DnsRecord] response from the DNS server.
  ///
  /// Throws [DnsHttpException] if the HTTP request fails (non-200 status).
  Future<DnsRecord> lookupHttpsByRRType(String hostname, RRType rrType) async {
    // Build URL
    var query = {'name': hostname, 'type': '${rrType.value}'};

    // Hide my IP?
    if (maximalPrivacy) {
      query['edns_client_subnet'] = '0.0.0.0/0';
    }
    final request = await _client.getUrl(
      Uri.https(_uri.authority, _uri.path, query),
    );
    request.headers.set('accept', 'application/dns-json');
    final response = await request.close();

    // Validate HTTP response status
    if (response.statusCode != 200) {
      await response.drain<void>();
      throw DnsHttpException(
        'DNS-over-HTTPS request failed',
        statusCode: response.statusCode,
      );
    }

    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    final record = DnsRecord.fromJson(
      jsonDecode(contents.toString()) as Map<String, dynamic>,
    );
    return record;
  }

  /// Looks up DNS records for [hostname] of the specified [rrType].
  ///
  /// Returns a list of data strings from DNS answers matching the given
  /// resource record type. Returns an empty list if no matching records
  /// are found.
  ///
  /// Throws [DnsLookupException] if the DNS query fails (SERVFAIL, NXDOMAIN, etc.).
  /// Throws [DnsHttpException] if the HTTP request fails.
  ///
  /// Example:
  /// ```dart
  /// final srvRecords = await client.lookupDataByRRType(
  ///   '_jmap._tcp.example.com',
  ///   RRType.SRVType,
  /// );
  /// ```
  @override
  Future<List<String>> lookupDataByRRType(
    String hostname,
    RRType rrType,
  ) async {
    final record = await lookupHttpsByRRType(hostname, rrType);

    // Check for DNS-level errors
    if (record.isFailure) {
      throw DnsLookupException(
        'DNS lookup failed for $hostname',
        hostname: hostname,
        status: record.status,
      );
    }

    return record.answer
            ?.where((answer) => answer.type == rrType.value)
            .map((answer) => answer.data)
            .toList() ??
        [];
  }
}
