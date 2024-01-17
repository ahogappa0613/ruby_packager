print Dir.glob("ruby/ext/**/extconf.rb").reject { _1 =~ /-test-/ }.reject { _1 =~ /win32/ }.map { File.dirname(_1) }.map { _1.split('ruby/ext/')[1] }.join(',')
