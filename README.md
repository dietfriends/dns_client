# dns_client

Dart implementation of DNS-over-HTTPS (DoH).

[![CodeFactor](https://www.codefactor.io/repository/github/dietfriends/dns_client/badge)](https://www.codefactor.io/repository/github/dietfriends/dns_client)
[![pub.dev](https://badgen.net/pub/v/dns_client)](https://pub.dev/packages/dns_client)
[![license](https://badgen.net/pub/license/dns_client)](https://github.com/dietfriends/dns_client/blob/master/LICENSE)

[Korean (한국어)](README.ko.md)

## Features

- **Multiple DNS Providers** - Google DNS, Cloudflare DNS, AdGuard DNS, or custom DoH endpoints
- **36 DNS Record Types** - A, AAAA, MX, TXT, SRV, CAA, HTTPS, SVCB, DNSKEY, DS, and more
- **Privacy Protection** - Hide client IP from authoritative nameservers
- **Error Handling** - Detailed exceptions for DNS and HTTP failures
- **Dart 3 Support** - Requires Dart SDK 3.7.0+

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dns_client: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Quick Start

```dart
import 'package:dns_client/dns_client.dart';

void main() async {
  final dns = DnsOverHttps.google();

  final addresses = await dns.lookup('google.com');
  for (final address in addresses) {
    print(address.address);
  }

  dns.close();
}
```

## Usage Examples

### Basic DNS Lookup

```dart
// Using Google DNS
final dns = DnsOverHttps.google();
final addresses = await dns.lookup('example.com');
dns.close();

// Using Cloudflare DNS
final dns = DnsOverHttps.cloudflare();
final addresses = await dns.lookup('example.com');
dns.close();

// Using AdGuard DNS (blocks ads and trackers)
final dns = DnsOverHttps.adguard();
final addresses = await dns.lookup('example.com');
dns.close();

// Using AdGuard DNS (no filtering)
final dns = DnsOverHttps.adguardNonFiltering();
final addresses = await dns.lookup('example.com');
dns.close();

// Using AdGuard DNS (family protection)
final dns = DnsOverHttps.adguardFamily();
final addresses = await dns.lookup('example.com');
dns.close();
```

### Query Specific Record Types

```dart
final dns = DnsOverHttps.google();

// MX records (mail servers)
final mxRecords = await dns.lookupDataByRRType('example.com', RRType.MX);
print('Mail servers: $mxRecords');

// TXT records (SPF, DKIM, domain verification)
final txtRecords = await dns.lookupDataByRRType('example.com', RRType.TXT);
print('TXT records: $txtRecords');

// SRV records (service discovery)
final srvRecords = await dns.lookupDataByRRType(
  '_jmap._tcp.fastmail.com',
  RRType.SRV,
);
print('SRV records: $srvRecords');

// CAA records (certificate authority authorization)
final caaRecords = await dns.lookupDataByRRType('example.com', RRType.CAA);
print('CAA records: $caaRecords');

// HTTPS records (service binding)
final httpsRecords = await dns.lookupDataByRRType('example.com', RRType.HTTPS);
print('HTTPS records: $httpsRecords');

dns.close();
```

### Custom DNS Provider

```dart
final dns = DnsOverHttps(
  'https://dns.quad9.net:5053/dns-query',
  timeout: Duration(seconds: 10),
);

final addresses = await dns.lookup('example.com');
dns.close();
```

### Privacy Settings

Hide your IP address from authoritative nameservers:

```dart
final dns = DnsOverHttps(
  'https://dns.google/resolve',
  maximalPrivacy: true,  // Sets edns_client_subnet=0.0.0.0/0
);

final addresses = await dns.lookup('example.com');
dns.close();
```

### Timeout Configuration

```dart
final dns = DnsOverHttps.google(
  timeout: Duration(seconds: 10),  // Default is 5 seconds
);

final addresses = await dns.lookup('example.com');
dns.close();
```

### Error Handling

```dart
final dns = DnsOverHttps.google();

try {
  final records = await dns.lookupDataByRRType(
    'nonexistent.invalid',
    RRType.A,
  );
} on DnsLookupException catch (e) {
  // DNS-level error (NXDOMAIN, SERVFAIL, etc.)
  print('DNS error: ${e.message}');
  print('Hostname: ${e.hostname}');
  print('Status: ${e.status}');  // 3 = NXDOMAIN, 2 = SERVFAIL
} on DnsHttpException catch (e) {
  // HTTP-level error
  print('HTTP error: ${e.statusCode}');
  print('Message: ${e.message}');
} finally {
  dns.close();
}
```

### Full Response Inspection

Access the complete DNS response for detailed information:

```dart
final dns = DnsOverHttps.google();

final record = await dns.lookupHttpsByRRType('example.com', RRType.MX);

if (record.isSuccess) {
  print('Status: ${record.status}');  // 0 = NOERROR

  for (final answer in record.answer ?? []) {
    print('Name: ${answer.name}');
    print('Type: ${answer.type}');
    print('TTL: ${answer.TTL} seconds');
    print('Data: ${answer.data}');
  }
} else if (record.isNxDomain) {
  print('Domain does not exist');
} else if (record.isServerFailure) {
  print('Server failure');
}

dns.close();
```

## API Reference

### DnsOverHttps

**Constructors:**

| Constructor                                    | Description                       |
| ---------------------------------------------- | --------------------------------- |
| `DnsOverHttps(url, {timeout, maximalPrivacy})` | Custom DoH endpoint               |
| `DnsOverHttps.google({timeout})`               | Google DNS (dns.google)           |
| `DnsOverHttps.cloudflare({timeout})`           | Cloudflare DNS (1.1.1.1)          |
| `DnsOverHttps.adguard({timeout})`              | AdGuard DNS (blocks ads/trackers) |
| `DnsOverHttps.adguardNonFiltering({timeout})`  | AdGuard DNS (no filtering)        |
| `DnsOverHttps.adguardFamily({timeout})`        | AdGuard DNS (family protection)   |

**Methods:**

| Method                                  | Returns                         | Description                      |
| --------------------------------------- | ------------------------------- | -------------------------------- |
| `lookup(hostname)`                      | `Future<List<InternetAddress>>` | Resolve hostname to IP addresses |
| `lookupDataByRRType(hostname, rrType)`  | `Future<List<String>>`          | Query specific record type       |
| `lookupHttpsByRRType(hostname, rrType)` | `Future<DnsRecord>`             | Get full DNS response            |
| `close({force})`                        | `void`                          | Shutdown HTTP client             |

### Supported Record Types (RRType)

| Type       | Constant            | Value | Description                |
| ---------- | ------------------- | ----- | -------------------------- |
| A          | `RRType.A`          | 1     | IPv4 address               |
| NS         | `RRType.NS`         | 2     | Name server                |
| CNAME      | `RRType.CNAME`      | 5     | Canonical name (alias)     |
| SOA        | `RRType.SOA`        | 6     | Start of authority         |
| PTR        | `RRType.PTR`        | 12    | Reverse DNS pointer        |
| HINFO      | `RRType.HINFO`      | 13    | Host information           |
| MX         | `RRType.MX`         | 15    | Mail exchanger             |
| TXT        | `RRType.TXT`        | 16    | Text record                |
| RP         | `RRType.RP`         | 17    | Responsible person         |
| AFSDB      | `RRType.AFSDB`      | 18    | AFS database               |
| KEY        | `RRType.KEY`        | 25    | Security key               |
| AAAA       | `RRType.AAAA`       | 28    | IPv6 address               |
| LOC        | `RRType.LOC`        | 29    | Geographic location        |
| SRV        | `RRType.SRV`        | 33    | Service location           |
| NAPTR      | `RRType.NAPTR`      | 35    | Naming authority pointer   |
| KX         | `RRType.KX`         | 36    | Key exchanger              |
| CERT       | `RRType.CERT`       | 37    | Certificate                |
| APL        | `RRType.APL`        | 42    | Address prefix list        |
| DS         | `RRType.DS`         | 43    | Delegation signer (DNSSEC) |
| IPSECKEY   | `RRType.IPSECKEY`   | 45    | IPsec key                  |
| NSEC       | `RRType.NSEC`       | 47    | Next secure (DNSSEC)       |
| DNSKEY     | `RRType.DNSKEY`     | 48    | DNS key (DNSSEC)           |
| DHCID      | `RRType.DHCID`      | 49    | DHCP identifier            |
| NSEC3      | `RRType.NSEC3`      | 50    | Hashed denial (DNSSEC)     |
| NSEC3PARAM | `RRType.NSEC3PARAM` | 51    | NSEC3 parameters           |
| SMIMEA     | `RRType.SMIMEA`     | 53    | S/MIME certificate         |
| HIP        | `RRType.HIP`        | 55    | Host identity protocol     |
| CDS        | `RRType.CDS`        | 59    | Child DS (DNSSEC)          |
| SVCB       | `RRType.SVCB`       | 64    | Service binding            |
| HTTPS      | `RRType.HTTPS`      | 65    | HTTPS binding              |
| EUI48      | `RRType.EUI48`      | 108   | MAC address (48-bit)       |
| EUI64      | `RRType.EUI64`      | 109   | MAC address (64-bit)       |
| URI        | `RRType.URI`        | 256   | URI mapping                |
| CAA        | `RRType.CAA`        | 257   | CA authorization           |
| TA         | `RRType.TA`         | 32768 | Trust anchor               |
| DLV        | `RRType.DLV`        | 32769 | DNSSEC lookaside           |

**Custom record types:**

```dart
// TLSA record (type 52)
final tlsaType = RRType('TLSA', 52);
final tlsaRecords = await dns.lookupDataByRRType('example.com', tlsaType);
```

### Response Classes

**DnsRecord:**

| Property          | Type            | Description         |
| ----------------- | --------------- | ------------------- |
| `status`          | `int`           | DNS response code   |
| `answer`          | `List<Answer>?` | DNS answers         |
| `isSuccess`       | `bool`          | True if status == 0 |
| `isFailure`       | `bool`          | True if status != 0 |
| `isNxDomain`      | `bool`          | True if status == 3 |
| `isServerFailure` | `bool`          | True if status == 2 |

**Answer:**

| Property | Type     | Description            |
| -------- | -------- | ---------------------- |
| `name`   | `String` | Domain name            |
| `type`   | `int`    | Record type code       |
| `TTL`    | `int`    | Time to live (seconds) |
| `data`   | `String` | Record data            |

### Exceptions

**DnsLookupException** - Thrown when DNS query fails:

- `hostname` - The queried hostname
- `status` - DNS status code (2=SERVFAIL, 3=NXDOMAIN, etc.)
- `message` - Error description

**DnsHttpException** - Thrown when HTTP request fails:

- `statusCode` - HTTP status code
- `message` - Error description

## Requirements

- Dart SDK: `>=3.7.0 <4.0.0`

## License

See [LICENSE](LICENSE) file.

## Contributing

Please file feature requests and bugs at the [issue tracker](https://github.com/dietfriends/dns_client/issues).
