require 'pry'

dictionary = []
File.open('./dictionary.txt') do |file|
  file.lines.each do |line|
    dictionary << line
  end
end
binding.pry
