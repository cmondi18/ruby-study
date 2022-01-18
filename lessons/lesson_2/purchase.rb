purchase_list = {}

loop do
  puts 'Print what you bought, unit price and amount. If you finished - just type \'Stop\''
  product = gets.chomp
  break if product == 'Stop'

  unit_price = gets.chomp.to_f
  amount = gets.chomp.to_i

  purchase_list[product] = { unit_price: unit_price, amount: amount}
end

if purchase_list.empty? # Don't show info about purchases if user didn't buy anything
  puts 'You saved your money today, great :)'
  exit
end

total_price = 0
puts 'You bought:'
purchase_list.each do |product, values|
  item_price = values[:unit_price] * values[:amount]
  total_price += item_price
  puts "#{product}: #{values[:amount]} unit(s) x #{values[:unit_price]}$ each. Total for this product: #{item_price}$"
end

puts "All purchases cost: #{total_price}$"
