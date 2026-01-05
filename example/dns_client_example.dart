import 'package:dns_client/dns_client.dart';

void main() async {
  final dns = DnsOverHttps.google();
  final response = await dns.lookup('google.com');
  response.forEach((address) {
    print('DnsOverHttps.google::lookup:Address: ${address.toString()}');
  });

  final responseSRV = await dns.lookupDataByRRType(
    '_jmap._tcp.linagora.com',
    RRType.SRV,
  );
  responseSRV.forEach((address) {
    print('DnsOverHttps.google::lookupRRType:Address: ${address.toString()}');
  });

  final dnsCloudflare = DnsOverHttps.cloudflare();
  final responseSRVCloudflare = await dnsCloudflare.lookupDataByRRType(
    '_jmap._tcp.linagora.com',
    RRType.SRV,
  );
  responseSRVCloudflare.forEach((address) {
    print(
      'DnsOverHttps.cloudflare::lookupRRType:Address: ${address.toString()}',
    );
  });
}
