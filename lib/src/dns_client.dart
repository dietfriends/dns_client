import 'dart:io';

abstract class DnsClient {
  Future<List<InternetAddress>> lookup(String hostname);
}
