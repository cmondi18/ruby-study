vowels = %w[a e i o u y]
vowels_hash = {}

('a'..'z').each.with_index(1) do |letter, index|
  vowels_hash[letter] = index if vowels.include?(letter)
end
