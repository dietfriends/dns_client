import 'dart:math';
import 'dart:typed_data';

import 'package:dns_client/src/dns_record.dart';
import 'package:dns_client/src/rr_type.dart';

/// Exception thrown when DNS wire format parsing fails.
class DnsWireFormatException implements Exception {
  /// Human-readable error message.
  final String message;

  /// Byte offset where parsing failed (if applicable).
  final int? offset;

  DnsWireFormatException(this.message, {this.offset});

  @override
  String toString() {
    if (offset != null) {
      return 'DnsWireFormatException: $message (at offset $offset)';
    }
    return 'DnsWireFormatException: $message';
  }
}

/// Encodes and decodes DNS messages in wire format (RFC 1035).
///
/// The wire format is a binary format used by DNS over UDP, TCP, and DoH.
/// It consists of a 12-byte header followed by question and answer sections.
///
/// Example:
/// ```dart
/// final codec = DnsWireCodec();
/// final query = codec.encodeQuery('example.com', RRType.A);
/// final response = codec.decodeResponse(responseBytes);
/// ```
class DnsWireCodec {
  /// Size of DNS header in bytes.
  static const int headerSize = 12;

  final Random _random;

  /// Creates a new DNS wire codec.
  ///
  /// Optionally accepts a [Random] instance for generating transaction IDs.
  DnsWireCodec({Random? random}) : _random = random ?? Random();

  /// Encodes a domain name in DNS wire format.
  ///
  /// Domain names are encoded as a sequence of labels, where each label is
  /// prefixed by its length byte. The encoding ends with a zero-length label.
  ///
  /// Example: "www.example.com" becomes `\x03www\x07example\x03com\x00`
  ///
  /// Throws [DnsWireFormatException] if the domain name is invalid.
  Uint8List encodeDomainName(String name) {
    if (name.isEmpty) {
      return Uint8List.fromList([0]);
    }

    // Remove trailing dot if present
    if (name.endsWith('.')) {
      name = name.substring(0, name.length - 1);
    }

    final labels = name.split('.');
    final buffer = BytesBuilder();

    for (final label in labels) {
      if (label.isEmpty) {
        throw DnsWireFormatException('Empty label in domain name: $name');
      }
      if (label.length > 63) {
        throw DnsWireFormatException('Label exceeds 63 bytes: $label');
      }

      buffer.addByte(label.length);
      buffer.add(label.codeUnits);
    }

    // Terminating zero-length label
    buffer.addByte(0);

    final result = buffer.toBytes();
    if (result.length > 255) {
      throw DnsWireFormatException('Domain name exceeds 255 bytes: $name');
    }

    return result;
  }

  /// Decodes a domain name from DNS wire format.
  ///
  /// Handles compression pointers (RFC 1035 section 4.1.4) which allow
  /// previously occurring domain names to be referenced by offset.
  ///
  /// Returns a tuple of (decoded name, bytes consumed from current position).
  /// The bytes consumed only counts bytes at the current position, not
  /// bytes read via compression pointers.
  ///
  /// Throws [DnsWireFormatException] if the data is malformed.
  (String name, int bytesRead) decodeDomainName(Uint8List data, int offset) {
    if (offset >= data.length) {
      throw DnsWireFormatException('Offset out of bounds', offset: offset);
    }

    final parts = <String>[];
    var pos = offset;
    var bytesRead = 0;
    var jumped = false;
    var jumpCount = 0;

    while (pos < data.length) {
      final length = data[pos];

      if (length == 0) {
        // End of domain name
        if (!jumped) {
          bytesRead = pos - offset + 1;
        }
        break;
      }

      if ((length & 0xC0) == 0xC0) {
        // Compression pointer (2 bytes)
        if (pos + 1 >= data.length) {
          throw DnsWireFormatException(
            'Truncated compression pointer',
            offset: pos,
          );
        }

        if (!jumped) {
          bytesRead = pos - offset + 2;
        }

        // Calculate pointer offset
        final pointerOffset = ((length & 0x3F) << 8) | data[pos + 1];

        if (pointerOffset >= offset) {
          throw DnsWireFormatException(
            'Forward compression pointer not allowed',
            offset: pos,
          );
        }

        // Prevent infinite loops
        jumpCount++;
        if (jumpCount > 10) {
          throw DnsWireFormatException(
            'Too many compression pointer jumps',
            offset: pos,
          );
        }

        pos = pointerOffset;
        jumped = true;
        continue;
      }

      if ((length & 0xC0) != 0) {
        throw DnsWireFormatException(
          'Invalid label type: 0x${length.toRadixString(16)}',
          offset: pos,
        );
      }

      // Regular label
      if (pos + 1 + length > data.length) {
        throw DnsWireFormatException('Label extends beyond data', offset: pos);
      }

      final label = String.fromCharCodes(data, pos + 1, pos + 1 + length);
      parts.add(label);
      pos += 1 + length;
    }

    if (bytesRead == 0 && !jumped) {
      throw DnsWireFormatException('Unterminated domain name', offset: offset);
    }

    return (parts.join('.'), bytesRead);
  }

