module ruby.ruby;

alias VALUE = ulong;

extern (C) {
  void ruby_sysinit(int *argc, char ***argv);
  void ruby_init();
  void* ruby_options(int argc, char** argv);
  int ruby_executable_node(void *n, int *status);
  int ruby_run_node(void *n);

  void ruby_init_stack(VALUE*);

  void ruby_show_version();
  void ruby_show_copyright();
}
