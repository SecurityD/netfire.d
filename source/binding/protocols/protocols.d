module binding.protocols.protocols;

import netload.protocols;

import binding.protocols.protocol_binding;

// ARP
mixin(rb_ProtocolBinding!ARP);

// DHCP
mixin(rb_ProtocolBinding!DHCP);

// DNS
mixin(rb_ProtocolBinding!DNS);
mixin(rb_ProtocolBinding!DNSQuery);
mixin(rb_ProtocolBinding!DNSResource);
mixin(rb_ProtocolBinding!DNSQR);
mixin(rb_ProtocolBinding!DNSRR);
mixin(rb_ProtocolBinding!DNSSOAResource);
mixin(rb_ProtocolBinding!DNSMXResource);
mixin(rb_ProtocolBinding!DNSAResource);
mixin(rb_ProtocolBinding!DNSPTRResource);

// 802.11
mixin(rb_ProtocolBinding!Dot11);

// Ethernet
mixin(rb_ProtocolBinding!Ethernet);

// HTTP
mixin(rb_ProtocolBinding!HTTP);

// ICMP
mixin(rb_ProtocolBinding!ICMP);
mixin(rb_ProtocolBinding!ICMPv4Communication);
mixin(rb_ProtocolBinding!ICMPv4EchoRequest);
mixin(rb_ProtocolBinding!ICMPv4EchoReply);
mixin(rb_ProtocolBinding!ICMPv4Timestamp);
mixin(rb_ProtocolBinding!ICMPv4TimestampRequest);
mixin(rb_ProtocolBinding!ICMPv4TimestampReply);
mixin(rb_ProtocolBinding!ICMPv4InformationRequest);
mixin(rb_ProtocolBinding!ICMPv4InformationReply);
mixin(rb_ProtocolBinding!ICMPv4Error);
mixin(rb_ProtocolBinding!ICMPv4DestUnreach);
mixin(rb_ProtocolBinding!ICMPv4TimeExceed);
mixin(rb_ProtocolBinding!ICMPv4ParamProblem);
mixin(rb_ProtocolBinding!ICMPv4SourceQuench);
mixin(rb_ProtocolBinding!ICMPv4Redirect);
mixin(rb_ProtocolBinding!ICMPv4RouterAdvert);
mixin(rb_ProtocolBinding!ICMPv4RouterSollicitation);

// IMAP
mixin(rb_ProtocolBinding!IMAP);

// IP
mixin(rb_ProtocolBinding!IP);

// NTP
mixin(rb_ProtocolBinding!NTPv0);
mixin(rb_ProtocolBinding!NTPv4);

// POP3
mixin(rb_ProtocolBinding!POP3);

// Raw
mixin(rb_ProtocolBinding!Raw);

// SMTP
mixin(rb_ProtocolBinding!SMTP);

// SNMP
mixin(rb_ProtocolBinding!SNMPv1);
mixin(rb_ProtocolBinding!SNMPv3);

// TCP
mixin(rb_ProtocolBinding!TCP);

// UDP
mixin(rb_ProtocolBinding!UDP);

extern(C) VALUE fileToProtocol(VALUE self, ...) {
  struct getProtocol {
    Protocol p;
  }

  import netload.core.protocol;
  VALUE file = va_arg!VALUE(_argptr);
  string fileName = cast(string)(rb_string_value_cstr(&file).fromStringz);
  Protocol p = netload.core.protocol.read(fileName);
  VALUE tmp = rb_eval_string((p.name ~ ".new").toStringz);
  getProtocol* protocol = Data_Get_Struct!getProtocol(tmp);
  protocol.p = p;
  return tmp;
}

static this() {
  rb_define_global_function("readProtocol".toStringz, &fileToProtocol, 1);
}