  /// Generates a random 16-bit transaction ID.
  int generateTransactionId() => _random.nextInt(65536);

  /// Encodes a DNS query message in wire format.
  ///
  /// Creates a binary DNS query for [hostname] with the specified [rrType].
  /// The query will have RD (Recursion Desired) flag set.
  ///
  /// Optionally, a specific [transactionId] can be provided. If not provided,
  /// a random ID will be generated.
  ///
  /// Returns the binary message ready for transmission via DoH POST.
  ///
  /// Example:
  /// ```dart
  /// final codec = DnsWireCodec();
  /// final query = codec.encodeQuery('example.com', RRType.A);
  /// // Send query via HTTP POST with Content-Type: application/dns-message
  /// ```
  ///
  /// Throws [DnsWireFormatException] if the hostname is invalid.
  Uint8List encodeQuery(String hostname, RRType rrType, {int? transactionId}) {
    final id = transactionId ?? generateTransactionId();
    final nameBytes = encodeDomainName(hostname);

    // Total size: header (12) + name + type (2) + class (2)
    final totalSize = headerSize + nameBytes.length + 4;
    final buffer = ByteData(totalSize);

    // Header section (12 bytes)
    // ID - 16 bits
    buffer.setUint16(0, id, Endian.big);

    // Flags - 16 bits
    // QR=0 (query), Opcode=0 (standard query), AA=0, TC=0, RD=1
    // RA=0, Z=0, AD=0, CD=0, RCODE=0
    const flags = 0x0100; // Only RD (Recursion Desired) set
    buffer.setUint16(2, flags, Endian.big);

    // QDCOUNT - 16 bits (1 question)
    buffer.setUint16(4, 1, Endian.big);

    // ANCOUNT - 16 bits (0 answers)
    buffer.setUint16(6, 0, Endian.big);

    // NSCOUNT - 16 bits (0 authority records)
    buffer.setUint16(8, 0, Endian.big);

    // ARCOUNT - 16 bits (0 additional records)
    buffer.setUint16(10, 0, Endian.big);

    // Question section
    final data = buffer.buffer.asUint8List();

    // Copy domain name
    for (var i = 0; i < nameBytes.length; i++) {
      data[headerSize + i] = nameBytes[i];
    }

    // QTYPE - 16 bits
    final qtypeOffset = headerSize + nameBytes.length;
    buffer.setUint16(qtypeOffset, rrType.value, Endian.big);

    // QCLASS - 16 bits (1 = IN for Internet)
    buffer.setUint16(qtypeOffset + 2, 1, Endian.big);

    return data;
  }

