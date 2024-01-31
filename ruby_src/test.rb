p "test.rb"

require_relative 'hello'

require "json"

# JSON文字列をRubyのオブジェクトに変換する
json_str = '{"name": "Ruby", "age": 30}'
p JSON.parse(json_str)

# RubyのオブジェクトをJSON文字列に変換する
data = {"name" => "Ruby", "age" => 30}
p JSON.dump(data)
while true
  p 'loop'
  sleep 5
end
