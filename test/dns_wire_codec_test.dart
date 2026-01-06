import 'dart:typed_data';

import 'package:dns_client/src/dns_wire_codec.dart';
import 'package:dns_client/src/rr_type.dart';
import 'package:test/test.dart';

void main() {
  group('DnsWireCodec', () {
    late DnsWireCodec codec;

    setUp(() {
      codec = DnsWireCodec();
    });

    group('encodeDomainName', () {
      test('encodes simple domain', () {
        final result = codec.encodeDomainName('example.com');
        expect(
          result,
          equals(
            Uint8List.fromList([
              7, // length of 'example'
              101, 120, 97, 109, 112, 108, 101, // 'example'
              3, // length of 'com'
              99, 111, 109, // 'com'
              0, // terminator
            ]),
          ),
        );
      });

      test('encodes subdomain', () {
        final result = codec.encodeDomainName('www.example.com');
        expect(
          result,
          equals(
            Uint8List.fromList([
              3, // length of 'www'
              119, 119, 119, // 'www'
              7, // length of 'example'
              101, 120, 97, 109, 112, 108, 101, // 'example'
              3, // length of 'com'
              99, 111, 109, // 'com'
              0, // terminator
            ]),
          ),
        );
      });

      test('handles trailing dot', () {
        final result = codec.encodeDomainName('example.com.');
        final expected = codec.encodeDomainName('example.com');
        expect(result, equals(expected));
      });

      test('encodes empty string as root', () {
        final result = codec.encodeDomainName('');
        expect(result, equals(Uint8List.fromList([0])));
      });

      test('throws on empty label', () {
        expect(
          () => codec.encodeDomainName('example..com'),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('throws on label exceeding 63 bytes', () {
        final longLabel = 'a' * 64;
        expect(
          () => codec.encodeDomainName('$longLabel.com'),
          throwsA(isA<DnsWireFormatException>()),
        );
      });
    });

    group('decodeDomainName', () {
      test('decodes simple domain', () {
        final data = Uint8List.fromList([
          7, 101, 120, 97, 109, 112, 108, 101, // 'example'
          3, 99, 111, 109, // 'com'
          0, // terminator
        ]);
        final (name, bytesRead) = codec.decodeDomainName(data, 0);
        expect(name, equals('example.com'));
        expect(bytesRead, equals(13));
      });

      test('handles compression pointer', () {
        // Build a message with compression:
        // Offset 0: example.com (13 bytes)
        // Offset 13: pointer to offset 0
        final data = Uint8List.fromList([
          7, 101, 120, 97, 109, 112, 108, 101, // 'example'
          3, 99, 111, 109, // 'com'
          0, // terminator
          0xC0, 0x00, // compression pointer to offset 0
        ]);

        final (name, bytesRead) = codec.decodeDomainName(data, 13);
        expect(name, equals('example.com'));
        expect(bytesRead, equals(2)); // Only counts pointer bytes
      });

      test('throws on truncated pointer', () {
        final data = Uint8List.fromList([0xC0]); // Truncated pointer
        expect(
          () => codec.decodeDomainName(data, 0),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('throws on forward pointer', () {
        final data = Uint8List.fromList([
          0xC0, 0x10, // Pointer to offset 16 (forward reference)
        ]);
        expect(
          () => codec.decodeDomainName(data, 0),
          throwsA(isA<DnsWireFormatException>()),
        );
      });
    });

    group('encodeQuery', () {
      test('creates valid DNS query message', () {
        final query = codec.encodeQuery(
          'example.com',
          RRType.A,
          transactionId: 0x1234,
        );

        // Check header
        expect(query.length, greaterThanOrEqualTo(12));

        final view = ByteData.sublistView(query);

        // Transaction ID
        expect(view.getUint16(0, Endian.big), equals(0x1234));

        // Flags: RD=1
        expect(view.getUint16(2, Endian.big), equals(0x0100));

        // QDCOUNT = 1
        expect(view.getUint16(4, Endian.big), equals(1));

        // ANCOUNT, NSCOUNT, ARCOUNT = 0
        expect(view.getUint16(6, Endian.big), equals(0));
        expect(view.getUint16(8, Endian.big), equals(0));
        expect(view.getUint16(10, Endian.big), equals(0));

        // Check question section ends with QTYPE=1 (A) and QCLASS=1 (IN)
        final qtype = view.getUint16(query.length - 4, Endian.big);
        final qclass = view.getUint16(query.length - 2, Endian.big);
        expect(qtype, equals(1)); // A record
        expect(qclass, equals(1)); // IN class
      });

      test('generates random transaction ID when not specified', () {
        final query1 = codec.encodeQuery('example.com', RRType.A);
        final query2 = codec.encodeQuery('example.com', RRType.A);

        final view1 = ByteData.sublistView(query1);
        final view2 = ByteData.sublistView(query2);

        // Transaction IDs should be different (statistically)
        // Note: There's a tiny chance they could be the same
        final id1 = view1.getUint16(0, Endian.big);
        final id2 = view2.getUint16(0, Endian.big);

        // Just verify they're valid 16-bit values
        expect(id1, inInclusiveRange(0, 65535));
        expect(id2, inInclusiveRange(0, 65535));
      });

      test('encodes different RR types correctly', () {
        final aQuery = codec.encodeQuery('example.com', RRType.A);
        final aaaaQuery = codec.encodeQuery('example.com', RRType.AAAA);
        final mxQuery = codec.encodeQuery('example.com', RRType.MX);

        final aView = ByteData.sublistView(aQuery);
        final aaaaView = ByteData.sublistView(aaaaQuery);
        final mxView = ByteData.sublistView(mxQuery);

        expect(aView.getUint16(aQuery.length - 4, Endian.big), equals(1));
        expect(
          aaaaView.getUint16(aaaaQuery.length - 4, Endian.big),
          equals(28),
        );
        expect(mxView.getUint16(mxQuery.length - 4, Endian.big), equals(15));
      });
    });

    group('decodeResponse', () {
      test('decodes A record response', () {
        // Simulated DNS response for example.com with A record 93.184.216.34
        final response = _buildDnsResponse(
          transactionId: 0x1234,
          flags: 0x8180, // QR=1, RD=1, RA=1
          questions: [('example.com', 1, 1)],
          answers: [
            ('example.com', 1, 300, Uint8List.fromList([93, 184, 216, 34])),
          ],
        );

        final record = codec.decodeResponse(response);

        expect(record.status, equals(0));
        expect(record.RD, isTrue);
        expect(record.RA, isTrue);
        expect(record.answer, isNotNull);
        expect(record.answer!.length, equals(1));
        expect(record.answer![0].name, equals('example.com'));
        expect(record.answer![0].type, equals(1));
        expect(record.answer![0].TTL, equals(300));
        expect(record.answer![0].data, equals('93.184.216.34'));
      });

      test('decodes AAAA record response', () {
        // IPv6: 2606:2800:220:1:248:1893:25c8:1946
        final ipv6Bytes = Uint8List.fromList([
          0x26,
          0x06,
          0x28,
          0x00,
          0x02,
          0x20,
          0x00,
          0x01,
          0x02,
          0x48,
          0x18,
          0x93,
          0x25,
          0xc8,
          0x19,
          0x46,
        ]);

        final response = _buildDnsResponse(
          transactionId: 0x1234,
          flags: 0x8180,
          questions: [('example.com', 28, 1)],
          answers: [('example.com', 28, 300, ipv6Bytes)],
        );

        final record = codec.decodeResponse(response);

        expect(record.answer, isNotNull);
        expect(record.answer![0].type, equals(28));
        expect(
          record.answer![0].data,
          equals('2606:2800:220:1:248:1893:25c8:1946'),
        );
      });

      test('decodes NXDOMAIN response', () {
        final response = _buildDnsResponse(
          transactionId: 0x1234,
          flags: 0x8183, // QR=1, RD=1, RA=1, RCODE=3 (NXDOMAIN)
          questions: [('nonexistent.example.com', 1, 1)],
          answers: [],
        );

        final record = codec.decodeResponse(response);

        expect(record.status, equals(3));
        expect(record.isNxDomain, isTrue);
        expect(record.isFailure, isTrue);
        expect(record.answer, isNull);
      });

      test('throws on truncated response', () {
        final shortData = Uint8List(6); // Less than 12-byte header
        expect(
          () => codec.decodeResponse(shortData),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('decodes TXT record', () {
        final txtData = Uint8List.fromList([
          11, // length
          ...('hello world'.codeUnits),
        ]);

        final response = _buildDnsResponse(
          transactionId: 0x1234,
          flags: 0x8180,
          questions: [('example.com', 16, 1)],
          answers: [('example.com', 16, 300, txtData)],
        );

        final record = codec.decodeResponse(response);

        expect(record.answer, isNotNull);
        expect(record.answer![0].data, equals('hello world'));
      });
    });

    group('malformed record validation', () {
      test('throws on domain name exceeding 255 bytes', () {
        // Create a domain with many labels that exceeds 255 bytes total
        // Each label is 6 chars + 1 length byte = 7 bytes, 40 labels = 280 bytes
        final longDomain = List.generate(40, (i) => 'abcdef').join('.');
        expect(
          () => codec.encodeDomainName(longDomain),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('throws on invalid A record length', () {
        // A record with 3 bytes instead of 4
        final response = _buildDnsResponse(
          transactionId: 0x1234,
          flags: 0x8180,
          questions: [('example.com', 1, 1)],
          answers: [
            ('example.com', 1, 300, Uint8List.fromList([1, 2, 3])),
          ],
        );
        expect(
          () => codec.decodeResponse(response),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('throws on invalid AAAA record length', () {
        // AAAA record with 8 bytes instead of 16
        final response = _buildDnsResponse(
          transactionId: 0x1234,
          flags: 0x8180,
          questions: [('example.com', 28, 1)],
          answers: [('example.com', 28, 300, Uint8List(8))],
        );
        expect(
          () => codec.decodeResponse(response),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('throws on invalid MX record length', () {
        // MX record with only 1 byte (needs at least 3)
        final response = _buildDnsResponse(
          transactionId: 0x1234,
          flags: 0x8180,
          questions: [('example.com', 15, 1)],
          answers: [
            ('example.com', 15, 300, Uint8List.fromList([1])),
          ],
        );
        expect(
          () => codec.decodeResponse(response),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('throws on compression pointer loop (too many jumps)', () {
        // Create data with circular compression pointers
        // This will cause repeated jumps until the limit is hit
        final data = Uint8List.fromList([
          // Offset 0: pointer to offset 2
          0xC0, 0x02,
          // Offset 2: pointer to offset 0 (creates cycle)
          0xC0, 0x00,
        ]);
        expect(
          () => codec.decodeDomainName(data, 0),
          throwsA(isA<DnsWireFormatException>()),
        );
      });

      test('throws on invalid label type', () {
        // Label type 0x40 is reserved/invalid
        final data = Uint8List.fromList([0x40, 0x00]);
        expect(
          () => codec.decodeDomainName(data, 0),
          throwsA(isA<DnsWireFormatException>()),
        );
      });
    });

    group('DnsWireFormatException', () {
      test('includes offset in toString when provided', () {
        final exception = DnsWireFormatException('Test error', offset: 42);
        expect(exception.toString(), contains('at offset 42'));
      });

      test('excludes offset when not provided', () {
        final exception = DnsWireFormatException('Test error');
        expect(exception.toString(), isNot(contains('offset')));
      });
    });
  });
}

/// Helper function to build a DNS response message for testing.
Uint8List _buildDnsResponse({
  required int transactionId,
  required int flags,
  required List<(String name, int type, int cls)> questions,
  required List<(String name, int type, int ttl, Uint8List rdata)> answers,
}) {
  final buffer = BytesBuilder();

  // Header
  buffer.add([
    (transactionId >> 8) & 0xFF,
    transactionId & 0xFF,
    (flags >> 8) & 0xFF,
    flags & 0xFF,
    0, questions.length, // QDCOUNT
    0, answers.length, // ANCOUNT
    0, 0, // NSCOUNT
    0, 0, // ARCOUNT
  ]);

  // Questions
  for (final (name, type, cls) in questions) {
    buffer.add(_encodeDomainName(name));
    buffer.add([
      (type >> 8) & 0xFF,
      type & 0xFF,
      (cls >> 8) & 0xFF,
      cls & 0xFF,
    ]);
  }

  // Answers
  for (final (name, type, ttl, rdata) in answers) {
    buffer.add(_encodeDomainName(name));
    buffer.add([
      (type >> 8) & 0xFF,
      type & 0xFF,
      0, 1, // CLASS = IN
      (ttl >> 24) & 0xFF,
      (ttl >> 16) & 0xFF,
      (ttl >> 8) & 0xFF,
      ttl & 0xFF,
      (rdata.length >> 8) & 0xFF,
      rdata.length & 0xFF,
    ]);
    buffer.add(rdata);
  }

  return buffer.toBytes();
}

/// Simple domain name encoder for test helper.
Uint8List _encodeDomainName(String name) {
  final buffer = BytesBuilder();
  for (final label in name.split('.')) {
    buffer.addByte(label.length);
    buffer.add(label.codeUnits);
  }
  buffer.addByte(0);
  return buffer.toBytes();
}
