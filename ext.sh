#! /bin/bash

args=$1
ext_objs=${args//,/ }
ret=""

for ext in ${ext_objs}
do
  split=(${ext//\// })
  if [ -z ${split[1]} ]; then
    ret+="ruby/ext/$ext/$ext.a"
  else
    ret+="ruby/ext/$ext/${split[1]}.a"
  fi
  ret+=" "
done
echo ${ret}
