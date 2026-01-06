## 1.0.0

- **BREAKING**: Require Dart 3.0.0 or later
- Upgrade freezed to v3 with abstract class syntax
- Upgrade http from 0.13 to 1.x
- Replace deprecated pedantic with lints package
- Update all dependencies for Dart 3 compatibility

## [1.3.1](https://github.com/amondnet/dns_client/compare/v1.3.0...v1.3.1) (2026-01-06)


### Bug Fixes

* improve pub.dev pana score to 160/160 ([d37929e](https://github.com/amondnet/dns_client/commit/d37929e6a4b9e2eeba20f3f0ea04eabfb8c9b183))

## [1.3.0](https://github.com/amondnet/dns_client/compare/v1.2.0...v1.3.0) (2026-01-06)


### Features

* add NextDNS provider support ([#27](https://github.com/amondnet/dns_client/issues/27)) ([cfd2a11](https://github.com/amondnet/dns_client/commit/cfd2a11ced78aa005898477a2a253e7740fe774f))
* add OpenDNS provider support (wire format) ([#30](https://github.com/amondnet/dns_client/issues/30)) ([8c631dc](https://github.com/amondnet/dns_client/commit/8c631dc762c9f519aeb2f27fdca41fb96af4f1d2)), closes [#29](https://github.com/amondnet/dns_client/issues/29)
* add remaining DoH providers from ROADMAP ([#32](https://github.com/amondnet/dns_client/issues/32)) ([6298b98](https://github.com/amondnet/dns_client/commit/6298b98421e427468322d03773ae3165701bf0cf))

## [1.2.0](https://github.com/amondnet/dns_client/compare/v1.1.0...v1.2.0) (2026-01-06)


### Features

* add DNS wire format support with Quad9 provider ([#24](https://github.com/amondnet/dns_client/issues/24)) ([7a8ab8c](https://github.com/amondnet/dns_client/commit/7a8ab8c23b46617d2bd7180a8dc6c2d54be37cff))

## [1.1.0](https://github.com/amondnet/dns_client/compare/v1.0.0...v1.1.0) (2026-01-05)

### Features

- add AdGuard DNS provider support
  ([#15](https://github.com/amondnet/dns_client/issues/15))
  ([8d2c0d7](https://github.com/amondnet/dns_client/commit/8d2c0d780635f819dc98b07f3ed032c5832e3a51)),
  closes [#14](https://github.com/amondnet/dns_client/issues/14)

## [1.0.0](https://github.com/amondnet/dns_client/compare/v0.2.1...v1.0.0) (2026-01-05)

### BREAKING CHANGES

- RRType static constants renamed (e.g., MXType -> MX)
- Minimum SDK version is now Dart 3.0.0

### Features (1.0.0)

- add 26 new DNS record types and simplify API naming
  ([#12](https://github.com/amondnet/dns_client/issues/12))
  ([15b883a](https://github.com/amondnet/dns_client/commit/15b883a429a41da8094108125f733f7e75c182e4))
- migrate to Dart 3 SDK
  ([#11](https://github.com/amondnet/dns_client/issues/11))
  ([9ec43dc](https://github.com/amondnet/dns_client/commit/9ec43dc9abb11d259ee9d85f051cced0fdc44fa2))
- use httpclient instead of http
  ([#6](https://github.com/amondnet/dns_client/issues/6))
  ([120506d](https://github.com/amondnet/dns_client/commit/120506d7eb39c53e718aeef9cac11374898d0eb6))

## 0.2.1

- use `HttpClient` instead of `http`

## 0.2.0

- Migrated to null-safety

## 0.1.0+1

- fix: answer is not always ip address

## 0.1.0

- Initial version, created by Stagehand
- cloudflare, Google implementation
