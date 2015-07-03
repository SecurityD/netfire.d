module app;

import core.stdc.stdlib;
import core.stdc.string;
import core.stdc.stdarg;

import std.conv;
import std.string;
import std.stdio;

import ruby.ruby;

extern(C) {
	struct TestD {
		int a;
		int b;
	}

	VALUE test_abc(VALUE self, ...) {
		TestD* ptr = Data_Get_Struct!TestD(self);
		return rb_int_new(ptr.a);
	}

	void test_free(void *p) {
		delete p;
	}

	VALUE test_a(VALUE self, ...) {
		return rb_iv_get(self, "@a");
	}

	VALUE test_init(VALUE self, ...) {
		va_list args;

		version (X86)
			va_start(args, y);  // y is the last named parameter
		else
		version (Win64)
			va_start(args, y);  // ditto
		else
		version (X86_64)
			va_start(args, __va_argsave);
		else
			static assert(0, "Platform not supported.");

		VALUE a;
		va_arg(args, a);
		writeln("Initialize ruby class.");
		TestD* ptr = Data_Get_Struct!TestD(self);
		rb_iv_set(self, "@a".toStringz, a);
		return self;
	}

	VALUE test_new(VALUE cl, ...) {
		va_list args;

		version (X86)
			va_start(args, y);  // y is the last named parameter
		else
		version (Win64)
			va_start(args, y);  // ditto
		else
		version (X86_64)
			va_start(args, __va_argsave);
		else
			static assert(0, "Platform not supported.");

		TestD* ptr = new TestD;
		VALUE[1] argv;
		VALUE tdata = Data_Wrap_Struct(cl, null, &test_free, ptr);
		writeln("Test creation ruby class.");
		va_arg(args, argv[0]);
		rb_obj_call_init(tdata, 1, cast(VALUE*)argv);
		return tdata;
	}
}

void main(string[] args) {
	int ac = cast(int)(args.length);
	char **av;
	if ((av = cast(char **)(malloc((*av).sizeof * (ac)))) == null) {
		throw new Exception("Malloc error!");
	}
	foreach (int i, string arg ; args) { av[i] = strdup(arg.toStringz); }

	ruby_sysinit(&ac, &av);
	VALUE variable_in_this_stack_frame;
	ruby_init_stack(&variable_in_this_stack_frame);
	ruby_init();

	char **new_av;
	if ((new_av = cast(char **)(malloc((*av).sizeof * (ac + 2)))) == null) {
		throw new Exception("Malloc error!");
	}
	foreach (int i, string arg ; args) { new_av[i] = strdup(arg.toStringz); }
	new_av[ac] = strdup("-e");
	new_av[ac + 1] = strdup("require \"irb\"; IRB.start");

	VALUE test = rb_define_class("TestD", rb_cObject);
	rb_define_singleton_method(test, "new".toStringz, &test_new, 1);
	rb_define_method(test, "initialize".toStringz, &test_init, 1);
	rb_define_method(test, "abc".toStringz, &test_abc, 0);
	rb_define_method(test, "aaa".toStringz, &test_a, 0);

	ruby_run_node(ruby_options(ac+2, new_av));
}
