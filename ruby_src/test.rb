p "test.rb"

require_relative 'hello'

require 'csv'

csv_text = <<~CSV_TEXT
  Ruby,1995
  Rust,2010
CSV_TEXT

IO.write "sample.csv", csv_text

# ファイルから一行ずつ
CSV.foreach("sample.csv") do |row|
  p row
end
# => ["Ruby", "1995"]
#    ["Rust", "2010"]

# ファイルから一度に
p CSV.read("sample.csv")
# => [["Ruby", "1995"], ["Rust", "2010"]]

# 文字列から一行ずつ
CSV.parse(csv_text) do |row|
  p row
end

p CSV.parse(csv_text)

while true
  p 'loop'
  sleep 5
end