  /// Decodes a DNS response message from wire format.
  ///
  /// Parses the binary response [data] and returns a [DnsRecord] object
  /// that matches the structure used by JSON-based DoH responses.
  ///
  /// Throws [DnsWireFormatException] if the response is malformed.
  DnsRecord decodeResponse(Uint8List data) {
    if (data.length < headerSize) {
      throw DnsWireFormatException(
        'Response too short: ${data.length} bytes (minimum: $headerSize)',
        offset: 0,
      );
    }

    final view = ByteData.sublistView(data);

    // Parse header flags
    final flags = view.getUint16(2, Endian.big);
    final rcode = flags & 0x0F;
    final tc = (flags >> 9) & 0x01 == 1;
    final rd = (flags >> 8) & 0x01 == 1;
    final ra = (flags >> 7) & 0x01 == 1;
    final ad = (flags >> 5) & 0x01 == 1;
    final cd = (flags >> 4) & 0x01 == 1;

    // Get counts
    final qdcount = view.getUint16(4, Endian.big);
    final ancount = view.getUint16(6, Endian.big);

    // Skip question section
    var offset = headerSize;
    offset = _skipQuestionSection(data, offset, qdcount);

    // Parse answer section
    final answers = <Answer>[];
    for (var i = 0; i < ancount; i++) {
      final (answer, newOffset) = _parseResourceRecord(data, offset);
      answers.add(answer);
      offset = newOffset;
    }

    return DnsRecord(
      rcode,
      tc,
      rd,
      ra,
      ad,
      cd,
      null, // ednsClientSubnet not available in basic wire format
      answers.isEmpty ? null : answers,
      null, // comment
    );
  }

  /// Skips the question section in a DNS message.
  int _skipQuestionSection(Uint8List data, int offset, int count) {
    for (var i = 0; i < count; i++) {
      // Skip QNAME
      final (_, bytesRead) = decodeDomainName(data, offset);
      offset += bytesRead;

      // Skip QTYPE (2) + QCLASS (2)
      offset += 4;

      if (offset > data.length) {
        throw DnsWireFormatException(
          'Question section extends beyond data',
          offset: offset,
        );
      }
    }
    return offset;
  }

  /// Parses a resource record and returns the Answer and new offset.
  (Answer, int) _parseResourceRecord(Uint8List data, int offset) {
    if (offset >= data.length) {
      throw DnsWireFormatException('Unexpected end of data', offset: offset);
    }

    // Parse NAME
    final (name, nameBytes) = decodeDomainName(data, offset);
    offset += nameBytes;

    if (offset + 10 > data.length) {
      throw DnsWireFormatException(
        'Resource record header extends beyond data',
        offset: offset,
      );
    }

    final view = ByteData.sublistView(data);

    // TYPE (2 bytes)
    final type = view.getUint16(offset, Endian.big);
    offset += 2;

    // CLASS (2 bytes) - skip
    offset += 2;

    // TTL (4 bytes)
    final ttl = view.getUint32(offset, Endian.big);
    offset += 4;

    // RDLENGTH (2 bytes)
    final rdlength = view.getUint16(offset, Endian.big);
    offset += 2;

    if (offset + rdlength > data.length) {
      throw DnsWireFormatException('RDATA extends beyond data', offset: offset);
    }

    // Parse RDATA
    final rdata = _decodeRData(data, offset, rdlength, type);
    offset += rdlength;

    return (Answer(name, type, ttl, rdata), offset);
  }

