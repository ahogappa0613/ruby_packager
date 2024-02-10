require 'fileutils'
require 'erb'

exts=[]
Dir.glob("bundle/ruby/#{RbConfig::CONFIG['ruby_version']}/gems/*/ext/*/Makefile").each do |makefile_dir|
  dir_name = File.dirname(makefile_dir)
  objs = File.read(makefile_dir).scan(/OBJS = (.*\.o)/).join(' ')
  system ['make', '-C', dir_name, objs, '--always-make'].join(' ')
  dir = FileUtils.mkdir_p('exts/' + File.basename(dir_name))
  FileUtils.cp(objs.split(' ').map{File.join(dir_name, _1)}, "#{dir[0]}")
  prefix = File.read(makefile_dir).scan(/target_prefix = (.*)/).join.delete_prefix('/')
  target_name = File.read(makefile_dir).scan(/TARGET_NAME = (.*)/).join
  exts << ["#{prefix}/#{target_name}.so", "Init_#{target_name}"]
end

File.write("main.c", ERB.new(File.read("main.c.erb")).result)
