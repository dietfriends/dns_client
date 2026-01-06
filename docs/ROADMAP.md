# DNS-over-HTTPS Provider Roadmap

This document outlines planned DNS-over-HTTPS (DoH) providers to be added to the `dns_client` library.

## Currently Supported

### JSON Format (DnsOverHttps)

- **Google** - `DnsOverHttps.google()`
- **Cloudflare** - `DnsOverHttps.cloudflare()`
- **AdGuard** - `DnsOverHttps.adguard()`, `adguardNonFiltering()`, `adguardFamily()`

### Wire Format (DnsOverHttpsWire)

- **Quad9** - `DnsOverHttpsWire.quad9()`, `quad9Ecs()`, `quad9Unsecured()`

## Planned Providers

### Phase 1: JSON-based Providers

| Provider      | Endpoint                                           | Variants                | Notes                            |
| ------------- | -------------------------------------------------- | ----------------------- | -------------------------------- |
| NextDNS       | `https://dns.nextdns.io/dns-query`                 | Anycast                 | Privacy-focused, browser default |
| OpenDNS       | `https://doh.opendns.com/dns-query`                | FamilyShield            | Cisco-owned, enterprise-grade    |
| CleanBrowsing | `https://doh.cleanbrowsing.org/doh/family-filter/` | Family, Adult, Security | Content filtering                |
| DNS.SB        | `https://doh.dns.sb/dns-query`                     | -                       | Privacy-focused, no logging      |

### Phase 2: Wire Format Providers

| Provider | Endpoint                            | Variants          | Notes                         |
| -------- | ----------------------------------- | ----------------- | ----------------------------- |
| Mullvad  | `https://dns.mullvad.net/dns-query` | adblock, extended | VPN provider, strong privacy  |
| ControlD | `https://freedns.controld.com/p0`   | p0, p1, p2        | Configurable filtering levels |

## Implementation Notes

### Factory Constructor Naming

Follow existing patterns:

- Base: `Provider.providerName()`
- Variants: `Provider.providerNameVariant()` (e.g., `adguardFamily()`)

### Variant Support

| Provider      | Base                    | Variants                                          |
| ------------- | ----------------------- | ------------------------------------------------- |
| NextDNS       | `nextdns()`             | `nextdnsAnycast()`                                |
| OpenDNS       | `opendns()`             | `opendnsFamilyShield()`                           |
| CleanBrowsing | `cleanBrowsingFamily()` | `cleanBrowsingAdult()`, `cleanBrowsingSecurity()` |
| Mullvad       | `mullvad()`             | `mullvadAdblock()`, `mullvadExtended()`           |
| ControlD      | `controld()`            | `controldMalware()`, `controldMalwareAds()`       |

### Testing

Each provider should include:

- Basic lookup test (`lookup('example.com')`)
- Record type test (`lookupDataByRRType` with MX, TXT)
- Error handling test (invalid domain)

## References

- [AdGuard DNS Knowledge Base - DNS Providers](https://adguard-dns.io/kb/general/dns-providers/)
- [curl DNS-over-HTTPS Wiki](https://github.com/curl/curl/wiki/DNS-over-HTTPS)
- [Privacy Guides - DNS Resolvers](https://www.privacyguides.org/en/dns/)
