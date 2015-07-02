module app;

import core.stdc.stdlib;
import core.stdc.string;

import std.conv;
import std.string;

import ruby.ruby;

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

	ruby_run_node(ruby_options(ac+2, new_av));
}
