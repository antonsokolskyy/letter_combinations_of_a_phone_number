# frozen_string_literal: true

require 'pry'
require 'benchmark'

class PhoneParser
  attr_reader :matches
  MAX_PHONE_NUMBER_LENGTH = 10
  WORD_MIN_LENGTH = 3
  LETTERS_MAP = { '0' => [],
                  '1' => [],
                  '2' => %w[a b c],
                  '3' => %w[d e f],
                  '4' => %w[g h i],
                  '5' => %w[j k l],
                  '6' => %w[m n o],
                  '7' => %w[p q r s],
                  '8' => %w[t u v],
                  '9' => %w[w x y z] }.freeze

  def initialize(dictionary_path)
    @matches = []
    @dictionary = load_dictionary(dictionary_path)
  end

  def find_matches(phone)
    # simple digits-only validation
    phone = phone.to_i.to_s
    raise "Phone number should contain #{MAX_PHONE_NUMBER_LENGTH} digits" if phone.length != MAX_PHONE_NUMBER_LENGTH
    # select all possible letters depends on given phone number
    all_letters = phone.chars.map { |digit| LETTERS_MAP[digit] }
    # find next words recursively
    find_next_word(all_letters).inspect
  end

  private

  def load_dictionary(path)
    raise 'Dictionary path should be a string' unless path.is_a? String
    d = {}
    File.open(path) do |file|
      file.each_line do |line|
        word = line.delete("\n")&.downcase
        d.key?(word.length) ? d[word.length] << word : d[word.length] = []
      end
    end
    d.keys.each { |k| d[k].sort!.uniq! }
    d
  end

  def find_next_word(all_letters, start_from = 0, saved_words = [])
    # recursion exit when last digit reached
    return saved_words if start_from > MAX_PHONE_NUMBER_LENGTH - 1

    # iterate next word from the end of the previous word
    (start_from + 1).upto(all_letters.size - 1) do |i|
      # min word length is set to 3
      next if i - start_from < WORD_MIN_LENGTH - 1
      current_possible_letters = all_letters.dup

      # remove unnecessary letters(those are not present in dictionary) from all possible letters
      0.upto(i - start_from) do |n|
        letters_from_dictionary = @dictionary[(i + 1) - start_from].map { |word| word[n] }.uniq
        current_possible_letters[n] = all_letters[n].select { |letter| letters_from_dictionary.include?(letter) }
      end
      # create all possible words with given letters
      words = current_possible_letters[start_from].product(*current_possible_letters[(start_from + 1)..i]).map(&:join)

      words.each do |word|
        # skip if the word is not in a dictionary
        next if @dictionary[(i + 1) - start_from].bsearch { |n| word <=> n }.nil?
        # recursively find next words
        mathes_data = find_next_word(all_letters, i + 1, saved_words.dup.push(word))
        # save only the matches with necessary length
        if mathes_data.join.length == MAX_PHONE_NUMBER_LENGTH
          @matches << mathes_data
        end
      end
    end
    @matches
  end
end

parser = PhoneParser.new('./full_dictionary.txt')

Benchmark.bm do |x|
  x.report do
    # parser.find_matches(2257222227)
    puts parser.find_matches(6_686_787_825)
    # puts parser.find_matches(66867)
  end
end
