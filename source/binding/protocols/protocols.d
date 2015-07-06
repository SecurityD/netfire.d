module binding.protocols.protocols;

import netload.protocols;

import binding.protocols.protocol_binding;

mixin(rb_ProtocolBinding!ARP);
mixin(rb_ProtocolBinding!DHCP);

mixin(rb_ProtocolBinding!DNS);
mixin(rb_ProtocolBinding!DNSQuery);
mixin(rb_ProtocolBinding!DNSResource);
mixin(rb_ProtocolBinding!DNSQR);
mixin(rb_ProtocolBinding!DNSRR);
mixin(rb_ProtocolBinding!DNSSOAResource);
mixin(rb_ProtocolBinding!DNSMXResource);
mixin(rb_ProtocolBinding!DNSAResource);
mixin(rb_ProtocolBinding!DNSPTRResource);

mixin(rb_ProtocolBinding!SNMPv3);
