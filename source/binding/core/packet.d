module binding.core.packet;

import core.vararg;
import std.string;
import std.conv;

import ruby;

extern(C) struct rb_Packet {
  static void free(void* p) {
    delete p;
  }

  static VALUE initialize(VALUE self, ...) {
    rb_Packet* ptr = Data_Get_Struct!rb_Packet(self);
    return self;
  }

  static VALUE new_(VALUE cl, ...) {
    rb_Packet* ptr = new rb_Packet;
    VALUE tdata = Data_Wrap_Struct(cl, null, &free, ptr);
    rb_obj_call_init(tdata, 0, null);
    return tdata;
  }

  static VALUE singInst;
  static this() {
    singInst = rb_define_class("Packet", rb_cObject);
    rb_define_singleton_method(singInst, "new".toStringz, &new_, 0);
    rb_define_method(singInst, "initialize".toStringz, &initialize, 0);
  }
}
