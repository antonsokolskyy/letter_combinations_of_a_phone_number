# frozen_string_literal: true

require_relative 'phone_parser.rb'

require 'test/unit'

class PhoneParserTester < Test::Unit::TestCase
  def test_wrong_dictionary_path
    assert_raise(Errno::ENOENT) { PhoneParser.new('dictionaries/wrong_dictionary_path.txt') }
  end

  def test_invalid_dictionary_path
    assert_raise_message('Dictionary path should be a string') { PhoneParser.new(1) }
  end

  def test_create_instance
    assert(PhoneParser.new('dictionaries/test_dictionary.txt'))
  end

  def test_has_find_method
    assert_respond_to(PhoneParser.new('dictionaries/test_dictionary.txt'), :find_matches)
  end

  def test_has_matches_attribute
    assert_respond_to(PhoneParser.new('dictionaries/test_dictionary.txt'), :matches)
  end

  def test_invalid_phone_number
    assert_equal([], PhoneParser.new('dictionaries/test_dictionary.txt').find_matches('43H53#432'))
  end

  def test_empty_number
    assert_equal([], PhoneParser.new('dictionaries/test_dictionary.txt').find_matches(''))
  end

  def test_too_long_phone_number
    assert_raise_message('Phone number should contain 10 digits MAX') do
      PhoneParser.new('dictionaries/test_dictionary.txt').find_matches('6657394857372')
    end
  end

  def test_find_matches_1
    assert_equal([%w[noun struck], %w[onto struck], %w[motor truck], %w[motor usual], %w[nouns truck], %w[nouns usual], ['motortruck']],
                 PhoneParser.new('dictionaries/test_dictionary.txt').find_matches(6_686_787_825))
  end

  def test_find_matches_2
    assert_equal([%w[act amounts], %w[act contour], %w[bat amounts], %w[bat contour], %w[cat amounts], %w[cat contour], %w[acta mounts], ['catamounts']],
                 PhoneParser.new('dictionaries/test_dictionary.txt').find_matches(2_282_668_687))
  end

  def test_no_matches
    assert_equal([], PhoneParser.new('dictionaries/test_dictionary.txt').find_matches(2_257_222_227))
  end
end
