# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Dart implementation of DNS-over-HTTPS (DoH) supporting multiple providers:
Google, Cloudflare, AdGuard (JSON format) and Quad9 (wire format with HTTP/2).
Published to pub.dev as `dns_client`. SDK requirement: `>=3.7.0 <4.0.0`.

## Common Commands

```bash
# Install dependencies
dart pub get

# Run all tests
dart test

# Run a single test file
dart test test/dns_client_test.dart

# Regenerate freezed/json_serializable code
dart run build_runner build --delete-conflicting-outputs

# Analyze code
dart analyze

# Format code
dart format .

# Lint and format markdown
npm run lint:fix
npm run format
```

## Architecture

```text
lib/
├── dns_client.dart              # Library entry point (exports all public APIs)
└── src/
    ├── dns_client.dart          # Abstract DnsClient interface
    ├── dns_over_https.dart      # JSON-based DoH (Google, Cloudflare, AdGuard)
    ├── dns_over_https_wire.dart # Wire format DoH with HTTP/2 (Quad9)
    ├── dns_wire_codec.dart      # DNS wire format encoder/decoder (RFC 1035)
    ├── dns_record.dart          # Freezed data classes + exceptions
    └── rr_type.dart             # DNS Resource Record types (30+ types)
```

### Key Components

- **DnsClient** - Abstract interface with `lookup(hostname)` and `lookupDataByRRType(hostname, rrType)` methods
- **DnsOverHttps** - JSON-based implementation with factory constructors:
  - `DnsOverHttps.google()` - Google DNS (dns.google/resolve)
  - `DnsOverHttps.cloudflare()` - Cloudflare DNS (cloudflare-dns.com/dns-query)
  - `DnsOverHttps.adguard()` - AdGuard DNS (dns.adguard-dns.com/resolve)
- **DnsOverHttpsWire** - Wire format implementation using HTTP/2:
  - `DnsOverHttpsWire.quad9()` - Quad9 DNS with malware blocking
  - `DnsOverHttpsWire.quad9Ecs()` - Quad9 with EDNS Client Subnet
  - `DnsOverHttpsWire.quad9Unsecured()` - Quad9 without filtering
- **DnsWireCodec** - Encodes/decodes DNS wire format (RFC 1035/8484)
- **DnsRecord** - Freezed data class for DNS responses with helper getters (`isSuccess`, `isFailure`, `isNxDomain`)
- **RRType** - DNS Resource Record types (A, AAAA, MX, SRV, TXT, CNAME, etc.) with 30+ predefined types

### Exceptions

- **DnsLookupException** - DNS query failure (SERVFAIL, NXDOMAIN, etc.)
- **DnsHttpException** - HTTP request failure (non-200 status)
- **DnsWireFormatException** - Wire format parsing failure (malformed response)

## Code Generation

The `dns_record.dart` uses freezed and json_serializable. Generated files (`*.freezed.dart`, `*.g.dart`)
must be regenerated after modifying data classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Code Style

- Uses `package:lints/recommended.yaml` with strict-casts and strict-raw-types enabled
- DNS field names (TC, RD, RA, AD, CD, TTL) follow RFC standard naming conventions
- Generated files (`*.freezed.dart`, `*.g.dart`) are excluded from analysis

## Development Setup

Pre-commit hooks are configured with husky and lint-staged:

- **Dart files**: `dart format` + `dart analyze --fatal-warnings`
- **Markdown files**: `dprint fmt` + `markdownlint-cli2 --fix`

Install hooks: `npm install`

## References

- [DNS Providers - AdGuard DNS Knowledge Base](https://adguard-dns.io/kb/general/dns-providers/)
