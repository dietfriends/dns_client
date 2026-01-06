# Specification: Add OpenDNS Provider Support

## Overview

Add OpenDNS as a DNS-over-HTTPS (DoH) provider using wire format (RFC 8484).

## Problem Statement

OpenDNS (Cisco-owned) is a widely-used enterprise-grade DNS service.
Users who want OpenDNS's reliability and FamilyShield filtering
must manually configure the endpoint URL.

## Solution

Add factory constructors for OpenDNS variants to `DnsOverHttpsWire` class.

## Functional Requirements

### FR-1: OpenDNS Standard

- Factory: `DnsOverHttpsWire.opendns({Duration? timeout})`
- Endpoint: `https://doh.opendns.com/dns-query`
- Behavior: Standard DNS resolution

### FR-2: OpenDNS FamilyShield

- Factory: `DnsOverHttpsWire.opendnsFamilyShield({Duration? timeout})`
- Endpoint: `https://doh.familyshield.opendns.com/dns-query`
- Behavior: Blocks adult content automatically

## Non-Functional Requirements

### NFR-1: API Compatibility

All existing `DnsClient` methods must work with OpenDNS:

- `lookup(hostname)` - IPv4 lookup
- `lookupDataByRRType(hostname, rrType)` - Any record type lookup

### NFR-2: Protocol Requirement

OpenDNS only supports wire format (RFC 8484), NOT JSON format.
Must use `DnsOverHttpsWire` class with HTTP/2.

### NFR-3: Performance

Response times should be comparable to existing wire format providers (Quad9).

## Technical Notes

### Wire Format Requirement

OpenDNS follows RFC 8484 and accepts DoH using both GET and POST methods
containing queries in DNS Wire Format. JSON format is NOT supported.

### Known Endpoints

| Variant      | Endpoint                                         | Features               |
| ------------ | ------------------------------------------------ | ---------------------- |
| Standard     | `https://doh.opendns.com/dns-query`              | Enterprise-grade DNS   |
| FamilyShield | `https://doh.familyshield.opendns.com/dns-query` | Adult content blocking |

## Out of Scope

- DNS-over-TLS (DoT) support
- JSON format support (not available)
- Custom filtering configurations

## Success Criteria

1. Both factory constructors work correctly
2. Tests pass for basic lookups
3. ROADMAP.md updated (move to wire format section)
4. No breaking changes to existing API
