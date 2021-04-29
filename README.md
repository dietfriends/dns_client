Dart implementation of DNS-over-HTTPS.

[![CodeFactor](https://www.codefactor.io/repository/github/dietfriends/dns_client/badge)](https://www.codefactor.io/repository/github/dietfriends/dns_client)
[![pub.dev](https://badgen.net/pub/v/dns_client)](https://pub.dev/packages/dns_client)
[![license](https://badgen.net/pub/license/dns_client)](https://github.com/dietfriends/dns_client/blob/master/LICENSE)

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
