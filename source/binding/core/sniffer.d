module binding.protocols.sniffer;

import core.vararg;
import std.string;
import std.conv;
import std.stdio;

import netload.d;

import ruby;

/++
 + A binding to the `Sniffer` class, see the `Sniffer` documentation
 + for further informations.
 +/
extern (C) struct rb_Sniffer {
  Sniffer sniffer;

  static VALUE sniff(VALUE self, ...) {
    rb_Sniffer* ptr = Data_Get_Struct!rb_Sniffer(self);
    ptr.sniffer.sniff(delegate(Packet packet) {
      writeln(packet.toString);
      return true;
    });
    return self;
  }

  static void free(void* p) {
    delete p;
  }

  static VALUE initialize(VALUE self, ...) {
    rb_Sniffer* ptr = Data_Get_Struct!rb_Sniffer(self);
    ptr.sniffer = new Sniffer(null, function(ubyte[] data) { return cast(Protocol)to!Ethernet(data); });
    return self;
  }

  static VALUE new_(VALUE cl, ...) {
    rb_Sniffer* ptr = new rb_Sniffer;
    VALUE tdata = Data_Wrap_Struct(cl, null, &free, ptr);
    rb_obj_call_init(tdata, 0, null);
    return tdata;
  }

  static VALUE singInst;
  static this() {
    singInst = rb_define_class("Sniffer", rb_cObject);
    rb_define_singleton_method(singInst, "new".toStringz, &new_, 0);
    rb_define_method(singInst, "initialize".toStringz, &initialize, 0);
    rb_define_method(singInst, "sniff".toStringz, &sniff, 0);
  }
}
