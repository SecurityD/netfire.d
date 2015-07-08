module binding.core.injection;

import core.vararg;
import std.string;
import std.conv;

import ruby;

import netload.core.packet;
import netload.core.protocol;

extern(C) VALUE inject(VALUE self, ...) {
  struct getProtocol {
    Protocol p;
  }
  VALUE tmp = va_arg!VALUE(_argptr);
  Protocol p = Data_Get_Struct!getProtocol(tmp).p;
  import std.stdio;
  writeln("Should send packet :\n" ~ p.toString);
  return self;
}

static this() {
  rb_define_global_function("inject".toStringz, &inject, 1);
}
