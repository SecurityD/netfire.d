module binding.core.packet;

import core.vararg;
import std.string;
import std.conv;
import std.datetime;

import ruby;

import netload.core.packet;
import netload.core.protocol;

/++
 + A binding to the `Packet` class, see the `Packet` documentation
 + for further informations.
 +/
extern(C) struct rb_Packet {
  Packet packet;
  VALUE rbPacketPtr;

  static VALUE getAnnotation(VALUE self, ...) {
    rb_Packet* ptr = Data_Get_Struct!rb_Packet(self);
    return rb_str_new_cstr(ptr.packet.annotation.toStringz);
  }

  static VALUE setAnnotation(VALUE self, ...) {
    rb_Packet* ptr = Data_Get_Struct!rb_Packet(self);
    VALUE tmp = va_arg!VALUE(_argptr);
    ptr.packet.annotation = cast(string)(rb_string_value_cstr(&tmp).fromStringz);
    return self;
  }

  static VALUE getTime(VALUE self, ...) {
    rb_Packet* ptr = Data_Get_Struct!rb_Packet(self);
    return rb_str_new_cstr(ptr.packet.time.toSimpleString.toStringz);
  }

  static VALUE getData(VALUE self, ...) {
    rb_Packet* ptr = Data_Get_Struct!rb_Packet(self);
    return ptr.rbPacketPtr;
  }

  static void free(void* p) {
    delete p;
  }

  static VALUE initialize(int ac, VALUE* av, VALUE self) {
    struct getProtocol {
      Protocol p;
    }

    rb_Packet* ptr = Data_Get_Struct!rb_Packet(self);

    VALUE rbPacket, rbTime = Qnil;
    rb_scan_args(ac, av, "11", &rbPacket, &rbTime);
    getProtocol* pr = Data_Get_Struct!getProtocol(rbPacket);
    if (rbTime != Qnil) {
      ptr.packet = new Packet(pr.p, SysTime.fromSimpleString(cast(string)(rb_string_value_cstr(&rbTime).fromStringz)));
    } else {
      ptr.packet = new Packet(pr.p);
    }
    ptr.rbPacketPtr = rbPacket;

    return self;
  }

  static VALUE new_(int ac, VALUE* av, VALUE cl) {
    rb_Packet* ptr = new rb_Packet;
    VALUE tdata = Data_Wrap_Struct(cl, null, &free, ptr);
    rb_obj_call_init(tdata, ac, av);
    return tdata;
  }

  static VALUE singInst;
  static this() {
    singInst = rb_define_class("Packet", rb_cObject);
    rb_define_singleton_method(singInst, "new".toStringz, &new_, -1);
    rb_define_method(singInst, "initialize".toStringz, &initialize, -1);
    rb_define_method(singInst, "annotation".toStringz, &getAnnotation, 0);
    rb_define_method(singInst, "annotation=".toStringz, &setAnnotation, 1);
    rb_define_method(singInst, "time".toStringz, &getTime, 0);
    rb_define_method(singInst, "data".toStringz, &getData, 0);
  }
}
