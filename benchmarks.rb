# frozen_string_literal: true

require_relative 'phone_parser.rb'

require 'benchmark'

# this dictionary contains of 178_691 words
parser = PhoneParser.new('dictionaries/full_dictionary.txt')

Benchmark.bm do |x|
  x.report do
    puts parser.find_matches(2282668687).inspect
  end
  x.report do
    puts parser.find_matches(6686787825).inspect
  end
  x.report do
    puts parser.find_matches(668678).inspect
  end
  x.report do
    puts parser.find_matches(6758432).inspect
  end
end
