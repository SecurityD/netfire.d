module binding.protocols.arp;

import netload.protocols.arp;

import binding.protocols.protocol_binding;

extern(C) struct rb_ARP {
  ARP arp;

  mixin(rb_ProtocolBinding!(ARP, rb_ARP, "arp"));

  static void free(void* p) {
    delete (cast(rb_ARP*)p).arp;
  }

  static VALUE initialize(int ac, VALUE* av, VALUE self) {
    VALUE hwTypeAddr, protocolTypeAddr, hwAddrLenAddr, protocolAddrLenAddr, opcodeAddr = Qnil;
    rb_scan_args(ac, av, "41", &hwTypeAddr, &protocolTypeAddr, &hwAddrLenAddr, &protocolAddrLenAddr, &opcodeAddr);

    ushort hwType, protocolType, opcode = 0;
    ubyte hwAddrLen, protocolAddrLen;
    hwType = cast(ushort)rb_num2int(hwTypeAddr);
    protocolType = cast(ushort)rb_num2int(protocolTypeAddr);
    hwAddrLen = cast(ubyte)rb_num2int(hwAddrLenAddr);
    protocolAddrLen = cast(ubyte)rb_num2int(protocolAddrLenAddr);
    if (opcodeAddr != Qnil)
      opcode = cast(ushort)rb_num2int(opcodeAddr);

    rb_ARP* ptr = Data_Get_Struct!rb_ARP(self);
    ptr.arp = new ARP(hwType, protocolType, hwAddrLen, protocolAddrLen, opcode);
    return self;
  }
}
