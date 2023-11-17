import 'dart:io';

import 'package:dns_client/src/rr_type.dart';

abstract class DnsClient {
  Future<List<InternetAddress>> lookup(String hostname);

  Future<List<String>> lookupDataByRRType(String hostname, RRType rrType);
}
