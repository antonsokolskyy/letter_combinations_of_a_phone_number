require 'pry'
require 'benchmark'

class PhoneParser
  LETTERS_MAP = { '2' => ['a', 'b', 'c'],
                  '3' => ['d', 'e', 'f'],
                  '4' => ['g', 'h', 'i'],
                  '5' => ['j', 'k', 'l'],
                  '6' => ['m', 'n', 'o'],
                  '7' => ['p', 'q', 'r', 's'],
                  '8' => ['t', 'u', 'v'],
                  '9' => ['w', 'x', 'y', 'z']
                }

  def initialize
    @dictionary = {}
    File.open('./dictionary.txt') do |file|
      file.each_line do |line|
        word = line.delete("\n")&.downcase
        if @dictionary.key?(word.length)
          @dictionary[word.length] << word
        else
          @dictionary[word.length] = []
        end
      end
    end
  end

  def find_matches(phone)
    # all matched words
    matches = []
    phone = phone.to_s
    # select all possible letters depends on given phone number
    possible_letters = phone.chars.map { |digit| LETTERS_MAP[digit] }
    
    2.upto(possible_letters.size) do |i|
      letters_on_i_position = @dictionary[i].map { |word| word[-1] }.uniq
      possible_letters[i - 1] = possible_letters[i - 1].reject { |letter| !letters_on_i_position.include?(letter) }

      words = possible_letters[0].product(*possible_letters[1..(i - 1)]).map(&:join)
      words.reject! { |word| !@dictionary[i].include?(word) }
      # binding.pry
    end
    # binding.pry
    # possible_letters.shift.product(*possible_letters)
  end

  def find_next_word(words = [])
    
  end
end

parser = PhoneParser.new

Benchmark.bm do |x|
  x.report do
    parser.find_matches(2282668687)
  end
end