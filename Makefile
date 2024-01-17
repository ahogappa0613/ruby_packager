OUTPUT = bin
OUTPUT_O = sample.o
OBJS = *.o
FS_O = fs.o
FS_CLI = target/debug/fs_cli
RUBY_HDRS = $(shell pkg-config --cflags /workspaces/ruby_packager/dest_dir/lib/pkgconfig/ruby.pc)
# RUBY_LIBS = $(shell pkg-config --variable=LIBRUBYARG_STATIC /workspaces/ruby_packager/dest_dir/lib/pkgconfig/ruby.pc)
RUBY_LIB = /workspaces/ruby_packager/dest_dir/lib/libruby-static.a
RUBY_CONF = /workspaces/ruby_packager/ruby/configure
FS_LIB = /workspaces/ruby_packager/target/debug/libfs_lib.a
EXTS = $(shell ruby exts_dirs.rb)
EXT_OBJS = $(shell ruby exts.rb)
RUBY_SRC = ruby_src/test.rb

all: $(OUTPUT)

$(OUTPUT): main.c $(RUBY_LIB) $(FS_O) $(FS_LIB)
		gcc -v -Wall main.c $(OBJS) $(FS_LIB) $(RUBY_HDRS) $(EXT_OBJS) -lz -lrt -lgmp -ldl -lcrypt -lm -lpthread -lffi -lssl -lcrypto -lyaml -o $@

# $(OUTPUT_O): main.o $(RUBY_LIB) $(FS_O) $(FS_LIB)
# 		gcc -c -Wall $(OBJS) $(FS_LIB) $(RUBY_HDRS) $(EXT_OBJS) -lz -lrt -lgmp -ldl -lcrypt -lm -lpthread -lffi -lssl -lcrypto -lyaml -o $@

# main.o: main.c
# 		gcc -Wall -c main.c $(RUBY_HDRS) -o $@

$(FS_O): $(FS_CLI) $(RUBY_SRC)
		$(FS_CLI) /workspaces/ruby_packager ruby_src/ --start=$(RUBY_SRC)

$(FS_CLI) $(FS_LIB): ./fs_cli/src/*.rs ./fs_cli/src/*.rb ./fs_lib/src/*.rs
		cargo build -v

$(RUBY_LIB): $(RUBY_CONF)
		$(MAKE) V=1 -C ruby -i install

$(RUBY_CONF):
		cd ruby && ./autogen.sh && ./configure --prefix=/workspaces/ruby_packager/dest_dir --disable-install-doc --disable-install-rdoc --disable-install-capi --with-static-linked-ext --with-ext=$(EXTS) --with-ruby-pc=ruby.pc

PHONY: clean clear
clean:
		$(RM) $(OUTPUT)
		$(RM) $(OBJS)
		cargo clean

clear: clean
		$(RM) -r /workspaces/ruby_packager/dest_dir
		$(MAKE) -C ruby clean
		$(RM) ruby/configure

# --with-static-linked-ext --with-ext=$(EXTS)
# ./configure --prefix=/workspaces/ruby_packager/dest_dir --disable-install-doc --disable-install-rdoc --disable-install-capi --with-static-linked-ext --with-ext=Setup
# ./configure --prefix=/workspaces/ruby_packager/dest_dir --disable-install-doc --disable-install-rdoc --disable-install-capi --with-static-linked-ext --with-setup=Setup
#  ext/bigdecimal/bigdecimal.a ext/cgi/escape/escape.a ext/continuation/continuation.a ext/coverage/coverage.a ext/date/date_core.a ext/digest/digest.a ext/digest/bubblebabble/bubblebabble.a ext/digest/md5/md5.a ext/digest/rmd160/rmd160.a ext/digest/sha1/sha1.a ext/digest/sha2/sha2.a ext/etc/etc.a ext/fcntl/fcntl.a ext/io/console/console.a ext/io/nonblock/nonblock.a ext/io/wait/wait.a ext/json/generator/generator.a ext/json/parser/parser.a ext/monitor/monitor.a ext/nkf/nkf.a ext/objspace/objspace.a ext/openssl/openssl.a ext/pathname/pathname.a ext/psych/psych.a ext/rbconfig/sizeof/sizeof.a ext/ripper/ripper.a ext/stringio/stringio.a ext/strscan/strscan.a ext/zlib/zlib.a enc/encinit.o enc/libenc.a enc/libtrans.a
