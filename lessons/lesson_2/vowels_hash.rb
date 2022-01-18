vowels = %w[a e i o u y]
vowels_hash = {}
index = 1

('a'..'z').each do |letter|
  vowels_hash[letter] = index += 1 if vowels.include?(letter)
end
