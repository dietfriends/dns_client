# Spec 002: DNS Wire Format Support + Quad9 Provider

## Summary

Add DNS wire format (RFC 1035/8484) support to the dns_client package to enable providers
that don't support JSON format, starting with Quad9.

## Problem Statement

The current dns_client package only supports JSON-based DoH (DNS-over-HTTPS) using the
`application/dns-json` content type. This limits the package to providers that offer
JSON APIs (Google, Cloudflare, AdGuard).

Several major DNS providers only support the standard DNS wire format:

- **Quad9** - Retired JSON service on May 5, 2025
- **OpenDNS** - No JSON support
- **CleanBrowsing** - No JSON support

## Goals

1. Add DNS wire format encoder/decoder (RFC 1035)
2. Add DoH wire format support (RFC 8484)
3. Add Quad9 DNS provider with 3 variants
4. Maintain 100% backward compatibility with existing JSON API
5. Support HTTP/2 (required by Quad9)

## Non-Goals

- UDP/TCP DNS transport (out of scope)
- AXFR zone transfers
- DNSSEC validation logic
- DNS message signing

## Technical Requirements

### Wire Format Components

1. **DNS Message Encoder** - Create binary DNS query messages
   - 12-byte header (ID, flags, counts)
   - Question section with QNAME encoding (label-length format)
   - Support for all existing RRType values

2. **DNS Message Decoder** - Parse binary DNS response messages
   - Header parsing (extract status, flags, counts)
   - Question section parsing
   - Answer/Authority/Additional section parsing
   - DNS name compression support (pointer handling)
   - RDATA parsing for common types (A, AAAA, CNAME, MX, TXT, SRV, etc.)

3. **DoH Transport**
   - Support both GET (base64url encoded) and POST (binary body) methods
   - Content-Type: `application/dns-message`
   - Accept: `application/dns-message`

### Quad9 Provider

| Variant            | Endpoint                            | Features                  |
| ------------------ | ----------------------------------- | ------------------------- |
| `quad9()`          | `https://dns.quad9.net/dns-query`   | Malware blocking + DNSSEC |
| `quad9Ecs()`       | `https://dns11.quad9.net/dns-query` | + EDNS Client Subnet      |
| `quad9Unsecured()` | `https://dns10.quad9.net/dns-query` | No blocking, no DNSSEC    |

### API Design

```dart
// Option A: Separate class for wire format
class DnsOverHttpsWire extends DnsClient {
  factory DnsOverHttpsWire.quad9({Duration? timeout});
  factory DnsOverHttpsWire.quad9Ecs({Duration? timeout});
  factory DnsOverHttpsWire.quad9Unsecured({Duration? timeout});
}

// Option B: Add to existing class with format parameter
class DnsOverHttps extends DnsClient {
  DnsOverHttps(this.url, {this.format = DnsFormat.json, ...});

  factory DnsOverHttps.quad9({Duration? timeout}) =>
    DnsOverHttps('https://dns.quad9.net/dns-query', format: DnsFormat.wire);
}

// Option C: Internal format detection based on provider
// JSON providers: dns.google, cloudflare-dns.com, dns.adguard-dns.com
// Wire providers: dns.quad9.net, doh.opendns.com
```

## Test Requirements

1. Unit tests for wire format encoder/decoder
2. Integration tests for Quad9 provider (all 3 variants)
3. Round-trip tests (encode → send → decode → verify)
4. Name compression handling tests

## Dependencies

- No new package dependencies
- Uses `dart:typed_data` (ByteData, Uint8List)
- Uses existing `dart:io` HttpClient

## Risks & Mitigations

| Risk                   | Mitigation                                       |
| ---------------------- | ------------------------------------------------ |
| HTTP/2 requirement     | Dart's HttpClient supports HTTP/2 by default     |
| Wire format complexity | Well-documented RFC, comprehensive test coverage |
| Breaking changes       | New classes/methods only, existing API unchanged |

## Success Criteria

- [ ] Wire format encoder/decoder passes unit tests
- [ ] Quad9 lookups return correct DNS records
- [ ] All existing tests continue to pass
- [ ] No breaking changes to public API
- [ ] Documentation updated with Quad9 examples

## Decisions

1. **API Design**: Option A - Separate `DnsOverHttpsWire` class
   - Clean separation of concerns
   - No changes to existing `DnsOverHttps` class
   - Explicit wire format usage

2. **HTTP Method**: POST as default
   - Simpler implementation (no base64url encoding)
   - More efficient (smaller request size)
   - Quad9/Cloudflare both support POST

3. **Error Handling**: Extend existing exceptions
   - `DnsLookupException` for DNS-level errors (reuse)
   - `DnsHttpException` for HTTP errors (reuse)
   - Add `DnsWireFormatException` for parsing errors (new)
