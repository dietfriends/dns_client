# Specification: Add AdGuard DNS Provider Support

## Overview

Add AdGuard DNS as a new DNS-over-HTTPS (DoH) provider to the dns_client package.

## Problem Statement

Currently, the package only supports Google DNS and Cloudflare DNS.
Users who want to use AdGuard DNS for its ad-blocking and privacy features
must manually configure the URL.

## Solution

Add factory constructors for AdGuard DNS variants following the existing pattern.

## Functional Requirements

### FR-1: AdGuard DNS Default

- Factory: `DnsOverHttps.adguard({Duration? timeout})`
- Endpoint: `https://dns.adguard-dns.com/resolve`
- Behavior: Blocks ads and trackers

### FR-2: AdGuard DNS Non-filtering

- Factory: `DnsOverHttps.adguardNonFiltering({Duration? timeout})`
- Endpoint: `https://unfiltered.adguard-dns.com/resolve`
- Behavior: No filtering, pure DNS resolution

### FR-3: AdGuard DNS Family

- Factory: `DnsOverHttps.adguardFamily({Duration? timeout})`
- Endpoint: `https://family.adguard-dns.com/resolve`
- Behavior: Blocks adult content in addition to ads

## Non-Functional Requirements

### NFR-1: API Compatibility

All existing `DnsClient` methods must work with AdGuard DNS:

- `lookup(hostname)` - IPv4 lookup
- `lookupDataByRRType(hostname, rrType)` - Any record type lookup

### NFR-2: Performance

Response times should be comparable to existing providers.

### NFR-3: Privacy

The `maximalPrivacy` option should work (though AdGuard may not fully support `edns_client_subnet`).

## Technical Notes

### JSON API Format

AdGuard DNS supports Google-compatible JSON format via `/resolve` endpoint:

- Request: `https://dns.adguard-dns.com/resolve?name=example.com&type=A`
- Response: JSON with `Status`, `Question`, `Answer` fields

### Known Limitations

- AdGuard DNS does not return `edns_client_subnet` in JSON responses
- Uses `/resolve` endpoint (not `/dns-query`)

## Out of Scope

- DNS-over-TLS (DoT) support
- DNS-over-QUIC (DoQ) support
- Wire format (RFC 8484 binary) support

## Success Criteria

1. All three factory constructors work correctly
2. Tests pass for basic lookups
3. README documentation updated
4. No breaking changes to existing API
