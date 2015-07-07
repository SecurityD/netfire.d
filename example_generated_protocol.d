extern(C) struct rb_C7netload9protocols3arp3arp3ARP {
  Protocol protocol_c7netload9protocols3arp3arp3arp;
  @property ARP attr_c7netload9protocols3arp3arp3arp() { return cast(ARP)protocol_c7netload9protocols3arp3arp3arp; }
  @property void attr_c7netload9protocols3arp3arp3arp(ARP data) { protocol_c7netload9protocols3arp3arp3arp = cast(Protocol)data; }

  static VALUE new_(VALUE cl, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = new rb_C7netload9protocols3arp3arp3ARP;
    VALUE tdata = Data_Wrap_Struct(cl, null, &free, ptr);
    rb_obj_call_init(tdata, 0, null);
    return tdata;
  }

  static void free(void* p) {
    ARP tmp = (cast(rb_C7netload9protocols3arp3arp3ARP*)p).attr_c7netload9protocols3arp3arp3arp;
    delete tmp;
  }

  static VALUE initialize(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    ptr.attr_c7netload9protocols3arp3arp3arp = new ARP();
    return self;
  }
    
  static VALUE toBytes(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    ubyte[] bytes = ptr.attr_c7netload9protocols3arp3arp3arp.toBytes;
    VALUE array = rb_ary_new();
    foreach(ubyte b; bytes) {
      rb_ary_push(array, rb_uint_new(b));
    }
    return array;
  }

  static VALUE fromBytes(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    VALUE val = Qnil;
    ubyte[] array = [];
    while ((val = rb_ary_shift(tmp)) != Qnil) {
      array ~= cast(ubyte)rb_num2uint(val);
    }
    ptr.attr_c7netload9protocols3arp3arp3arp = cast(ARP)(toARP(array));
    return self;
  }

  static VALUE toJson(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    rb_eval_string(("require 'json'"));
    VALUE val = rb_eval_string(("JSON.parse('" ~ ptr.attr_c7netload9protocols3arp3arp3arp.toJson.toString ~ "')").toStringz);
    return val;
  }

  static VALUE fromJson(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    rb_eval_string(("require 'json'"));
    VALUE val = rb_funcall(rb_path2class("JSON"), rb_intern("generate"), 1, tmp);
    string json = cast(string)(rb_string_value_cstr(&val).fromStringz);
    ptr. attr_c7netload9protocols3arp3arp3arp = cast(ARP)(toARP(parseJson(json)));
    return self;
  }

  static VALUE toString(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_str_new_cstr(ptr.attr_c7netload9protocols3arp3arp3arp.toString.toStringz);
  }

  static VALUE name_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_str_new_cstr(ptr.attr_c7netload9protocols3arp3arp3arp.name.toStringz);
  }

  static VALUE osiLayer_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_int_new(ptr.attr_c7netload9protocols3arp3arp3arp.osiLayer);
  }

  static VALUE hwType_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_uint_new(ptr.attr_c7netload9protocols3arp3arp3arp.hwType);
  }

  static VALUE hwType_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    ptr.attr_c7netload9protocols3arp3arp3arp.hwType = cast(ushort)rb_num2uint(tmp);
    return self;
  }

  static VALUE protocolType_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_uint_new(ptr.attr_c7netload9protocols3arp3arp3arp.protocolType);
  }

  static VALUE protocolType_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    ptr.attr_c7netload9protocols3arp3arp3arp.protocolType = cast(ushort)rb_num2uint(tmp);
    return self;
  }

  static VALUE hwAddrLen_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_uint_new(ptr.attr_c7netload9protocols3arp3arp3arp.hwAddrLen);
  }

  static VALUE hwAddrLen_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    ptr.attr_c7netload9protocols3arp3arp3arp.hwAddrLen = cast(ubyte)rb_num2uint(tmp);
    return self;
  }

  static VALUE protocolAddrLen_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_uint_new(ptr.attr_c7netload9protocols3arp3arp3arp.protocolAddrLen);
  }

  static VALUE protocolAddrLen_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    ptr.attr_c7netload9protocols3arp3arp3arp.protocolAddrLen = cast(ubyte)rb_num2uint(tmp);
    return self;
  }

  static VALUE opcode_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    return rb_uint_new(ptr.attr_c7netload9protocols3arp3arp3arp.opcode);
  }

  static VALUE opcode_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    ptr.attr_c7netload9protocols3arp3arp3arp.opcode = cast(ushort)rb_num2uint(tmp);
    return self;
  }

  static VALUE senderHwAddr_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE array = rb_ary_new();
    foreach(ubyte b; ptr.attr_c7netload9protocols3arp3arp3arp.senderHwAddr) {
      rb_ary_push(array, rb_int_new(b));
    }
    return array;
  }

  static VALUE senderHwAddr_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    VALUE val = Qnil;
    ubyte[] array = [];
    while ((val = rb_ary_shift(tmp)) != Qnil) {
      array ~= cast(ubyte)rb_num2uint(val);
    }
    ptr.attr_c7netload9protocols3arp3arp3arp.senderHwAddr = array.to!(ubyte[]);
    return self;
  }

  static VALUE targetHwAddr_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE array = rb_ary_new();
    foreach(ubyte b; ptr.attr_c7netload9protocols3arp3arp3arp.targetHwAddr) {
      rb_ary_push(array, rb_int_new(b));
    }
    return array;
  }

  static VALUE targetHwAddr_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    VALUE val = Qnil;
    ubyte[] array = [];
    while ((val = rb_ary_shift(tmp)) != Qnil) {
      array ~= cast(ubyte)rb_num2uint(val);
    }
    ptr.attr_c7netload9protocols3arp3arp3arp.targetHwAddr = array.to!(ubyte[]);
    return self;
  }

  static VALUE senderProtocolAddr_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE array = rb_ary_new();
    foreach(ubyte b; ptr.attr_c7netload9protocols3arp3arp3arp.senderProtocolAddr) {
      rb_ary_push(array, rb_int_new(b));
    }
    return array;
  }

  static VALUE senderProtocolAddr_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    VALUE val = Qnil;
    ubyte[] array = [];
    while ((val = rb_ary_shift(tmp)) != Qnil) {
      array ~= cast(ubyte)rb_num2uint(val);
    }
    ptr.attr_c7netload9protocols3arp3arp3arp.senderProtocolAddr = array.to!(ubyte[]);
    return self;
  }

  static VALUE targetProtocolAddr_get(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE array = rb_ary_new();
    foreach(ubyte b; ptr.attr_c7netload9protocols3arp3arp3arp.targetProtocolAddr) {
      rb_ary_push(array, rb_int_new(b));
    }
    return array;
  }

  static VALUE targetProtocolAddr_set(VALUE self, ...) {
    rb_C7netload9protocols3arp3arp3ARP* ptr = Data_Get_Struct!rb_C7netload9protocols3arp3arp3ARP(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    VALUE val = Qnil;
    ubyte[] array = [];
    while ((val = rb_ary_shift(tmp)) != Qnil) {
      array ~= cast(ubyte)rb_num2uint(val);
    }
    ptr.attr_c7netload9protocols3arp3arp3arp.targetProtocolAddr = array.to!(ubyte[]);
    return self;
  }

  static VALUE singInst;
  static this() {
    singInst = rb_define_class("ARP", rb_cObject);
    rb_define_singleton_method(singInst, "new".toStringz, &new_, 0);
    rb_define_method(singInst, "initialize".toStringz, &initialize, 0);
    rb_define_method(singInst, "toBytes".toStringz, &toBytes, 0);
    rb_define_method(singInst, "fromBytes".toStringz, &fromBytes, 1);
    rb_define_method(singInst, "toJson".toStringz, &toJson, 0);
    rb_define_method(singInst, "fromJson".toStringz, &fromJson, 1);
    rb_define_method(singInst, "toString".toStringz, &toString, 0);
    rb_define_method(singInst, "name".toStringz, &name_get, 0);
    rb_define_method(singInst, "osiLayer".toStringz, &osiLayer_get, 0);
    rb_define_method(singInst, "hwType".toStringz, &hwType_get, 0);
    rb_define_method(singInst, "hwType=".toStringz, &hwType_set, 1);
    rb_define_method(singInst, "protocolType".toStringz, &protocolType_get, 0);
    rb_define_method(singInst, "protocolType=".toStringz, &protocolType_set, 1);
    rb_define_method(singInst, "hwAddrLen".toStringz, &hwAddrLen_get, 0);
    rb_define_method(singInst, "hwAddrLen=".toStringz, &hwAddrLen_set, 1);
    rb_define_method(singInst, "protocolAddrLen".toStringz, &protocolAddrLen_get, 0);
    rb_define_method(singInst, "protocolAddrLen=".toStringz, &protocolAddrLen_set, 1);
    rb_define_method(singInst, "opcode".toStringz, &opcode_get, 0);
    rb_define_method(singInst, "opcode=".toStringz, &opcode_set, 1);
    rb_define_method(singInst, "senderHwAddr".toStringz, &senderHwAddr_get, 0);
    rb_define_method(singInst, "senderHwAddr=".toStringz, &senderHwAddr_set, 1);
    rb_define_method(singInst, "targetHwAddr".toStringz, &targetHwAddr_get, 0);
    rb_define_method(singInst, "targetHwAddr=".toStringz, &targetHwAddr_set, 1);
    rb_define_method(singInst, "senderProtocolAddr".toStringz, &senderProtocolAddr_get, 0);
    rb_define_method(singInst, "senderProtocolAddr=".toStringz, &senderProtocolAddr_set, 1);
    rb_define_method(singInst, "targetProtocolAddr".toStringz, &targetProtocolAddr_get, 0);
    rb_define_method(singInst, "targetProtocolAddr=".toStringz, &targetProtocolAddr_set, 1);
  }
}
