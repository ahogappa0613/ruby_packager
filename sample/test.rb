p "test.rb"

require_relative 'hello'

require "json"

# JSON文字列をRubyのオブジェクトに変換する
json_str = '{"name": "Ruby", "age": 30}'
p JSON.parse(json_str)

# RubyのオブジェクトをJSON文字列に変換する
data = {"name" => "Ruby", "age" => 30}
p JSON.dump(data)

require 'sqlite3'

db = SQLite3::Database.new "test.db"

# Create a table
rows = db.execute <<-SQL
  create table numbers (
    name varchar(30),
    val int
  );
SQL
