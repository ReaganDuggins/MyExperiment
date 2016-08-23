###PigLatinRuby.rb
##Author: Reagan Duggins
##Purpose: Translates the input file to pig latin.
###

puts File.open("alice.txt", "rb").read.split(/[\s+-+]/).map(&:capitalize).join(' ').gsub(/([^aeiou\s]*)([aeiou]\S*)/,"\\2\\1ay").gsub(/\s*[AEIOU]\S*/,"\\0yay").split(/[\s+-+]/).map(&:capitalize).join(' ')