  /// Decodes RDATA based on the record type.
  String _decodeRData(Uint8List data, int offset, int rdlength, int type) {
    if (rdlength == 0) return '';

    switch (type) {
      case 1: // A record (IPv4)
        if (rdlength != 4) {
          throw DnsWireFormatException(
            'Invalid A record length: $rdlength (expected 4)',
            offset: offset,
          );
        }
        return '${data[offset]}.${data[offset + 1]}.'
            '${data[offset + 2]}.${data[offset + 3]}';

      case 28: // AAAA record (IPv6)
        if (rdlength != 16) {
          throw DnsWireFormatException(
            'Invalid AAAA record length: $rdlength (expected 16)',
            offset: offset,
          );
        }
        return _formatIPv6(data, offset);

      case 2: // NS
      case 5: // CNAME
      case 12: // PTR
        final (name, _) = decodeDomainName(data, offset);
        return name;

      case 15: // MX
        final view = ByteData.sublistView(data);
        final preference = view.getUint16(offset, Endian.big);
        final (exchange, _) = decodeDomainName(data, offset + 2);
        return '$preference $exchange';

      case 16: // TXT
        return _decodeTxtRData(data, offset, rdlength);

      case 33: // SRV
        return _decodeSrvRData(data, offset, rdlength);

      case 6: // SOA
        return _decodeSoaRData(data, offset, rdlength);

      default:
        // Return hex-encoded data for unknown types
        return _hexEncode(data, offset, rdlength);
    }
  }

  /// Formats IPv6 address from 16 bytes.
  String _formatIPv6(Uint8List data, int offset) {
    final groups = <String>[];
    for (var i = 0; i < 16; i += 2) {
      final value = (data[offset + i] << 8) | data[offset + i + 1];
      groups.add(value.toRadixString(16));
    }
    return groups.join(':');
  }

  /// Decodes TXT record RDATA.
  String _decodeTxtRData(Uint8List data, int offset, int rdlength) {
    final parts = <String>[];
    var pos = offset;
    final end = offset + rdlength;

    while (pos < end) {
      final length = data[pos];
      pos++;

      if (pos + length > end) {
        throw DnsWireFormatException(
          'TXT string extends beyond RDATA',
          offset: pos,
        );
      }

      parts.add(String.fromCharCodes(data, pos, pos + length));
      pos += length;
    }

    return parts.join('');
  }

  /// Decodes SRV record RDATA.
  String _decodeSrvRData(Uint8List data, int offset, int rdlength) {
    // SRV: 2 bytes priority + 2 bytes weight + 2 bytes port + target name
    if (rdlength < 7) {
      throw DnsWireFormatException(
        'Invalid SRV record length: $rdlength (minimum: 7)',
        offset: offset,
      );
    }
    final view = ByteData.sublistView(data);
    final priority = view.getUint16(offset, Endian.big);
    final weight = view.getUint16(offset + 2, Endian.big);
    final port = view.getUint16(offset + 4, Endian.big);
    final (target, _) = decodeDomainName(data, offset + 6);
    return '$priority $weight $port $target';
  }

  /// Decodes SOA record RDATA.
  String _decodeSoaRData(Uint8List data, int offset, int rdlength) {
    // SOA: mname + rname + 5x4 bytes (serial, refresh, retry, expire, minimum)
    if (rdlength < 22) {
      throw DnsWireFormatException(
        'Invalid SOA record length: $rdlength (minimum: 22)',
        offset: offset,
      );
    }
    final (mname, mnameBytes) = decodeDomainName(data, offset);
    offset += mnameBytes;
    final (rname, rnameBytes) = decodeDomainName(data, offset);
    offset += rnameBytes;

    if (offset + 20 > data.length) {
      throw DnsWireFormatException(
        'SOA record extends beyond data',
        offset: offset,
      );
    }

    final view = ByteData.sublistView(data);
    final serial = view.getUint32(offset, Endian.big);
    final refresh = view.getUint32(offset + 4, Endian.big);
    final retry = view.getUint32(offset + 8, Endian.big);
    final expire = view.getUint32(offset + 12, Endian.big);
    final minimum = view.getUint32(offset + 16, Endian.big);

    return '$mname $rname $serial $refresh $retry $expire $minimum';
  }

  /// Hex-encodes a portion of data.
  String _hexEncode(Uint8List data, int offset, int length) {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(data[offset + i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
