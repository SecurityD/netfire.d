module binding.protocols.protocol_binding;

public import core.vararg;
public import std.string;
public import std.conv;

public import vibe.data.json;

public import ruby;

template rb_ProtocolBinding(Type) {
  import std.traits;
  import netload.core.protocol;

  public string rb_ProtocolBinding() {
    string structType = "rb_" ~ Type.stringof;
    string attr = Type.stringof.toLower;

    string ret = "extern(C) struct " ~ structType ~ " {
      " ~ Type.stringof ~ " " ~ attr ~ ";

      static VALUE new_(VALUE cl, ...) {
        " ~ structType ~ "* ptr = new " ~ structType ~ ";
        VALUE tdata = Data_Wrap_Struct(cl, null, &free, ptr);
        rb_obj_call_init(tdata, 0, null);
        return tdata;
      }

      static void free(void* p) {
        delete (cast(" ~ structType ~ "*)p)." ~ attr ~ ";
      }

      static VALUE initialize(VALUE self, ...) {
        " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
        ptr." ~ attr ~ " = new " ~ Type.stringof ~ "();
        return self;
      }
    ";
    string classStaticCtor = "
      static VALUE singInst;
      static this() {
        singInst = rb_define_class(\"" ~ Type.stringof ~ "\", rb_cObject);
        rb_define_singleton_method(singInst, \"new\".toStringz, &new_, 0);
        rb_define_method(singInst, \"initialize\".toStringz, &initialize, 0);
    ";

    string toBytes = "static VALUE toBytes(VALUE self, ...) {
      " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
      ubyte[] bytes = ptr." ~ attr ~ ".toBytes;
      VALUE array = rb_ary_new();
      foreach(ubyte b; bytes) {
        rb_ary_push(array, rb_uint_new(b));
      }
      return array;
    }";
    ret ~= toBytes;
    classStaticCtor ~= "rb_define_method(singInst, \"toBytes\".toStringz, &toBytes, 0);\n";

    string fromBytes = "static VALUE fromBytes(VALUE self, ...) {
      " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
      VALUE tmp = va_arg!VALUE(_argptr);
      VALUE val = Qnil;
      ubyte[] array = [];
      while ((val = rb_ary_shift(tmp)) != Qnil) {
        array ~= cast(ubyte)rb_num2uint(val);
      }
      ptr." ~ attr ~ " = cast(" ~ Type.stringof ~ ")(to" ~ Type.stringof ~ "(array));
      return self;
    }";
    ret ~= fromBytes;
    classStaticCtor ~= "rb_define_method(singInst, \"fromBytes\".toStringz, &fromBytes, 1);\n";

    string toJson = "static VALUE toJson(VALUE self, ...) {
      " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
      rb_eval_string((\"require 'json'\"));
      VALUE val = rb_eval_string((\"JSON.parse('\" ~ ptr." ~ attr ~ ".toJson.toString ~ \"')\").toStringz);
      return val;
    }";
    ret ~= toJson;
    classStaticCtor ~= "rb_define_method(singInst, \"toJson\".toStringz, &toJson, 0);\n";

    string fromJson = "static VALUE fromJson(VALUE self, ...) {
      " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
      VALUE tmp = va_arg!VALUE(_argptr);
      rb_eval_string((\"require 'json'\"));
      VALUE val = rb_funcall(rb_path2class(\"JSON\"), rb_intern(\"generate\"), 1, tmp);
      string json = cast(string)(rb_string_value_cstr(&val).fromStringz);
      ptr. " ~ attr ~ " = cast(" ~ Type.stringof ~ ")(to" ~ Type.stringof ~ "(parseJson(json)));
      return self;
    }";
    ret ~= fromJson;
    classStaticCtor ~= "rb_define_method(singInst, \"fromJson\".toStringz, &fromJson, 1);\n";

    string toString = "static VALUE toString(VALUE self, ...) {
      " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
      return rb_str_new_cstr(ptr." ~ attr ~ ".toString.toStringz);
    }";
    ret ~= toString;
    classStaticCtor ~= "rb_define_method(singInst, \"toString\".toStringz, &toString, 0);\n";

    foreach(name; __traits(allMembers, Type)) {
      static if (__traits(getProtection, mixin("Type." ~ name)) == "public") {
        foreach(symbol; __traits(getOverloads, Type, name)) {
          static if (isCallable!symbol && (functionAttributes!symbol & FunctionAttribute.property)) {
            static if ((ParameterTypeTuple!symbol).length > 0) {
              static if (is(ParameterTypeTuple!symbol[0] == int) ||
                is(ParameterTypeTuple!symbol[0] == short) ||
                is(ParameterTypeTuple!symbol[0] == byte)) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  ptr." ~ attr ~ "." ~ name ~ " = cast(" ~ (ParameterTypeTuple!symbol[0]).stringof ~ ")rb_num2int(tmp);
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (is(ParameterTypeTuple!symbol[0] == uint) ||
                is(ParameterTypeTuple!symbol[0] == ushort) ||
                is(ParameterTypeTuple!symbol[0] == ubyte)) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  ptr." ~ attr ~ "." ~ name ~ " = cast(" ~ (ParameterTypeTuple!symbol[0]).stringof ~ ")rb_num2uint(tmp);
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (is(ParameterTypeTuple!symbol[0] == long)) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  ptr." ~ attr ~ "." ~ name ~ " = rb_num2ll(tmp);
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (is(ParameterTypeTuple!symbol[0] == ulong)) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  ptr." ~ attr ~ "." ~ name ~ " = rb_num2ull(tmp);
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (is(ParameterTypeTuple!symbol[0] == bool)) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  ptr." ~ attr ~ "." ~ name ~ " = cast(int)rb_num2uint(tmp) > 0;
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (is(ParameterTypeTuple!symbol[0] == string)) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  ptr." ~ attr ~ "." ~ name ~ " = cast(string)(rb_string_value_cstr(&tmp).fromStringz);
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (is(CommonType!(const(ubyte[]), ParameterTypeTuple!symbol[0]) == const(ubyte[]))) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  VALUE val = Qnil;
                  ubyte[] array = [];
                  while ((val = rb_ary_shift(tmp)) != Qnil) {
                    array ~= cast(ubyte)rb_num2uint(val);
                  }
                  ptr." ~ attr ~ "." ~ name ~ " = array.to!(" ~ (ParameterTypeTuple!symbol[0]).stringof ~ ");
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (is(CommonType!(const(byte[]), ParameterTypeTuple!symbol[0]) == const(byte[]))) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  VALUE val = Qnil;
                  byte[] array = [];
                  while ((val = rb_ary_shift(tmp)) != Qnil) {
                    array ~= cast(ubyte)rb_num2uint(val);
                  }
                  ptr." ~ attr ~ "." ~ name ~ " = array.to!(" ~ (ParameterTypeTuple!symbol[0]).stringof ~ ");
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              } else static if (!is(ParameterTypeTuple!symbol[0] == Protocol)) {
                ret ~= "static VALUE " ~ name ~ "_set(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE tmp = va_arg!VALUE(_argptr);
                  VALUE val = Qnil;
                  ubyte[] array = [];
                  while ((val = rb_ary_shift(tmp)) != Qnil) {
                    array ~= cast(ubyte)rb_num2uint(val);
                  }
                  ptr." ~ attr ~ "." ~ name ~ " = to" ~ (ParameterTypeTuple!symbol[0]).stringof ~ "(array);
                  return self;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "=\".toStringz, &" ~ name ~ "_set, 1);\n";
              }
            } else {
              static if (is(ReturnType!symbol == int) ||
                is(ReturnType!symbol == short) ||
                is(ReturnType!symbol == byte)) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  return rb_int_new(ptr." ~ attr ~ "." ~ name ~ ");
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (is(ReturnType!symbol == uint) ||
                is(ReturnType!symbol == ushort) ||
                is(ReturnType!symbol == ubyte)) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  return rb_uint_new(ptr." ~ attr ~ "." ~ name ~ ");
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (is(ReturnType!symbol == long)) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  return rb_ll2inum(ptr." ~ attr ~ "." ~ name ~ ");
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (is(ReturnType!symbol == ulong)) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  return rb_ull2inum(ptr." ~ attr ~ "." ~ name ~ ");
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (is(ReturnType!symbol == bool)) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  return rb_uint_new(ptr." ~ attr ~ "." ~ name ~ " ? 1u : 0u);
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (is(ReturnType!symbol == string)) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  return rb_str_new_cstr(ptr." ~ attr ~ "." ~ name ~ ".toStringz);
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (is(CommonType!(const(ubyte[]), ReturnType!symbol) == const(ubyte[]))) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE array = rb_ary_new();
                  foreach(ubyte b; ptr." ~ attr ~ "." ~ name ~ ") {
                    rb_ary_push(array, rb_int_new(b));
                  }
                  return array;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (is(CommonType!(const(byte[]), ReturnType!symbol) == const(byte[]))) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE array = rb_ary_new();
                  foreach(byte b; ptr." ~ attr ~ "." ~ name ~ ") {
                    rb_ary_push(array, rb_int_new(b));
                  }
                  return array;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              } else static if (!is(ReturnType!symbol == Protocol)) {
                ret ~= "static VALUE " ~ name ~ "_get(VALUE self, ...) {
                  " ~ structType ~ "* ptr = Data_Get_Struct!" ~ structType ~ "(self);
                  VALUE array = rb_ary_new();
                  ubyte[] bytes = ptr." ~ attr ~ "." ~ name ~ ".toBytes;
                  foreach(ubyte b; bytes) {
                    rb_ary_push(array, rb_uint_new(b));
                  }
                  return array;
                }";
                classStaticCtor ~= "rb_define_method(singInst, \"" ~ name ~ "\".toStringz, &" ~ name ~ "_get, 0);\n";
              }
            }
          }
        }
      }
    }

    classStaticCtor ~= "}";

    ret ~= classStaticCtor;
    ret ~= "}";

    return ret;
  }
}
