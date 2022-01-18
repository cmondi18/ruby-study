array = [1]
next_number = 1

while next_number < 100
  array << next_number
  next_number = array[-1] + array[-2]
end
