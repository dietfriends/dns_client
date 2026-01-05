import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dns_client/dns_client.dart';
import 'package:dns_client/src/dns_wire_codec.dart';
import 'package:http2/http2.dart';

/// DNS-over-HTTPS client using binary wire format (RFC 1035/8484).
///
/// This class provides DNS lookups using the standard DNS wire format
/// instead of JSON. It supports providers like Quad9 that require HTTP/2
/// and only offer wire format endpoints.
///
/// Example:
/// ```dart
/// final client = DnsOverHttpsWire.quad9();
/// final addresses = await client.lookup('example.com');
/// for (final addr in addresses) {
///   print(addr.address);
/// }
/// client.close();
/// ```
///
/// See also:
/// - [DnsOverHttps] for JSON-based DoH providers (Google, Cloudflare, AdGuard)
/// - [RFC 8484](https://datatracker.ietf.org/doc/html/rfc8484) for DoH specification
class DnsOverHttpsWire extends DnsClient {
  final DnsWireCodec _codec = DnsWireCodec();

  /// URL of the DoH service endpoint.
  final String url;
  final Uri _uri;

  /// Default timeout for operations.
  final Duration? timeout;

  ClientTransportConnection? _transport;
  Completer<ClientTransportConnection>? _connecting;
  bool _closed = false;

  /// Creates a DNS-over-HTTPS wire format client.
  ///
  /// The [url] should be a DoH endpoint that accepts wire format requests.
  /// Use factory constructors like [DnsOverHttpsWire.quad9] for common providers.
  DnsOverHttpsWire(
    this.url, {
    this.timeout = const Duration(milliseconds: 5000),
  }) : _uri = Uri.parse(url);

  /// Shuts down the HTTP/2 client.
  ///
  /// If [force] is `false` (the default) the client will wait for pending
  /// requests to complete. If [force] is `true` all connections will be
  /// closed immediately.
  Future<void> close({bool force = false}) async {
    _closed = true;
    if (_transport != null) {
      if (force) {
        await _transport!.terminate();
      } else {
        await _transport!.finish();
      }
      _transport = null;
    }
  }

  // ========== Quad9 Factory Constructors ==========

  /// Quad9 DNS with malware blocking and DNSSEC validation.
  ///
  /// This is the recommended Quad9 endpoint for most users.
  /// Blocks known malicious domains and validates DNSSEC.
  ///
  /// [Quad9 documentation](https://www.quad9.net/service/service-addresses-and-features/)
  factory DnsOverHttpsWire.quad9({Duration? timeout}) {
    return DnsOverHttpsWire(
      'https://dns.quad9.net/dns-query',
      timeout: timeout,
    );
  }

  /// Quad9 DNS with EDNS Client Subnet (ECS) support.
  ///
  /// Like [quad9] but includes geolocation hints for better CDN routing.
  /// Note: ECS provides location data to upstream servers.
  ///
  /// [Quad9 documentation](https://www.quad9.net/service/service-addresses-and-features/)
  factory DnsOverHttpsWire.quad9Ecs({Duration? timeout}) {
    return DnsOverHttpsWire(
      'https://dns11.quad9.net/dns-query',
      timeout: timeout,
    );
  }

  /// Quad9 DNS without malware blocking or DNSSEC.
  ///
  /// No security filtering - use only if you need unfiltered results.
  /// Note: This removes all Quad9 security protections.
  ///
  /// [Quad9 documentation](https://www.quad9.net/service/service-addresses-and-features/)
  factory DnsOverHttpsWire.quad9Unsecured({Duration? timeout}) {
    return DnsOverHttpsWire(
      'https://dns10.quad9.net/dns-query',
      timeout: timeout,
    );
  }

  // ========== DnsClient Interface Implementation ==========

  @override
  Future<List<InternetAddress>> lookup(String hostname) async {
    final record = await lookupWire(hostname, RRType.A);

    // Check for DNS-level errors (consistent with lookupDataByRRType)
    if (record.isFailure) {
      throw DnsLookupException(
        'DNS lookup failed for $hostname',
        hostname: hostname,
        status: record.status,
      );
    }

    return record.answer
            ?.where((answer) => answer.type == RRType.A.value)
            .map((answer) => InternetAddress(answer.data))
            .toList() ??
        [];
  }

