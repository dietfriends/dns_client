# Spec 003: NextDNS Provider

## Summary

Add NextDNS DNS-over-HTTPS provider support to the dns_client library.

## Problem Statement

NextDNS is a popular privacy-focused DNS provider pre-configured in major browsers
(Chrome, Firefox). Users need an easy way to use NextDNS with this library,
including support for personal configurations.

## Requirements

### Functional Requirements

1. **Factory Constructors**
   - `DnsOverHttps.nextdns({String? configId, Duration? timeout})` - Standard endpoint
   - `DnsOverHttps.nextdnsAnycast({String? configId, Duration? timeout})` - Anycast endpoint

2. **Endpoints**
   - Standard: `https://dns.nextdns.io/dns-query` (without configId)
   - Standard with config: `https://dns.nextdns.io/{configId}` (with configId)
   - Anycast: `https://anycast.dns.nextdns.io/dns-query` (without configId)
   - Anycast with config: `https://anycast.dns.nextdns.io/{configId}` (with configId)

3. **Parameters**
   - `configId` (optional): NextDNS configuration ID for personalized filtering
   - `timeout` (optional): Request timeout, defaults to 5000ms

### Non-Functional Requirements

1. Follow existing DnsOverHttps factory constructor patterns
2. JSON-based DoH format (application/dns-json)
3. Compatible with existing DnsClient interface

## API Design

```dart
/// NextDNS DNS-over-HTTPS.
///
/// [configId] is optional. When provided, uses personalized filtering.
/// Without configId, uses NextDNS public resolver.
///
/// [NextDNS documentation](https://nextdns.io/)
factory DnsOverHttps.nextdns({String? configId, Duration? timeout}) {
  final url = configId != null
    ? 'https://dns.nextdns.io/$configId'
    : 'https://dns.nextdns.io/dns-query';
  return DnsOverHttps(url, timeout: timeout);
}

/// NextDNS Anycast endpoint for optimal routing.
///
/// Uses NextDNS anycast infrastructure for lower latency.
///
/// [NextDNS documentation](https://nextdns.io/)
factory DnsOverHttps.nextdnsAnycast({String? configId, Duration? timeout}) {
  final url = configId != null
    ? 'https://anycast.dns.nextdns.io/$configId'
    : 'https://anycast.dns.nextdns.io/dns-query';
  return DnsOverHttps(url, timeout: timeout);
}
```

## Test Cases

1. Basic lookup without configId
2. Basic lookup with configId (if user provides test config)
3. Anycast endpoint lookup
4. Close behavior test
5. CNAME resolution test

## Out of Scope

- NextDNS account management
- Analytics or logging features
- Custom DNS rewrites (handled by NextDNS config)

## References

- [NextDNS](https://nextdns.io/)
- [NextDNS Setup Guide](https://my.nextdns.io/)
- [ROADMAP.md](../../docs/ROADMAP.md)
