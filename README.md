# Letter Combinations of a Phone Number (from given dictionary)

### Benchmarks (10 digits phone number(6686787825) and 178_691 words dictionary)
       user     system      total        real
    0.920000   0.000000   0.920000 (  0.924158)

Tested on iMac (27-inch, Late 2012) 3.2 GHz Intel Core i5, 16 GB 1600 MHz DDR3

### Usage
```ruby
require_relative 'phone_parser.rb'

parser = PhoneParser.new('dictionaries/full_dictionary.txt')
puts parser.find_matches(6686787825).inspect
```
#### Run tests
```
ruby tests.rb
```
#### Run benchmarks
```
ruby benchmarks.rb 
```
