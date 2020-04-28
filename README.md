Dart implementation of DNS-over-HTTPS.

[license](https://github.com/dietfriends/dns_client/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:dns_client/dns_client.dart';

main() async {
  final dns = DnsOverHttps.google();
  var response = await dns.lookup('google.com');
  response.forEach((address) {
    print(address.toString());
  });}
```

```dart
import 'package:dns_client/dns_client.dart';

main() async {
  final dns = DnsOverHttps.cloudflare();
  var response = await dns.lookup('google.com');
  response.forEach((address) {
    print(address.toString());
  });}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dietfriends/dns_client
