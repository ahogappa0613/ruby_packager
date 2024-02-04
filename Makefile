OUTPUT = bin
OBJS = *.o
FS_O = fs.o
FS_CLI = target/debug/fs_cli
RUBY_HDRS = $(shell pkg-config --cflags dest_dir/lib/pkgconfig/ruby.pc)
RUBY_LIB = dest_dir/lib/libruby-static.a
RUBY_CONF = ruby/configure
FS_LIB = target/debug/libfs_lib.a
RUBY_SRC = ruby_src/test.rb
EXTS = $(shell ruby -e'puts Dir.glob("ruby/ext/**/extconf.rb").reject { _1 =~ /-test-/ }.reject { _1 =~ /win32/ }.map { File.dirname(_1) }.map { _1.split("ruby/ext/")[1] }.join(",")')
EXT_OBJS = $(shell ruby -e'puts ["ruby/ext/extinit.o", "ruby/enc/encinit.o", *Dir.glob("ruby/ext/**/*.a"), *Dir.glob("ruby/enc/**/*.a")].join(" ")')
LOAD_PATHS = $(shell dest_dir/bin/ruby -e 'puts $$LOAD_PATH.join(" ")')
AUTOXXX = $(shell ruby -e'puts File.exist?("ruby/autogen.sh") ? "./autogen.sh" : "autoconf"')
MAINLIB = $(shell pkg-config --variable=MAINLIBS dest_dir/lib/pkgconfig/ruby.pc)
EXTLIBS = $(shell ruby -e'puts Dir.glob("ruby/ext/**/exts.mk").flat_map { File.read(_1).scan(/EXTLIBS = (.*)/) }.join(" ")')
LIBS = $(shell ruby -e'dyn,static=%w[$(MAINLIB) $(EXTLIBS)].uniq.partition { _1 =~ /-lpthread/ || _1 =~ /-ldl/ || _1 =~ /-lm/ };dyn.unshift "-Wl,-Bdynamic";static.unshift "-Wl,-Bstatic";puts static.join(" ") + " " + dyn.join(" ")')

all: $(OUTPUT)

$(OUTPUT): main.c $(RUBY_LIB) $(FS_O) $(FS_LIB)
		gcc -Wall main.c $(OBJS) $(RUBY_HDRS) $(EXT_OBJS) $(FS_LIB) $(LIBS) -o $@

$(FS_O): $(FS_CLI) $(RUBY_SRC)
		$(FS_CLI) $(PWD) ruby_src/ $(LOAD_PATHS) --start=$(RUBY_SRC)

$(FS_CLI) $(FS_LIB): ./fs_cli/src/*.rs ./fs_cli/src/*.rb ./fs_lib/src/*.rs
		cargo build -v

$(RUBY_LIB): $(RUBY_CONF)
		$(MAKE) V=1 -C ruby -i install

$(RUBY_CONF):
		cd ruby && $(AUTOXXX) && ./configure --prefix=$(PWD)/dest_dir --disable-install-doc --disable-install-rdoc --disable-install-capi --with-static-linked-ext --with-ext=$(EXTS) --with-ruby-pc=ruby.pc

PHONY: clean clear
clean:
		$(RM) $(OUTPUT)
		$(RM) $(OBJS)
		cargo clean

clear: clean
		$(RM) -r dest_dir
		$(RM) $(RUBY_CONF)
		$(MAKE) -C ruby clean
