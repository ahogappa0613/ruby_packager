#include <ruby.h>
#include <string.h>

#define RUBY_DEBUG_ENV 1

extern char *get_patch_require(void);
extern void ruby_init_ext(const char *name, void (*init)(void));
extern void Init_fs(void);

int main(int argc, char *argv[])
{
  ruby_init();
  Init_fs();
  // ruby_init_ext("patch_require.so", Init_patch_require);

  // printf("patch_require: %s\n", get_patch_require());

  char *options[] = {"-v", "-e", get_patch_require()};
  void *node = ruby_options(3, options);

  int state;
  if (ruby_executable_node(node, &state))
  {
    state = ruby_exec_node(node);
  }

  return ruby_cleanup(0);
}
