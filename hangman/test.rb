begin
  guess = gets.chomp
  if guess.length != 1
    raise "guess not 1 letter"
  end
rescue
  retry
end

puts guess