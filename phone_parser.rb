require 'pry'
require 'benchmark'

class PhoneParser
  MAX_PHONE_NUMBER_LENGTH = 10
  WORD_MIN_LENGTH = 3
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
    @dictionary.keys.each { |k| @dictionary[k].sort!.uniq! }
  end

  def find_matches(phone)
    # all matched words
    matches = []
    phone = phone.to_s
    # select all possible letters depends on given phone number
    all_letters = phone.chars.map { |digit| LETTERS_MAP[digit] }
    binding.pry
    find_next_word(all_letters)
    # 1.upto(all_letters.size - 1) do |i|
#       current_possible_letters = all_letters.dup
#       0.upto(i) do |n|
#         letters_from_dictionary = @dictionary[i + 1].map { |word| word[n] }.uniq
#         current_possible_letters[n] = all_letters[n].reject { |letter| !letters_from_dictionary.include?(letter) }
#       end
#
#       words = current_possible_letters[0].product(*current_possible_letters[1..i]).map(&:join)
#       words.reject! do |word|
#         @dictionary[i + 1].bsearch { |n| word <=> n }.nil?
#       end
#       # binding.pry
#     end
    # binding.pry
    # possible_letters.shift.product(*possible_letters)
  end

  def find_next_word(all_letters, start_from = 0, saved_words = [])
    # binding.pry
    return saved_words if start_from > MAX_PHONE_NUMBER_LENGTH - 1
    (start_from + 1).upto(all_letters.size - 1) do |i|
      next if i - start_from < WORD_MIN_LENGTH - 1
      current_possible_letters = all_letters.dup
      0.upto(i - start_from) do |n|
        letters_from_dictionary = @dictionary[(i + 1) - start_from].map { |word| word[n] }.uniq
        current_possible_letters[n] = all_letters[n].reject { |letter| !letters_from_dictionary.include?(letter) }
      end
      words = current_possible_letters[start_from].product(*current_possible_letters[(start_from + 1)..i]).map(&:join)
      # binding.pry
      words.each do |word|
        next if @dictionary[(i + 1) - start_from].bsearch { |n| word <=> n }.nil?
        @asdf = find_next_word(all_letters, i + 1, saved_words.dup.push(word))
        # binding.pry
      end
      # if i == MAX_PHONE_NUMBER_LENGTH - 1
      #   # binding.pry
      #   if saved_words.join.length != MAX_PHONE_NUMBER_LENGTH
      #     saved_words.shift
      #   else
      #     saved_words = [saved_words]
      #   end
      # end
    end
    # binding.pry
    # if saved_words.join.length != MAX_PHONE_NUMBER_LENGTH
#       saved_words = []
#     else
#       saved_words = [saved_words]
#     end
    @asdf
  end
end

parser = PhoneParser.new

Benchmark.bm do |x|
  x.report do
    parser.find_matches(2257222227)
    # parser.find_matches(6686787825)
  end
end
