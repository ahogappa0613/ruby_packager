print ["ruby/ext/extinit.o", "ruby/enc/encinit.o", *Dir.glob("ruby/ext/**/*.a"), *Dir.glob("ruby/enc/**/*.a")].join(' ')
# "ruby/ext/extinit.o " + Dir.glob("ruby/ext/**/*.a").join(' ') + "ruby/ext/extinit.o "

