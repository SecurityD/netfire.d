module app;

import core.stdc.stdlib;
import core.stdc.string;
import core.vararg;

import std.conv;
import std.string;
import std.stdio;

import ruby;

void main(string[] args) {
	bool execIrb = true;
	int ac = cast(int)(args.length);
	char **av;
	if ((av = cast(char **)(malloc((*av).sizeof * (ac)))) == null) {
		throw new Exception("Malloc error!");
	}
	foreach (int i, string arg ; args) {
		if (arg == "-e")
			execIrb = false;
		av[i] = strdup(arg.toStringz);
	}

	ruby_sysinit(&ac, &av);
	VALUE variable_in_this_stack_frame;
	ruby_init_stack(&variable_in_this_stack_frame);

	if (execIrb) {
		char **new_av;
		if ((new_av = cast(char **)(malloc((*av).sizeof * (ac + 2)))) == null) {
			throw new Exception("Malloc error!");
		}
		foreach (int i, string arg ; args) { new_av[i] = strdup(arg.toStringz); }
		new_av[ac] = strdup("-e");
		new_av[ac + 1] = strdup(`
			require "irb"
			require "irb/completion"
			IRB.start
		`);

		ruby_run_node(ruby_options(ac + 2, new_av));
	} else {
		ruby_run_node(ruby_options(ac, av));
	}
}
