import 'package:dns_client/src/dns_over_https_wire.dart';
import 'package:dns_client/src/dns_record.dart';
import 'package:dns_client/src/rr_type.dart';
import 'package:test/test.dart';

void main() {
  group('DnsOverHttpsWire', () {
    group('Quad9 (secured)', () {
      late DnsOverHttpsWire client;

      setUp(() {
        client = DnsOverHttpsWire.quad9();
      });

      tearDown(() {
        client.close();
      });

      test('lookup returns IP addresses', () async {
        final addresses = await client.lookup('google.com');
        expect(addresses, isNotEmpty);
        expect(addresses.first.address, isNotEmpty);
      });

      test('lookupWire returns DnsRecord', () async {
        final record = await client.lookupWire('example.com', RRType.A);
        expect(record.isSuccess, isTrue);
        expect(record.answer, isNotNull);
        expect(record.answer!.first.type, equals(RRType.A.value));
      });

      test('lookupDataByRRType returns CNAME data', () async {
        // www.github.com has CNAME records
        final data = await client.lookupDataByRRType(
          'www.github.com',
          RRType.CNAME,
        );
        expect(data, isNotEmpty);
      });

      test('lookupDataByRRType throws on NXDOMAIN', () async {
        // Use a truly non-existent TLD to get RCODE 3 (NXDOMAIN)
        // Subdomains of existing domains return NOERROR with empty answers
        expect(
          () => client.lookupDataByRRType(
            'nonexistent-domain-12345.invalidtld',
            RRType.A,
          ),
          throwsA(isA<DnsLookupException>()),
        );
      });
    });

    group('Quad9 with ECS', () {
      late DnsOverHttpsWire client;

      setUp(() {
        client = DnsOverHttpsWire.quad9Ecs();
      });

      tearDown(() {
        client.close();
      });

      test('lookup returns IP addresses', () async {
        final addresses = await client.lookup('cloudflare.com');
        expect(addresses, isNotEmpty);
      });
    });

    group('Quad9 unsecured', () {
      late DnsOverHttpsWire client;

      setUp(() {
        client = DnsOverHttpsWire.quad9Unsecured();
      });

      tearDown(() {
        client.close();
      });

      test('lookup returns IP addresses', () async {
        final addresses = await client.lookup('example.com');
        expect(addresses, isNotEmpty);
      });
    });

    group('OpenDNS', () {
      late DnsOverHttpsWire client;

      setUp(() {
        client = DnsOverHttpsWire.opendns();
      });

      tearDown(() {
        client.close();
      });

      test('lookup returns IP addresses', () async {
        final addresses = await client.lookup('google.com');
        expect(addresses, isNotEmpty);
        expect(addresses.first.address, isNotEmpty);
      });

      test('lookupWire returns DnsRecord', () async {
        final record = await client.lookupWire('example.com', RRType.A);
        expect(record.isSuccess, isTrue);
        expect(record.answer, isNotNull);
      });
    });

    group('OpenDNS FamilyShield', () {
      late DnsOverHttpsWire client;

      setUp(() {
        client = DnsOverHttpsWire.opendnsFamilyShield();
      });

      tearDown(() {
        client.close();
      });

      test('lookup returns IP addresses', () async {
        final addresses = await client.lookup('google.com');
        expect(addresses, isNotEmpty);
      });
    });

    group('client lifecycle', () {
      test('close prevents further lookups', () async {
        final client = DnsOverHttpsWire.quad9();
        await client.lookup('example.com'); // Should work
        client.close();

        // After close, new lookups should fail with StateError
        expect(() => client.lookup('example.com'), throwsA(isA<StateError>()));
      });
    });

    group('record types', () {
      late DnsOverHttpsWire client;

      setUp(() {
        client = DnsOverHttpsWire.quad9();
      });

      tearDown(() {
        client.close();
      });

      test('MX record lookup', () async {
        final data = await client.lookupDataByRRType('google.com', RRType.MX);
        expect(data, isNotEmpty);
        // MX records have format: "priority exchange"
        expect(data.first, contains(' '));
      });

      test('TXT record lookup', () async {
        final data = await client.lookupDataByRRType('google.com', RRType.TXT);
        expect(data, isNotEmpty);
      });

      test('AAAA record lookup', () async {
        final data = await client.lookupDataByRRType('google.com', RRType.AAAA);
        expect(data, isNotEmpty);
        // IPv6 addresses contain colons
        expect(data.first, contains(':'));
      });
    });
  });
}
