# dns_client

Dart로 구현한 DNS-over-HTTPS (DoH) 라이브러리입니다.

[![CodeFactor](https://www.codefactor.io/repository/github/dietfriends/dns_client/badge)](https://www.codefactor.io/repository/github/dietfriends/dns_client)
[![pub.dev](https://badgen.net/pub/v/dns_client)](https://pub.dev/packages/dns_client)
[![license](https://badgen.net/pub/license/dns_client)](https://github.com/dietfriends/dns_client/blob/master/LICENSE)

[English](README.md)

## 주요 기능

- **다양한 DNS 제공자** - Google DNS, Cloudflare DNS 또는 사용자 정의 DoH 엔드포인트 지원
- **35개 DNS 레코드 타입** - A, AAAA, MX, TXT, SRV, CAA, HTTPS, SVCB, DNSKEY 등
- **개인정보 보호** - 권한 있는 네임서버로부터 클라이언트 IP 숨김
- **에러 처리** - DNS 및 HTTP 오류에 대한 상세한 예외 처리
- **Dart 3 지원** - Dart SDK 3.7.0 이상 필요

## 설치

`pubspec.yaml`에 추가:

```yaml
dependencies:
  dns_client: ^1.0.0
```

그런 다음 실행:

```bash
dart pub get
```

## 빠른 시작

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

## 사용 예제

### 기본 DNS 조회

```dart
// Google DNS 사용
final dns = DnsOverHttps.google();
final addresses = await dns.lookup('example.com');
dns.close();

// Cloudflare DNS 사용
final dns = DnsOverHttps.cloudflare();
final addresses = await dns.lookup('example.com');
dns.close();
```

### 특정 레코드 타입 조회

```dart
final dns = DnsOverHttps.google();

// MX 레코드 (메일 서버)
final mxRecords = await dns.lookupDataByRRType('example.com', RRType.MX);
print('메일 서버: $mxRecords');

// TXT 레코드 (SPF, DKIM, 도메인 인증)
final txtRecords = await dns.lookupDataByRRType('example.com', RRType.TXT);
print('TXT 레코드: $txtRecords');

// SRV 레코드 (서비스 검색)
final srvRecords = await dns.lookupDataByRRType(
  '_jmap._tcp.fastmail.com',
  RRType.SRV,
);
print('SRV 레코드: $srvRecords');

// CAA 레코드 (인증 기관 권한)
final caaRecords = await dns.lookupDataByRRType('example.com', RRType.CAA);
print('CAA 레코드: $caaRecords');

// HTTPS 레코드 (서비스 바인딩)
final httpsRecords = await dns.lookupDataByRRType('example.com', RRType.HTTPS);
print('HTTPS 레코드: $httpsRecords');

dns.close();
```

### 사용자 정의 DNS 제공자

```dart
final dns = DnsOverHttps(
  'https://dns.quad9.net:5053/dns-query',
  timeout: Duration(seconds: 10),
);

final addresses = await dns.lookup('example.com');
dns.close();
```

### 개인정보 보호 설정

권한 있는 네임서버로부터 IP 주소를 숨깁니다:

```dart
final dns = DnsOverHttps(
  'https://dns.google/resolve',
  maximalPrivacy: true,  // edns_client_subnet=0.0.0.0/0 설정
);

final addresses = await dns.lookup('example.com');
dns.close();
```

### 타임아웃 설정

```dart
final dns = DnsOverHttps.google(
  timeout: Duration(seconds: 10),  // 기본값은 5초
);

final addresses = await dns.lookup('example.com');
dns.close();
```

### 에러 처리

```dart
final dns = DnsOverHttps.google();

try {
  final records = await dns.lookupDataByRRType(
    'nonexistent.invalid',
    RRType.A,
  );
} on DnsLookupException catch (e) {
  // DNS 수준 오류 (NXDOMAIN, SERVFAIL 등)
  print('DNS 오류: ${e.message}');
  print('호스트명: ${e.hostname}');
  print('상태: ${e.status}');  // 3 = NXDOMAIN, 2 = SERVFAIL
} on DnsHttpException catch (e) {
  // HTTP 수준 오류
  print('HTTP 오류: ${e.statusCode}');
  print('메시지: ${e.message}');
} finally {
  dns.close();
}
```

### 전체 응답 확인

상세 정보를 위한 전체 DNS 응답 접근:

```dart
final dns = DnsOverHttps.google();

final record = await dns.lookupHttpsByRRType('example.com', RRType.MX);

if (record.isSuccess) {
  print('상태: ${record.status}');  // 0 = NOERROR

  for (final answer in record.answer ?? []) {
    print('이름: ${answer.name}');
    print('타입: ${answer.type}');
    print('TTL: ${answer.TTL}초');
    print('데이터: ${answer.data}');
  }
} else if (record.isNxDomain) {
  print('도메인이 존재하지 않음');
} else if (record.isServerFailure) {
  print('서버 오류');
}

dns.close();
```

## API 레퍼런스

### DnsOverHttps

**생성자:**

| 생성자 | 설명 |
|--------|------|
| `DnsOverHttps(url, {timeout, maximalPrivacy})` | 사용자 정의 DoH 엔드포인트 |
| `DnsOverHttps.google({timeout})` | Google DNS (dns.google) |
| `DnsOverHttps.cloudflare({timeout})` | Cloudflare DNS (1.1.1.1) |

**메서드:**

| 메서드 | 반환 타입 | 설명 |
|--------|-----------|------|
| `lookup(hostname)` | `Future<List<InternetAddress>>` | 호스트명을 IP 주소로 해석 |
| `lookupDataByRRType(hostname, rrType)` | `Future<List<String>>` | 특정 레코드 타입 조회 |
| `lookupHttpsByRRType(hostname, rrType)` | `Future<DnsRecord>` | 전체 DNS 응답 가져오기 |
| `close({force})` | `void` | HTTP 클라이언트 종료 |

### 지원하는 레코드 타입 (RRType)

| 타입 | 상수 | 값 | 설명 |
|------|------|-----|------|
| A | `RRType.A` | 1 | IPv4 주소 |
| NS | `RRType.NS` | 2 | 네임 서버 |
| CNAME | `RRType.CNAME` | 5 | 정식 이름 (별칭) |
| SOA | `RRType.SOA` | 6 | 권한 시작 |
| PTR | `RRType.PTR` | 12 | 역방향 DNS 포인터 |
| HINFO | `RRType.HINFO` | 13 | 호스트 정보 |
| MX | `RRType.MX` | 15 | 메일 교환기 |
| TXT | `RRType.TXT` | 16 | 텍스트 레코드 |
| RP | `RRType.RP` | 17 | 담당자 |
| AFSDB | `RRType.AFSDB` | 18 | AFS 데이터베이스 |
| KEY | `RRType.KEY` | 25 | 보안 키 |
| AAAA | `RRType.AAAA` | 28 | IPv6 주소 |
| LOC | `RRType.LOC` | 29 | 지리적 위치 |
| SRV | `RRType.SRV` | 33 | 서비스 위치 |
| NAPTR | `RRType.NAPTR` | 35 | 네이밍 권한 포인터 |
| KX | `RRType.KX` | 36 | 키 교환기 |
| CERT | `RRType.CERT` | 37 | 인증서 |
| APL | `RRType.APL` | 42 | 주소 접두사 목록 |
| IPSECKEY | `RRType.IPSECKEY` | 45 | IPsec 키 |
| NSEC | `RRType.NSEC` | 47 | 다음 보안 (DNSSEC) |
| DNSKEY | `RRType.DNSKEY` | 48 | DNS 키 (DNSSEC) |
| DHCID | `RRType.DHCID` | 49 | DHCP 식별자 |
| NSEC3PARAM | `RRType.NSEC3PARAM` | 51 | NSEC3 매개변수 |
| SMIMEA | `RRType.SMIMEA` | 53 | S/MIME 인증서 |
| HIP | `RRType.HIP` | 55 | 호스트 ID 프로토콜 |
| CDS | `RRType.CDS` | 59 | 자식 DS (DNSSEC) |
| SVCB | `RRType.SVCB` | 64 | 서비스 바인딩 |
| HTTPS | `RRType.HTTPS` | 65 | HTTPS 바인딩 |
| EUI48 | `RRType.EUI48` | 108 | MAC 주소 (48비트) |
| EUI64 | `RRType.EUI64` | 109 | MAC 주소 (64비트) |
| URI | `RRType.URI` | 256 | URI 매핑 |
| CAA | `RRType.CAA` | 257 | CA 권한 |
| TA | `RRType.TA` | 32768 | 신뢰 앵커 |
| DLV | `RRType.DLV` | 32769 | DNSSEC 룩어사이드 |

**커스텀 레코드 타입:**

```dart
// TLSA 레코드 (타입 52)
final tlsaType = RRType('TLSA', 52);
final tlsaRecords = await dns.lookupDataByRRType('example.com', tlsaType);
```

### 응답 클래스

**DnsRecord:**

| 속성 | 타입 | 설명 |
|------|------|------|
| `status` | `int` | DNS 응답 코드 |
| `answer` | `List<Answer>?` | DNS 응답 목록 |
| `isSuccess` | `bool` | status == 0이면 true |
| `isFailure` | `bool` | status != 0이면 true |
| `isNxDomain` | `bool` | status == 3이면 true |
| `isServerFailure` | `bool` | status == 2이면 true |

**Answer:**

| 속성 | 타입 | 설명 |
|------|------|------|
| `name` | `String` | 도메인 이름 |
| `type` | `int` | 레코드 타입 코드 |
| `TTL` | `int` | 유효 시간 (초) |
| `data` | `String` | 레코드 데이터 |

### 예외

**DnsLookupException** - DNS 쿼리 실패 시 발생:
- `hostname` - 조회한 호스트명
- `status` - DNS 상태 코드 (2=SERVFAIL, 3=NXDOMAIN 등)
- `message` - 오류 설명

**DnsHttpException** - HTTP 요청 실패 시 발생:
- `statusCode` - HTTP 상태 코드
- `message` - 오류 설명

## 요구사항

- Dart SDK: `>=3.7.0 <4.0.0`

## 라이선스

[LICENSE](LICENSE) 파일을 참조하세요.

## 기여하기

기능 요청 및 버그 리포트는 [이슈 트래커](https://github.com/dietfriends/dns_client/issues)에 등록해 주세요.
