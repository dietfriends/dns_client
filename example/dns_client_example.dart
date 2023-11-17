import 'package:dns_client/dns_client.dart';
import 'package:dns_client/src/rr_type.dart';

void main() async {
  final dns = DnsOverHttps.google();
  final response = await dns.lookup('google.com');
  response.forEach((address) {
    print('DnsOverHttps.google::lookup:Address: ${address.toString()}');
  });

  final responseSRV =
      await dns.lookupDataByRRType('_jmap._tcp.linagora.com', RRType.SRVType);
  responseSRV.forEach((address) {
    print('DnsOverHttps.google::lookupRRType:Address: ${address.toString()}');
  });

  final dnsCloudflare = DnsOverHttps.cloudflare();
  final responseSRVCloudflare = await dnsCloudflare.lookupDataByRRType('_jmap._tcp.linagora.com', RRType.SRVType);
  responseSRVCloudflare.forEach((address) {
    print('DnsOverHttps.cloudflare::lookupRRType:Address: ${address.toString()}');
  });
}
