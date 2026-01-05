Dart implementation of DNS-over-HTTPS client.

[![CodeFactor](https://www.codefactor.io/repository/github/dietfriends/dns_client/badge)](https://www.codefactor.io/repository/github/dietfriends/dns_client)
[![pub.dev](https://badgen.net/pub/v/dns_client)](https://pub.dev/packages/dns_client)
[![license](https://badgen.net/pub/license/dns_client)](https://github.com/dietfriends/dns_client/blob/master/LICENSE)

## Usage

A simple usage example:

```dart
import 'package:dns_client/dns_client.dart';

main() async {
  final dns = DnsOverHttps.google();
  
  var addressesResponse = await dns.lookup('gmail.com');
  for (var address in addressesResponse) {
    print(address);
  }

  var mxResponse = await dns.lookup('gmail.com', );
  for (var mxAddress in mxResponse) {
    print(mxAddress);
  }
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dietfriends/dns_client/issues


## Author

- PassionFactory: [dietfriends@GitHub][dietfriends_github] (original author).
- Graciliano M. Passos: [gmpassos@GitHub][gmpassos_github].

[dietfriends_github]: https://github.com/dietfriends
[gmpassos_github]: https://github.com/gmpassos

---

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

