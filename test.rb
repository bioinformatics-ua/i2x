#!/usr/bin/env ruby

require 'regex'

def process_functions(text)
begin
  # processing map function
  text.scan(Regex.escape('%{i2x.map\((.*?\))}')).each do |m|
    puts m
  end
rescue Exception => e
  puts e
end

end

process_functions '%{i2x.map("title",{k:v})}'