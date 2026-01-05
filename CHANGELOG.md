## 1.0.0

- Updated `DnsClient` interface:
    - `lookup` method now supports optional `DnsRecordType` parameter to filter results.
    - Added `lookupRecord` method to fetch full DNS records with specified type.
    - Added `close` method with `force` parameter to control client shutdown behavior.

- `DnsOverHttps` implementation:
    - Refactored `lookup` to support filtering by DNS record type.
    - Added `lookupRecord` method to perform DNS-over-HTTPS queries returning full `DnsRecord`.
    - Improved HTTP client initialization and request construction.
    - Added `close` method override with `force` option.

- `dns_record.dart`:
    - Migrated to freezed v3 with named parameters, required fields, and improved JSON handling.
        - Redesigned `DnsRecord`, `Question`, and `Answer` classes with detailed fields and JSON serialization.
    - Added `DnsRecordType` enum with common DNS record types and utilities.
    - Added extension on `Answer` to get typed DNS record type.
    - Improved JSON serialization/deserialization with null safety and type conversions.

- Example usage updated:
    - Demonstrates querying different DNS record types (A, MX).
    - Uses enhanced `lookup` and `lookupRecord` methods.

- Tests:
    - Added comprehensive tests for Google and Cloudflare DoH clients.
    - Tests cover lookup of A, AAAA, CNAME, MX records.
    - Added test for client close behavior preventing further lookups.

- Dependency updates:
    - Dart SDK constraint updated to `>=3.8.0 <4.0.0`.
    - Updated dependencies:
        - `http` ^1.6.0
        - `freezed_annotation` ^3.1.0
        - `json_annotation` ^4.9.0
    - Updated dev_dependencies:
        - `lints` ^5.1.1
        - `test` ^1.28.0
        - `json_serializable` ^6.11.3
        - `build_runner` ^2.10.4
        - `freezed` ^3.2.4

- Analysis options:
    - Replaced `pedantic` with `lints/recommended.yaml`.
    - Added ignore for `invalid_annotation_target` error.

## 0.2.1

- use `HttpClient` instead of `http`

## 0.2.0

- Migrated to null-safety

## 0.1.0+1

- fix: answer is not always ip address

## 0.1.0

- Initial version, created by Stagehand
- cloudflare, Google implementation