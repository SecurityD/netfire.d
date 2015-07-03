module ruby.ruby;

import core.stdc.config;

extern (C) {
  /+ ruby.h +/
  alias VALUE = c_ulong;
  alias c_long SIGNED_VALUE;
  alias RUBY_DATA_FUNC = void function(void*);

  void ruby_sysinit(int *argc, char ***argv);
  void ruby_init();
  void* ruby_options(int argc, char** argv);
  int ruby_executable_node(void *n, int *status);
  int ruby_run_node(void *n);

  void ruby_init_stack(VALUE*);

  void ruby_show_version();
  void ruby_show_copyright();

  VALUE rb_define_class(const char*,VALUE);
  VALUE rb_define_module(const char*);
  VALUE rb_define_class_under(VALUE, const char*, VALUE);
  VALUE rb_define_module_under(VALUE, const char*);

  void rb_define_method(VALUE,const char*, VALUE function (VALUE, ...), int);
  void rb_define_module_function(VALUE,const char*, VALUE function (), int);
  void rb_define_global_function(const char*, VALUE function (), int);

  VALUE rb_gv_set(const char*, VALUE);
  VALUE rb_gv_get(const char*);
  VALUE rb_iv_get(VALUE, const char*);
  VALUE rb_iv_set(VALUE, const char*, VALUE);

  VALUE rb_data_object_wrap(VALUE, void*, RUBY_DATA_FUNC, RUBY_DATA_FUNC);
  VALUE rb_data_object_alloc(VALUE, void*, RUBY_DATA_FUNC, RUBY_DATA_FUNC);
  VALUE Data_Wrap_Struct (Mark, Free) (VALUE klass, Mark mark, Free free, void* sval) {
  	return rb_data_object_alloc(klass, sval, cast(RUBY_DATA_FUNC) mark, cast(RUBY_DATA_FUNC) free);
  }

  void rb_check_type (VALUE, int);
  void Check_Type (T) (T v, int t) {
  	rb_check_type(cast(VALUE) v, t);
  }

  T* Data_Get_Struct (T) (VALUE obj) {
  	Check_Type(obj, T_DATA);
  	return cast(T*)DATA_PTR(obj);
  }

  void* DATA_PTR (T) (T data) {
  	return RDATA(data).data;
  }

  struct RBasic {
  	VALUE flags;
  	VALUE klass;
  }

  struct RData {
  	RBasic basic;
  	void function (void*) dmark;
  	void function (void*) dfree;
  	void* data;
  }

  template R_CAST (T) {
  	alias T* R_CAST;
  }

  R_CAST!(RData) RDATA (T) (T obj) {
  	return cast(R_CAST!(RData)) obj;
  }

  extern __gshared VALUE rb_cObject;

  enum ruby_special_consts {
  	RUBY_Qfalse = 0,
  	RUBY_Qtrue = 2,
  	RUBY_Qnil = 4,
  	RUBY_Qundef = 6,

  	RUBY_IMMEDIATE_MASK = 0x03,
  	RUBY_FIXNUM_FLAG = 0x01,
  	RUBY_SYMBOL_FLAG = 0x0e,
  	RUBY_SPECIAL_SHIFT = 8
  }

  alias ruby_special_consts.RUBY_Qfalse RUBY_Qfalse;
  alias ruby_special_consts.RUBY_Qtrue RUBY_Qtrue;
  alias ruby_special_consts.RUBY_Qnil RUBY_Qnil;
  alias ruby_special_consts.RUBY_Qundef RUBY_Qundef;

  alias ruby_special_consts.RUBY_IMMEDIATE_MASK RUBY_IMMEDIATE_MASK;
  alias ruby_special_consts.RUBY_FIXNUM_FLAG RUBY_FIXNUM_FLAG;
  alias ruby_special_consts.RUBY_SYMBOL_FLAG RUBY_SYMBOL_FLAG;
  alias ruby_special_consts.RUBY_SPECIAL_SHIFT RUBY_SPECIAL_SHIFT;

  const Qfalse = cast(VALUE) ruby_special_consts.RUBY_Qfalse;
  const Qtrue = cast(VALUE) ruby_special_consts.RUBY_Qtrue;
  const Qnil = cast(VALUE) ruby_special_consts.RUBY_Qnil;
  const Qundef = cast(VALUE) ruby_special_consts.RUBY_Qundef; /* undefined value for placeholder */
  alias ruby_special_consts.RUBY_IMMEDIATE_MASK IMMEDIATE_MASK;;
  alias ruby_special_consts.RUBY_FIXNUM_FLAG FIXNUM_FLAG;
  alias ruby_special_consts.RUBY_SYMBOL_FLAG SYMBOL_FLAG;

  enum ruby_value_type {
  	RUBY_T_NONE = 0x00,

  	RUBY_T_OBJECT = 0x01,
  	RUBY_T_CLASS = 0x02,
  	RUBY_T_MODULE = 0x03,
  	RUBY_T_FLOAT = 0x04,
  	RUBY_T_STRING = 0x05,
  	RUBY_T_REGEXP = 0x06,
  	RUBY_T_ARRAY = 0x07,
  	RUBY_T_HASH = 0x08,
  	RUBY_T_STRUCT = 0x09,
  	RUBY_T_BIGNUM = 0x0a,
  	RUBY_T_FILE = 0x0b,
  	RUBY_T_DATA = 0x0c,
  	RUBY_T_MATCH = 0x0d,
  	RUBY_T_COMPLEX = 0x0e,
  	RUBY_T_RATIONAL = 0x0f,

  	RUBY_T_NIL	= 0x11,
  	RUBY_T_TRUE = 0x12,
  	RUBY_T_FALSE = 0x13,
  	RUBY_T_SYMBOL = 0x14,
  	RUBY_T_FIXNUM = 0x15,

  	RUBY_T_UNDEF = 0x1b,
  	RUBY_T_NODE = 0x1c,
  	RUBY_T_ICLASS = 0x1d,
  	RUBY_T_ZOMBIE = 0x1e,

  	RUBY_T_MASK = 0x1f
  }

  alias ruby_value_type.RUBY_T_NONE T_NONE;
  alias ruby_value_type.RUBY_T_NIL T_NIL;
  alias ruby_value_type.RUBY_T_OBJECT T_OBJECT;
  alias ruby_value_type.RUBY_T_CLASS T_CLASS;
  alias ruby_value_type.RUBY_T_ICLASS T_ICLASS;
  alias ruby_value_type.RUBY_T_MODULE T_MODULE;
  alias ruby_value_type.RUBY_T_FLOAT T_FLOAT;
  alias ruby_value_type.RUBY_T_STRING T_STRING;
  alias ruby_value_type.RUBY_T_REGEXP T_REGEXP;
  alias ruby_value_type.RUBY_T_ARRAY T_ARRAY;
  alias ruby_value_type.RUBY_T_HASH T_HASH;
  alias ruby_value_type.RUBY_T_STRUCT T_STRUCT;
  alias ruby_value_type.RUBY_T_BIGNUM T_BIGNUM;
  alias ruby_value_type.RUBY_T_FILE T_FILE;
  alias ruby_value_type.RUBY_T_FIXNUM T_FIXNUM;
  alias ruby_value_type.RUBY_T_TRUE T_TRUE;
  alias ruby_value_type.RUBY_T_FALSE T_FALSE;
  alias ruby_value_type.RUBY_T_DATA T_DATA;
  alias ruby_value_type.RUBY_T_MATCH T_MATCH;
  alias ruby_value_type.RUBY_T_SYMBOL T_SYMBOL;
  alias ruby_value_type.RUBY_T_RATIONAL T_RATIONAL;
  alias ruby_value_type.RUBY_T_COMPLEX T_COMPLEX;
  alias ruby_value_type.RUBY_T_UNDEF T_UNDEF;
  alias ruby_value_type.RUBY_T_NODE T_NODE;
  alias ruby_value_type.RUBY_T_ZOMBIE T_ZOMBIE;
  alias ruby_value_type.RUBY_T_MASK T_MASK;

  VALUE rb_int2inum (SIGNED_VALUE);

  alias rb_int2inum rb_int_new;
  VALUE rb_uint2inum (VALUE);

  alias rb_uint2inum rb_uint_new;

  /+ intern.h +/
  void rb_define_protected_method(VALUE, const char*, VALUE  function (), int);
  void rb_define_private_method(VALUE, const char*, VALUE  function (), int);
  void rb_define_singleton_method(VALUE, const char*, VALUE function (VALUE, ...), int);
  void rb_obj_call_init(VALUE, int, const VALUE*);
}