  @override
  Future<List<String>> lookupDataByRRType(
    String hostname,
    RRType rrType,
  ) async {
    final record = await lookupWire(hostname, rrType);

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

  // ========== Wire Format Lookup ==========

  /// Performs a DNS lookup using wire format over HTTP/2.
  ///
  /// Returns the full [DnsRecord] response from the DNS server.
  ///
  /// Throws [DnsHttpException] if the HTTP request fails (non-200 status).
  /// Throws [DnsWireFormatException] if the response is malformed.
  /// Throws [StateError] if the client has been closed.
  Future<DnsRecord> lookupWire(String hostname, RRType rrType) async {
    if (_closed) {
      throw StateError('Client has been closed');
    }

    // Encode the query
    final queryBytes = _codec.encodeQuery(hostname, rrType);

    // Connect via HTTP/2 with ALPN
    final transport = await _getOrCreateTransport();

    // Build HTTP/2 headers for POST request
    final path = _uri.path.isEmpty ? '/' : _uri.path;
    final headers = [
      Header.ascii(':method', 'POST'),
      Header.ascii(':path', path),
      Header.ascii(':scheme', _uri.scheme),
      Header.ascii(':authority', _uri.host),
      Header.ascii('content-type', 'application/dns-message'),
      Header.ascii('accept', 'application/dns-message'),
      Header.ascii('content-length', queryBytes.length.toString()),
    ];

    try {
      // Create stream and send request
      final stream = transport.makeRequest(headers, endStream: false);
      stream.outgoingMessages.add(
        DataStreamMessage(queryBytes, endStream: true),
      );

      // Read response
      int? statusCode;
      final responseData = BytesBuilder();

      await for (final message in stream.incomingMessages) {
        if (message is HeadersStreamMessage) {
          for (final header in message.headers) {
            final name = String.fromCharCodes(header.name);
            if (name == ':status') {
              statusCode = int.tryParse(String.fromCharCodes(header.value));
            }
          }
        } else if (message is DataStreamMessage) {
          responseData.add(message.bytes);
        }
      }

      // Validate HTTP response status
      if (statusCode != 200) {
        throw DnsHttpException(
          'DNS-over-HTTPS request failed for $hostname',
          statusCode: statusCode ?? 0,
        );
      }

      // Decode wire format response
      return _codec.decodeResponse(responseData.toBytes());
    } on DnsHttpException {
      rethrow;
    } on DnsWireFormatException {
      rethrow;
    } catch (e) {
      // Invalidate transport on stream/connection errors
      _transport = null;
      throw DnsHttpException(
        'HTTP/2 stream error during DNS lookup for $hostname: $e',
        statusCode: 0,
      );
    }
  }

  /// Gets or creates an HTTP/2 transport connection.
  ///
  /// Uses a Completer to prevent race conditions when multiple concurrent
  /// lookups attempt to create a transport connection simultaneously.
  Future<ClientTransportConnection> _getOrCreateTransport() async {
    // Return existing open connection
    if (_transport != null && _transport!.isOpen) {
      return _transport!;
    }

    // Wait for in-progress connection attempt
    if (_connecting != null) {
      return _connecting!.future;
    }

    // Start new connection attempt
    _connecting = Completer<ClientTransportConnection>();

    try {
      // Connect with ALPN to negotiate HTTP/2
      final socket = await SecureSocket.connect(
        _uri.host,
        _uri.port,
        supportedProtocols: ['h2'],
        timeout: timeout,
      );

      // Verify HTTP/2 was negotiated
      if (socket.selectedProtocol != 'h2') {
        socket.destroy();
        throw DnsHttpException(
          'Server does not support HTTP/2 (got: ${socket.selectedProtocol})',
          statusCode: 0,
        );
      }

      try {
        _transport = ClientTransportConnection.viaSocket(socket);
        _connecting!.complete(_transport);
        return _transport!;
      } catch (e) {
        socket.destroy();
        rethrow;
      }
    } catch (e) {
      _connecting!.completeError(e);
      rethrow;
    } finally {
      _connecting = null;
    }
  }
}
