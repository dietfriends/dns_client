import 'package:dns_client/dns_client.dart';
import 'package:test/test.dart';

void main() {
  group('DnsOverHttps - Google', () {
    late DnsOverHttps client;

    setUp(() {
      client = DnsOverHttps.google();
    });

    tearDown(() {
      client.close(force: true);
    });

    test('lookup IPv4/IPv6 for google.com', () async {
      final addresses = await client.lookup('google.com');
      expect(addresses, isNotNull);
      expect(addresses, isNotEmpty);

      for (var addr in addresses) {
        print(addr);
        expect(addr.address, isNotEmpty);
        expect(
          addr.address,
          matches(RegExp(r'^(\d{1,3}\.){3}\d{1,3}$|^[\da-f:]+$')),
        );
      }
    });
  });

  group('DnsOverHttps - Cloudflare', () {
    late DnsOverHttps client;

    setUp(() {
      client = DnsOverHttps.cloudflare();
    });

    tearDown(() {
      client.close(force: true);
    });

    test('lookup IPv4/IPv6 for google.com', () async {
      final addresses = await client.lookup(
        'google.com',
        type: DnsRecordType.AAAA,
      );
      print(addresses);
      expect(addresses, isNotNull);
      expect(addresses, isNotEmpty);
    });

    test('lookup CNAME for api.google.com', () async {
      final record = await client.lookupRecord(
        'api.google.com',
        type: DnsRecordType.CNAME,
      );

      print(record);

      expect(record, isNotNull);
      expect(record.answer, isNotEmpty);

      final cnameAnswers = record.answer!.where(
        (r) => r.recordType == DnsRecordType.CNAME,
      ); // CNAME = 5
      expect(cnameAnswers, isNotEmpty);
      for (var answer in cnameAnswers) {
        expect(answer.data, isNotEmpty);
        expect(answer.data, contains('.'));
      }
    });

    test('lookup MX for gmail.com', () async {
      final record = await client.lookupRecord(
        'gmail.com',
        type: DnsRecordType.MX,
      );

      print(record);

      expect(record, isNotNull);
      expect(record.answer, isNotEmpty);

      final mxAnswers = record.answer!.where(
        (r) => r.recordType == DnsRecordType.MX,
      ); // MX = 15
      expect(mxAnswers, isNotEmpty);

      for (var answer in mxAnswers) {
        expect(answer.data, contains('.'));
        expect(answer.name, contains('gmail.com'));
      }
    });

    test('close client prevents further lookups', () async {
      client.close(force: true);
      expect(() => client.lookup('api.google.com'), throwsA(isA<StateError>()));
    });
  });
}
