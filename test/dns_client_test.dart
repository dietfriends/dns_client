import 'package:dns_client/dns_client.dart';
import 'package:dns_client/src/dns_over_https.dart';
import 'package:test/test.dart';

void main() {
  group('HttpDnsClient Google', () {
    test('lookup( google.com )', () async {
      final client = DnsOverHttps.google();
      final address = await client.lookup('google.com');
      expect(address, isNotNull);
      expect(address.isNotEmpty, isTrue);
    });
  });

  group('HttpDnsClient Cloudflare', () {
    test('lookup( google.com )', () async {
      final client = DnsOverHttps.cloudflare();
      final address = await client.lookup('google.com');
      expect(address, isNotNull);
      expect(address.isNotEmpty, isTrue);
    });

    test('cname test', () async {
      final client = DnsOverHttps.cloudflare();
      final address = await client.lookup('api.google.com');
      expect(address, isNotNull);
      expect(address.isNotEmpty, isTrue);
    });

    test('close', () async {
      final client = DnsOverHttps.cloudflare();
      client.close();
      expect(client.lookup('api.google.com'), throwsA(isA<StateError>()));
    });
  });

  group('HttpDnsClient AdGuard', () {
    test('lookup( google.com )', () async {
      final client = DnsOverHttps.adguard();
      final address = await client.lookup('google.com');
      expect(address, isNotNull);
      expect(address.isNotEmpty, isTrue);
      client.close();
    });

    test('non-filtering lookup( google.com )', () async {
      final client = DnsOverHttps.adguardNonFiltering();
      final address = await client.lookup('google.com');
      expect(address, isNotNull);
      expect(address.isNotEmpty, isTrue);
      client.close();
    });

    test('family lookup( google.com )', () async {
      final client = DnsOverHttps.adguardFamily();
      final address = await client.lookup('google.com');
      expect(address, isNotNull);
      expect(address.isNotEmpty, isTrue);
      client.close();
    });

    test('cname test', () async {
      final client = DnsOverHttps.adguard();
      final address = await client.lookup('api.google.com');
      expect(address, isNotNull);
      expect(address.isNotEmpty, isTrue);
      client.close();
    });

    test('close', () async {
      final client = DnsOverHttps.adguard();
      client.close();
      expect(client.lookup('google.com'), throwsA(isA<StateError>()));
    });
  });
}
