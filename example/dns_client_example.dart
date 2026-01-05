import 'package:dns_client/dns_client.dart';

main() async {
  final dns = DnsOverHttps.google();

  var addressesResponse = await dns.lookup('gmail.com');

  print('Addresses:');
  for (var address in addressesResponse) {
    print('-- $address');
  }

  var mxResponse = await dns.lookup('gmail.com', type: DnsRecordType.MX);
  print('MX addresses:');
  for (var mxAddress in mxResponse) {
    print('-- $mxAddress');
  }
}

/*
/////////////
// OUTPUT: //
/////////////

Addresses:
-- InternetAddress('172.217.29.229', IPv4)
-- InternetAddress('2800:3f0:4001:839::2005', IPv6)
MX addresses:
-- InternetAddress('2a00:1450:4025:402::1b', IPv6)
-- InternetAddress('2a00:1450:400c:c00::1a', IPv6)
-- InternetAddress('2a00:1450:4013:c1e::1b', IPv6)
-- InternetAddress('2a00:1450:4009:c0f::1a', IPv6)
-- InternetAddress('2800:3f0:4003:c0f::1a', IPv6)
*/
