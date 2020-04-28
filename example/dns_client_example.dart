import 'package:dns_client/dns_client.dart';

void main() async {
  final dns = DnsOverHttps.google();
  final response = await dns.lookup('google.com');
  response.forEach((address) {
    print(address.toString());
  });
}
