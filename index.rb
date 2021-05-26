tests = Dir["./tests/gen2*"]

puts "Content-type: text/html\n\n"
puts "Current Tests (names must match '^gen2*')"
puts "<br/><br/>"
tests.each do |t|
  name = t.gsub(/\.\/tests\//, "")
  puts "<a href='#{t}'><span id='name'>#{name}</span></a><br/>"
end
